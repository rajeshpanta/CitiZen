import SwiftUI

// ═════════════════════════════════════════════════════════════════
// MARK: - Privacy Policy
// ═════════════════════════════════════════════════════════════════

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                Text(privacyText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(20)
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var privacyText: String {
        """
        Privacy Policy for CitiZen
        Last Updated: April 9, 2026

        SmallPanta ("we", "our", or "us") built the CitiZen app to help users prepare for the United States citizenship test. This Privacy Policy explains how we handle your information when you use our app.

        1. Information We Collect

        CitiZen is designed with privacy in mind. We collect minimal data:

        Device-Local Data Only:
        - Quiz scores and progress (stored on your device only)
        - Study streak and statistics (stored on your device only)
        - Language preferences (stored on your device only)
        - Daily question count (stored on your device only)

        We do NOT collect:
        - Your name, email, or any personal contact information
        - Your location
        - Your voice recordings (speech is processed on-device and never stored or transmitted)
        - Any data from other apps on your device

        2. Microphone and Speech Recognition

        CitiZen uses your device's microphone and speech recognition to let you practice answering citizenship test questions out loud — simulating the real USCIS interview experience.

        - Voice data is processed on-device using Apple's Speech framework
        - We prefer on-device speech recognition when available
        - No voice recordings are stored, saved, or transmitted to any server
        - You can use the app without the microphone by tapping answers instead

        3. In-App Purchases

        CitiZen offers optional in-app purchases (monthly subscription and lifetime access). Purchases are processed entirely by Apple through the App Store. We do not collect or store any payment information.

        - Subscription management is handled through your Apple ID settings
        - We receive confirmation of your purchase status from Apple to unlock features
        - No credit card numbers, billing addresses, or financial data passes through our app

        4. Analytics

        We collect anonymous, aggregated usage data to improve the app:

        - Which features are used (e.g., quiz started, quiz completed)
        - General app performance metrics
        - No personally identifiable information is included
        - No data is sold to third parties

        5. Data Storage

        All your quiz progress, scores, and preferences are stored locally on your device using standard iOS storage. We do not operate servers that store your personal data.

        If you delete the app, all locally stored data is permanently removed.

        6. Children's Privacy

        CitiZen is not directed at children under 13. We do not knowingly collect personal information from children. The app is designed for adults preparing for the U.S. citizenship test.

        7. Third-Party Services

        CitiZen does not integrate with third-party advertising networks. We do not share your data with advertisers.

        8. Your Rights

        Since we store data only on your device, you have full control:
        - Delete the app to remove all data
        - Deny microphone permission to disable voice features
        - Manage your subscription through Apple ID settings

        9. Changes to This Policy

        We may update this Privacy Policy from time to time. Changes will be reflected in the "Last Updated" date above. Continued use of the app after changes constitutes acceptance.

        10. Contact Us

        If you have questions about this Privacy Policy, contact us at:
        support@citizenapp.us
        """
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Terms of Use
// ═════════════════════════════════════════════════════════════════

struct TermsOfUseView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                Text(termsText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(20)
            }
            .navigationTitle("Terms of Use")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var termsText: String {
        """
        Terms of Use for CitiZen
        Last Updated: April 9, 2026

        Please read these Terms of Use carefully before using the CitiZen app operated by SmallPanta ("we", "our", or "us").

        1. Acceptance of Terms

        By downloading, installing, or using CitiZen, you agree to these Terms of Use. If you do not agree, do not use the app.

        2. Description of Service

        CitiZen is a study tool designed to help users prepare for the United States Citizenship (Naturalization) Test. The app provides practice questions, voice-based interview simulation, and progress tracking.

        3. Not Legal Advice

        CitiZen is an educational tool only. It does not provide legal advice, immigration counsel, or any guarantee of passing the USCIS citizenship test. The questions in the app are based on publicly available USCIS study materials but are not endorsed by or affiliated with USCIS or any government agency.

        For legal advice regarding your citizenship application, consult a qualified immigration attorney.

        4. Subscriptions and Purchases

        CitiZen offers optional in-app purchases:

        Monthly Subscription:
        - Billed monthly at the price displayed at time of purchase
        - Automatically renews unless cancelled at least 24 hours before the end of the current billing period
        - Manage or cancel anytime through your Apple ID Account Settings

        Lifetime Access:
        - One-time purchase granting permanent access to all features
        - Non-refundable except as required by applicable law

        Payment is charged to your Apple ID account at confirmation of purchase. Prices may vary by region and are subject to change.

        5. Free Features

        CitiZen offers limited free access including:
        - Practice levels 1 and 2
        - Up to 10 questions per day
        - Basic voice features

        Free features may change at our discretion.

        6. Intellectual Property

        All content in CitiZen, including but not limited to text, graphics, user interface design, and software code, is owned by SmallPanta and protected by copyright law.

        The citizenship test questions are based on publicly available USCIS study materials.

        7. Acceptable Use

        You agree not to:
        - Reverse-engineer, decompile, or disassemble the app
        - Use the app for any unlawful purpose
        - Redistribute or resell any content from the app
        - Attempt to circumvent any access restrictions or security measures

        8. Disclaimer of Warranties

        CitiZen is provided "as is" without warranties of any kind, whether express or implied. We do not guarantee that:
        - The app will be error-free or uninterrupted
        - The questions will match exactly what appears on your actual USCIS test
        - Using the app will result in passing the citizenship test

        9. Limitation of Liability

        To the maximum extent permitted by law, SmallPanta shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the app, including but not limited to failure to pass the citizenship test.

        10. Termination

        We reserve the right to terminate or suspend access to the app at any time, without notice, for conduct that we believe violates these Terms or is harmful to other users or our business.

        11. Changes to Terms

        We may modify these Terms at any time. Changes take effect when posted in the app. Continued use after changes constitutes acceptance of the new Terms.

        12. Governing Law

        These Terms are governed by the laws of the United States and the State in which SmallPanta operates, without regard to conflict of law provisions.

        13. Contact Us

        If you have questions about these Terms, contact us at:
        support@citizenapp.us
        """
    }
}
