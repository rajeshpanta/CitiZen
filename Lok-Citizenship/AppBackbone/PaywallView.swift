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
    // Restore button feedback. `restoring` drives the spinner and
    // disables the button during the AppStore.sync hop (otherwise the
    // tap looks dead — App Review has historically flagged restore
    // flows with no visible feedback). `restoreNothing` shows a small
    // confirmation line when the restore completes but no entitlement
    // was found, so the user knows the round-trip actually happened.
    @State private var restoring = false
    @State private var restoreNothing = false

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

                    // Icon with soft glow. Glow uses the same gradient so it
                    // reads as ambient light, not a drop shadow.
                    Image(systemName: iconName)
                        .font(.system(size: 56, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.45), radius: 18, x: 0, y: 0)
                        .padding(.top, 4)

                    // Headline
                    Text(headline)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    // 5-star social proof. Honest claim — all current ratings
                    // are 5★. Sample size not quoted on purpose; the visual
                    // is the signal, the label confirms.
                    ratingRow
                        .padding(.top, -4)

                    Text(subheadline)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
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

                    // Restore + Legal. Restore Purchases is a non-revenue
                    // path BUT a leading driver of 1-star reviews when
                    // users on a second device can't find it — making it
                    // higher contrast (and pairing it with a visible icon)
                    // prevents the "you took my money twice" complaint.
                    // Legal links stay subdued; that's the right hierarchy.
                    VStack(spacing: 14) {
                        Button {
                            guard !restoring else { return }
                            restoreNothing = false
                            restoring = true
                            Task {
                                await store.restorePurchases()
                                restoring = false
                                if store.isPro {
                                    dismiss()
                                } else if let err = store.restoreError {
                                    errorMessage = err
                                } else if !store.entitlementVerificationFailed {
                                    // No entitlement and no verification error
                                    // → genuinely nothing to restore. Show the
                                    // inline confirmation so the tap has a
                                    // visible outcome. Verification failures
                                    // already surface via the existing alert.
                                    restoreNothing = true
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                if restoring {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                                Text(s.paywallRestore)
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(.white.opacity(restoring ? 0.55 : 0.9))
                        }
                        .disabled(restoring)

                        if restoreNothing {
                            Text(s.paywallRestoreNothing)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.55))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }

                        HStack(spacing: 12) {
                            Button(s.paywallPrivacy) { showPrivacy = true }
                            Text("·").foregroundColor(.white.opacity(0.3))
                            Button(s.paywallTerms) { showTerms = true }
                        }
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
            }
        }
        .task {
            Analytics.track(.paywallShown(trigger: trigger))
            await store.loadProducts()
        }
        .onChange(of: store.isPro) { isPro in
            if isPro {
                restoring = false
                dismiss()
            }
        }
        .interactiveDismissDisabled(purchasing)
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView(language: language) }
        .sheet(isPresented: $showTerms) { TermsOfUseView(language: language) }
        .alert(s.paywallVerificationIssue,
               isPresented: Binding(
                   get: { store.entitlementVerificationFailed },
                   set: { if !$0 { store.clearEntitlementError() } }
               )
        ) {
            Button(s.paywallRestore) {
                restoreNothing = false
                restoring = true
                Task {
                    await store.restorePurchases()
                    restoring = false
                    // isPro path: onChange(of: store.isPro) already calls
                    // dismiss() — no need to call it again here.
                    if !store.isPro {
                        if let err = store.restoreError {
                            errorMessage = err
                        } else if !store.entitlementVerificationFailed {
                            restoreNothing = true
                        }
                    }
                }
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
                        badge: s.paywallBestValue,
                        savingsBadge: savingsBadgeText
                    )
                }

                if let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }) {
                    let trialDays = monthlyTrialDays
                    planCard(
                        id: StoreManager.monthlyID,
                        title: s.paywallMonthly,
                        subtitle: trialDays.map { String(format: s.paywallMonthlySubtitleFormat, String($0), monthly.displayPrice) }
                            ?? String(format: s.paywallMonthlySubtitleNoTrialFormat, monthly.displayPrice),
                        price: trialDays != nil ? s.paywallFree : monthly.displayPrice,
                        badge: trialDays.map { String(format: s.paywallFreeTrialBadgeFormat, String($0)) },
                        savingsBadge: nil
                    )
                }

                // Trust-badge row. Sits directly above the CTA so the trust
                // signal is the last thing the user reads before tapping.
                trustBadgesRow
                    .padding(.top, 6)

                // Single CTA button — gradient + arrow + soft glow.
                Button {
                    Task {
                        guard let product = store.products.first(where: { $0.id == selectedProductID }) else { return }
                        await purchase(product)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(ctaButtonLabel)
                            .font(.title3.bold())
                        if !purchasing {
                            Image(systemName: "arrow.right")
                                .font(.headline.weight(.bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.18, green: 0.78, blue: 0.36),
                                     Color(red: 0.10, green: 0.62, blue: 0.28)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: .green.opacity(0.35), radius: 14, x: 0, y: 6)
                }
                .disabled(purchasing)
                .padding(.top, 2)

                // Subscription disclosure (Apple Guideline 3.1.2(c))
                if selectedProductID == StoreManager.monthlyID,
                   let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }) {
                    Text(monthlyTrialDays.map { String(format: s.paywallDisclosureFormat, monthly.displayPrice, String($0)) }
                            ?? String(format: s.paywallDisclosureNoTrialFormat, monthly.displayPrice))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.35))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                        .padding(.top, 2)
                }
            }
        } else if store.productLoadFailed {
            // Only show the failure state when a load actually FAILED — not when
            // products simply haven't been fetched yet (first render, before the
            // view's .task runs). Reading the dedicated flag instead of falling
            // through on empty-products stops the paywall from flashing a red
            // "pricing unavailable" error on its very first frame.
            VStack(spacing: 12) {
                Text(s.paywallPricingUnavailable)
                    .font(.footnote).foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Button(s.paywallTryAgain) {
                    Task { await store.loadProducts(forceReload: true) }
                }
                .font(.footnote).foregroundColor(.blue)
            }
        } else {
            // Loading, or load not yet attempted — show a spinner either way.
            VStack(spacing: 8) {
                ProgressView().tint(.white)
                Text(s.paywallLoadingPricing)
                    .font(.footnote).foregroundColor(.gray)
            }
        }
    }

    private var ctaButtonLabel: String {
        if purchasing { return s.paywallProcessing }
        if selectedProductID == StoreManager.monthlyID {
            return monthlyTrialDays != nil ? s.paywallStartFreeTrial : s.paywallContinue
        }
        return s.paywallContinue
    }

    /// Free-trial length in days for the monthly product, read live from the
    /// loaded StoreKit introductory offer so the paywall copy always matches
    /// App Store Connect and can never drift from a hardcoded value. Returns
    /// nil when the monthly product has no free-trial introductory offer.
    private var monthlyTrialDays: Int? {
        guard let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }),
              let offer = monthly.subscription?.introductoryOffer,
              offer.paymentMode == .freeTrial else { return nil }
        let period = offer.period
        switch period.unit {
        case .day:   return period.value
        case .week:  return period.value * 7
        case .month: return period.value * 30
        case .year:  return period.value * 365
        @unknown default: return period.value
        }
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

    /// Triggers that map to the same content bucket. Kept as computed
    /// vars (not stored constants) so the switch cases stay co-located
    /// with the content selection below — easier to spot a missing case
    /// in code review than a divergent constant.
    private var isMockTrigger: Bool {
        trigger == "mock_interview" || trigger == "mock_interview_retry"
    }
    private var isLockedLevelTrigger: Bool {
        trigger == "locked_level" || trigger == "next_level_from_quiz"
    }

    private var iconName: String {
        if isMockTrigger        { return "mic.badge.plus" }
        if isLockedLevelTrigger { return "lock.open.fill" }
        return "star.fill"
    }

    private var headline: String {
        if isLockedLevelTrigger { return s.paywallHeadlineLockedLevel }
        if isMockTrigger        { return s.paywallHeadlineMockInterview }
        return s.paywallHeadlineDefault
    }

    private var subheadline: String {
        if isLockedLevelTrigger { return s.paywallSubheadlineLockedLevel }
        if isMockTrigger        { return s.paywallSubheadlineMockInterview }
        return s.paywallSubheadlineDefault
    }

    private var paywallFeatures: [String] {
        if isMockTrigger        { return s.paywallFeaturesMockInterview }
        if isLockedLevelTrigger { return s.paywallFeaturesLockedLevel }
        return s.paywallFeaturesDefault
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Helpers
    // ═════════════════════════════════════════════════════════════

    private func purchase(_ product: Product) async {
        purchasing = true
        errorMessage = nil
        // Switch on the typed outcome so each failure mode gets copy
        // that tells the user what to actually do next — rather than
        // a generic "Purchase failed" that drives them to either
        // retry endlessly or give up.
        switch await store.purchase(product) {
        case .success:
            dismiss()
        case .cancelled:
            // User dismissed the sheet on purpose. Don't shame them
            // with an error banner — just clear state.
            break
        case .pending:
            errorMessage = s.paywallErrorPending
        case .networkError:
            errorMessage = s.paywallErrorNetwork
        case .verificationFailed:
            errorMessage = s.paywallErrorVerificationFailed
        case .unknown:
            errorMessage = s.paywallPurchaseFailed
        }
        purchasing = false
    }

    private func planCard(id: String, title: String, subtitle: String, price: String, badge: String?, savingsBadge: String?) -> some View {
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

                VStack(alignment: .leading, spacing: 3) {
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
                        // Dynamic savings badge — only shown when computed
                        // from real StoreKit prices (never faked).
                        if let savingsBadge {
                            Text(savingsBadge)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.85))
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

    // ═════════════════════════════════════════════════════════════
    // MARK: - Trust signals
    // ═════════════════════════════════════════════════════════════

    /// 5 filled yellow stars + label. Sits under the headline.
    /// Sample size deliberately not quoted — current rating is 5★, the
    /// stars are the signal.
    private var ratingRow: some View {
        HStack(spacing: 6) {
            ForEach(0..<5, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.yellow)
            }
            Text(s.paywallRated5Stars)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 4)
        }
    }

    /// Three compact trust pills above the CTA. All claims verified
    /// against current code: StoreKit payment (Apple), no third-party
    /// analytics/ads (ConsoleAnalytics only), monthly is cancel-anytime
    /// per Apple subscription rules.
    private var trustBadgesRow: some View {
        HStack(spacing: 10) {
            trustBadge(icon: "lock.shield.fill", text: s.paywallTrustApple)
            trustBadge(icon: "hand.raised.fill", text: s.paywallTrustNoTracking)
            trustBadge(icon: "arrow.clockwise", text: s.paywallTrustCancel)
        }
        .frame(maxWidth: .infinity)
    }

    private func trustBadge(icon: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
            Text(text)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }

    /// Computes "SAVE NN%" for the lifetime card by comparing lifetime
    /// price against 12 months of the monthly subscription. Returns nil
    /// if either product isn't loaded, prices look wrong, or lifetime
    /// isn't actually cheaper (defensive — never show a misleading badge).
    private var savingsBadgeText: String? {
        guard let monthly = store.products.first(where: { $0.id == StoreManager.monthlyID }),
              let lifetime = store.products.first(where: { $0.id == StoreManager.lifetimeID }) else {
            return nil
        }
        let m = NSDecimalNumber(decimal: monthly.price).doubleValue
        let l = NSDecimalNumber(decimal: lifetime.price).doubleValue
        guard m > 0, l > 0 else { return nil }
        let yearOfMonthly = m * 12
        guard yearOfMonthly > l else { return nil }
        let pct = Int(((yearOfMonthly - l) / yearOfMonthly) * 100)
        guard pct >= 10 else { return nil }   // don't show a piddly "save 4%"
        return String(format: s.paywallSaveFormat, "\(pct)%")
    }
}
