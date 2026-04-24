import SwiftUI
import StoreKit

/// High-conversion paywall with context-sensitive messaging.
struct PaywallView: View {

    var trigger: String = "unknown"
    /// Language the paywall should render in. Callers pass the current app language.
    /// Defaults to English if the user somehow opens the paywall before picking a language.
    var language: AppLanguage = .english

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = StoreManager.shared

    @State private var errorMessage: String?
    @State private var purchasing = false
    @State private var showPrivacy = false
    @State private var showTerms = false
    @State private var selectedProductID: String = StoreManager.lifetimeID

    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Close button
                    HStack {
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .disabled(purchasing)
                        .accessibilityLabel(s.a11yClose)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    // Icon
                    Image(systemName: iconName)
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 8)

                    // Headline
                    Text(headline)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Text(subheadline)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    // Feature list
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(paywallFeatures, id: \.self) { feature in
                            featureRow(feature)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 8)

                    // Products
                    productSection
                        .padding(.horizontal, 20)

                    // Cost comparison
                    costComparison
                        .padding(.horizontal, 24)

                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    // Restore + Legal
                    VStack(spacing: 8) {
                        Button(s.paywallRestore) {
                            Task {
                                await store.restorePurchases()
                                if store.isPro { dismiss() }
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.5))

                        HStack(spacing: 12) {
                            Button(s.paywallPrivacy) { showPrivacy = true }
                            Text("·").foregroundColor(.white.opacity(0.3))
                            Button(s.paywallTerms) { showTerms = true }
                        }
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.35))
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 30)
                }
            }
        }
        .task {
            Analytics.track(.paywallShown(trigger: trigger))
            await store.loadProducts()
        }
        .onChange(of: store.isPro) { isPro in
            if isPro { dismiss() }
        }
        .interactiveDismissDisabled(purchasing)
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
        .sheet(isPresented: $showTerms) { TermsOfUseView() }
        .alert(s.paywallVerificationIssue,
               isPresented: Binding(
                   get: { store.entitlementVerificationFailed },
                   set: { if !$0 { store.clearEntitlementError() } }
               )
        ) {
            Button(s.paywallRestore) {
                Task { await store.restorePurchases() }
            }
            Button(s.paywallDismiss, role: .cancel) { }
        } message: {
            Text(s.paywallErrorVerificationFailed)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Product Buttons
    // ═════════════════════════════════════════════════════════════

    @ViewBuilder
    private var productSection: some View {
        if !store.products.isEmpty {
            VStack(spacing: 12) {
                // Plan selector cards
                if let lifetime = store.products.first(where: { $0.id == StoreManager.lifetimeID }) {
                    planCard(
                        id: StoreManager.lifetimeID,
                        title: s.paywallLifetime,
                        subtitle: s.paywallLifetimeSubtitle,
                        price: lifetime.displayPrice,
                        badge: s.paywallBestValue
                    )
                }

                if let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }) {
                    planCard(
                        id: StoreManager.monthlyID,
                        title: s.paywallMonthly,
                        subtitle: String(format: s.paywallMonthlySubtitleFormat, monthly.displayPrice),
                        price: s.paywallFree,
                        badge: s.paywall3DaysFree
                    )
                }

                // Single CTA button
                Button {
                    Task {
                        guard let product = store.products.first(where: { $0.id == selectedProductID }) else { return }
                        await purchase(product)
                    }
                } label: {
                    Text(ctaButtonLabel)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.green, .green.opacity(0.75)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }
                .disabled(purchasing)
                .padding(.top, 4)

                // Subscription disclosure (Apple Guideline 3.1.2(c))
                if selectedProductID == StoreManager.monthlyID,
                   let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }) {
                    Text(String(format: s.paywallDisclosureFormat, monthly.displayPrice))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.35))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                        .padding(.top, 2)
                }
            }
        } else if store.isLoadingProducts {
            VStack(spacing: 8) {
                ProgressView().tint(.white)
                Text(s.paywallLoadingPricing)
                    .font(.footnote).foregroundColor(.gray)
            }
        } else {
            VStack(spacing: 12) {
                Text(s.paywallPricingUnavailable)
                    .font(.footnote).foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Button(s.paywallTryAgain) {
                    Task { await store.loadProducts(forceReload: true) }
                }
                .font(.footnote).foregroundColor(.blue)
            }
        }
    }

    private var ctaButtonLabel: String {
        if purchasing { return s.paywallProcessing }
        if selectedProductID == StoreManager.monthlyID { return s.paywallStartFreeTrial }
        return s.paywallContinue
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Cost Comparison (anchoring)
    // ═════════════════════════════════════════════════════════════

    private var costComparison: some View {
        VStack(spacing: 6) {
            HStack {
                Text(s.paywallCostFilingFee)
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
                Text("$710")
                    .foregroundColor(.white.opacity(0.4))
                    .strikethrough(color: .red.opacity(0.6))
            }
            HStack {
                Text(s.paywallCostAttorney)
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
                Text("$1,500+")
                    .foregroundColor(.white.opacity(0.4))
                    .strikethrough(color: .red.opacity(0.6))
            }
            HStack {
                Text(s.paywallCostAppBrand)
                    .foregroundColor(.green)
                    .bold()
                Spacer()
                if let lifetime = store.products.first(where: { $0.id == StoreManager.lifetimeID }) {
                    Text(lifetime.displayPrice)
                        .foregroundColor(.green)
                        .bold()
                }
            }
        }
        .font(.footnote)
        .padding(16)
        .background(Color.white.opacity(0.04))
        .cornerRadius(12)
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Dynamic Content
    // ═════════════════════════════════════════════════════════════

    private var iconName: String {
        switch trigger {
        case "mock_interview": return "mic.badge.plus"
        case "locked_level":   return "lock.open.fill"
        default:               return "star.fill"
        }
    }

    private var headline: String {
        switch trigger {
        case "locked_level":   return s.paywallHeadlineLockedLevel
        case "mock_interview": return s.paywallHeadlineMockInterview
        default:               return s.paywallHeadlineDefault
        }
    }

    private var subheadline: String {
        switch trigger {
        case "locked_level":   return s.paywallSubheadlineLockedLevel
        case "mock_interview": return s.paywallSubheadlineMockInterview
        default:               return s.paywallSubheadlineDefault
        }
    }

    private var paywallFeatures: [String] {
        switch trigger {
        case "mock_interview": return s.paywallFeaturesMockInterview
        case "locked_level":   return s.paywallFeaturesLockedLevel
        default:               return s.paywallFeaturesDefault
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Helpers
    // ═════════════════════════════════════════════════════════════

    private func purchase(_ product: Product) async {
        purchasing = true
        errorMessage = nil
        do {
            let success = try await store.purchase(product)
            if success {
                dismiss()
            } else {
                errorMessage = s.paywallPurchaseIncomplete
            }
        } catch {
            errorMessage = s.paywallPurchaseFailed
        }
        purchasing = false
    }

    private func planCard(id: String, title: String, subtitle: String, price: String, badge: String?) -> some View {
        let isSelected = selectedProductID == id

        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { selectedProductID = id }
        } label: {
            HStack(spacing: 12) {
                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.green : Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow)
                                .cornerRadius(4)
                        }
                    }
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                Text(price)
                    .font(.title3.bold())
                    .foregroundColor(isSelected ? .green : .white.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.green.opacity(0.1) : Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.green.opacity(0.6) : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
    }

    private func featureRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.body)
            Text(text)
                .foregroundColor(.white.opacity(0.85))
                .font(.subheadline)
            Spacer(minLength: 0)
        }
    }
}
