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
    @Published private(set) var productLoadError: String?
    @Published private(set) var isLoadingProducts = false
    @Published private(set) var entitlementError: String?

    // MARK: - Private

    private var transactionListener: Task<Void, Never>?

    private init() {
        transactionListener = listenForTransactions()

        Task {
            await refreshEntitlements()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load products from App Store

    func loadProducts(forceReload: Bool = false) async {
        if isLoadingProducts { return }
        if !forceReload && !products.isEmpty { return }

        isLoadingProducts = true
        productLoadError = nil

        let ids: Set<String> = [Self.monthlyID, Self.lifetimeID]

        do {
            let loadedProducts = try await Product.products(for: ids)
                .sorted { $0.price < $1.price }

            #if DEBUG
            print("[StoreKit] Loaded \(loadedProducts.count) products: \(loadedProducts.map { $0.id })")
            #endif

            products = loadedProducts

            if loadedProducts.isEmpty {
                productLoadError = """
                Could not load pricing.
                Check your product IDs, App Store Connect setup, or StoreKit test configuration.
                """
            }
        } catch {
            #if DEBUG
            print("[StoreManager] Failed to load products: \(error)")
            #endif
            products = []
            productLoadError = "Could not load pricing. Please try again."
        }

        isLoadingProducts = false
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async throws -> Bool {
        Analytics.track(.purchaseStarted(productID: product.id))

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await refreshEntitlements()
            Analytics.track(.purchaseCompleted(productID: product.id))
            return true

        case .userCancelled:
            Analytics.track(.purchaseFailed(productID: product.id))
            return false

        case .pending:
            Analytics.track(.purchaseFailed(productID: product.id))
            return false

        @unknown default:
            Analytics.track(.purchaseFailed(productID: product.id))
            return false
        }
    }

    // MARK: - Restore

    func restorePurchases() async {
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
        }
    }

    // MARK: - Entitlement check

    func refreshEntitlements() async {
        var hasPro = false
        var verifyError: String?

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.revocationDate == nil {
                    hasPro = true
                    break
                }
            } catch {
                #if DEBUG
                print("[StoreManager] Entitlement verification failed: \(error)")
                #endif
                verifyError = "Purchase could not be verified. Please try restoring purchases."
            }
        }

        isPro = hasPro
        entitlementError = hasPro ? nil : verifyError
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
                        self.entitlementError = "Purchase could not be verified. Please try restoring purchases."
                    }
                }
            }
        }
    }

    func clearEntitlementError() {
        entitlementError = nil
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
