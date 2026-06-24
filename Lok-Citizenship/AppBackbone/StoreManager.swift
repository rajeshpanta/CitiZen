import StoreKit

/// Manages StoreKit 2 products, purchases, and entitlement status.
/// Access via `StoreManager.shared`.
@MainActor
final class StoreManager: ObservableObject {

    static let shared = StoreManager()

    // MARK: - Product IDs (must match App Store Connect exactly)

    static let monthlyID  = "com.citizen.pro.monthly.v2"
    static let lifetimeID = "com.citizen.pro.lifetime"

    // MARK: - Published state

    @Published private(set) var products: [Product] = []
    @Published private(set) var isPro = false
    /// The product ID of the currently-active entitlement, e.g.
    /// `com.citizen.pro.monthly.v2` or `com.citizen.pro.lifetime`. `nil`
    /// when the user has no active entitlement, OR when Pro is unlocked
    /// only via the DEBUG dev-force flag (no real transaction). Settings
    /// uses this to show the user which plan they're on and to gate the
    /// "Manage Subscription" affordance to renewable plans.
    @Published private(set) var activeProductID: String?
    /// True when the most recent product-load attempt failed (network error, zero products
    /// returned, etc). Paywall renders a localized "pricing unavailable" message when set.
    /// The specific internal reason isn't exposed — Paywall shows the same user-facing text.
    @Published private(set) var productLoadFailed: Bool = false
    @Published private(set) var isLoadingProducts = false
    /// True when receipt verification failed for any entitlement. Paywall shows a
    /// localized "verification issue" alert when set.
    @Published private(set) var entitlementVerificationFailed: Bool = false
    /// Set to a user-facing message when `restorePurchases()` throws. Cleared
    /// before each restore attempt so callers can check it immediately after await.
    @Published private(set) var restoreError: String?

    // MARK: - Private

    private var transactionListener: Task<Void, Never>?

    private init() {
        transactionListener = listenForTransactions()

        #if DEBUG
        if UserDefaults.standard.bool(forKey: "dev_force_pro") {
            isPro = true
        }
        #endif

        Task {
            await refreshEntitlements()
        }
    }

    #if DEBUG
    /// Debug-only override: unlocks Pro without a real purchase. Persists across launches.
    func setDevForcePro(_ on: Bool) {
        UserDefaults.standard.set(on, forKey: "dev_force_pro")
        isPro = on ? true : isPro  // don't revoke real entitlements
        if !on {
            Task { await refreshEntitlements() }
        }
    }

    var isDevForcePro: Bool {
        UserDefaults.standard.bool(forKey: "dev_force_pro")
    }
    #endif

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load products from App Store

    func loadProducts(forceReload: Bool = false) async {
        if isLoadingProducts { return }
        if !forceReload && !products.isEmpty { return }

        isLoadingProducts = true
        productLoadFailed = false

        let ids: Set<String> = [Self.monthlyID, Self.lifetimeID]

        do {
            let loadedProducts = try await Product.products(for: ids)
                .sorted { $0.price < $1.price }

            #if DEBUG
            print("[StoreKit] Loaded \(loadedProducts.count) products: \(loadedProducts.map { $0.id })")
            #endif

            products = loadedProducts
            productLoadFailed = loadedProducts.isEmpty
        } catch {
            #if DEBUG
            print("[StoreManager] Failed to load products: \(error)")
            #endif
            products = []
            productLoadFailed = true
        }

        isLoadingProducts = false
    }

    // MARK: - Purchase

    /// Distinct outcomes from a purchase attempt. Lets the paywall
    /// surface actionable copy ("check your connection") instead of
    /// a generic "try again" — reduces frustrated retries on the
    /// failure paths that aren't actually the user's fault.
    enum PurchaseOutcome {
        case success            // dismiss paywall
        case cancelled          // silent — user dismissed the sheet
        case pending            // ask-to-buy / parental approval queued
        case verificationFailed // signed-transaction check failed
        case networkError       // URLError / StoreKit network failure
        case unknown            // anything else
    }

    func purchase(_ product: Product) async -> PurchaseOutcome {
        Analytics.track(.purchaseStarted(productID: product.id))

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                do {
                    let transaction = try checkVerified(verification)
                    await transaction.finish()
                    await refreshEntitlements()
                    Analytics.track(.purchaseCompleted(productID: product.id))
                    return .success
                } catch {
                    Analytics.track(.purchaseFailed(productID: product.id))
                    return .verificationFailed
                }

            case .userCancelled:
                // No analytics event — user-cancelled isn't a failure
                // we want to track as friction. Surfacing it would
                // bias the funnel toward looking worse than reality.
                return .cancelled

            case .pending:
                Analytics.track(.purchasePending(productID: product.id))
                return .pending

            @unknown default:
                Analytics.track(.purchaseFailed(productID: product.id))
                return .unknown
            }
        } catch {
            Analytics.track(.purchaseFailed(productID: product.id))
            // Recognise the two network-y error shapes StoreKit can
            // surface. Anything else falls to .unknown so the user
            // sees the generic "try again" copy.
            if let storeError = error as? StoreKitError {
                switch storeError {
                case .networkError: return .networkError
                case .userCancelled: return .cancelled
                default: return .unknown
                }
            }
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet,
                     .networkConnectionLost,
                     .timedOut,
                     .cannotConnectToHost:
                    return .networkError
                default:
                    return .unknown
                }
            }
            return .unknown
        }
    }

    // MARK: - Restore

    func restorePurchases() async {
        restoreError = nil
        do {
            try await AppStore.sync()
            await refreshEntitlements()

            if isPro {
                Analytics.track(.purchaseRestored)
            }
        } catch {
            #if DEBUG
            print("[StoreManager] Restore failed: \(error)")
            #endif
            restoreError = error.localizedDescription
        }
    }

    // MARK: - Entitlement check

    func refreshEntitlements() async {
        var hasPro = false
        var verifyFailed = false
        var activeID: String?

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.revocationDate == nil {
                    hasPro = true
                    // Prefer lifetime over monthly — only overwrite if we don't
                    // already have the lifetime product, so a user who holds both
                    // entitlements always lands on lifetime as authoritative.
                    if activeID != StoreManager.lifetimeID {
                        activeID = transaction.productID
                    }
                }
            } catch {
                #if DEBUG
                print("[StoreManager] Entitlement verification failed: \(error)")
                #endif
                verifyFailed = true
            }
        }

        #if DEBUG
        if UserDefaults.standard.bool(forKey: "dev_force_pro") {
            hasPro = true
            // Intentionally don't set `activeID` for dev-force — there's
            // no real transaction, so Settings hides the plan row.
        }
        #endif

        isPro = hasPro
        activeProductID = activeID
        entitlementVerificationFailed = hasPro ? false : verifyFailed
    }

    // MARK: - Transaction listener

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { continue }

                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                    await self.refreshEntitlements()
                } catch {
                    #if DEBUG
                    print("[StoreManager] Transaction update verification failed: \(error)")
                    #endif
                    await MainActor.run {
                        self.entitlementVerificationFailed = true
                    }
                }
            }
        }
    }

    func clearEntitlementError() {
        entitlementVerificationFailed = false
    }

    // MARK: - Verification

    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified(_, let error):
            throw error
        }
    }
}
