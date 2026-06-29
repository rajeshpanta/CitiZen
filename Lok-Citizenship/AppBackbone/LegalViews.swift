import SwiftUI

// ═════════════════════════════════════════════════════════════════
// MARK: - Privacy Policy
// ═════════════════════════════════════════════════════════════════

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    var language: AppLanguage = .english
    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(privacyText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(20)
            }
            .navigationTitle(s.paywallPrivacy)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(s.resultDone) { dismiss() }
                }
            }
        }
    }

    private var privacyText: String {
        """
        Privacy Policy for CitiZen
        Last Updated: June 29, 2026

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
        - Any data from other apps on your device

        2. Microphone, Speech, and Voice

        CitiZen uses your device's microphone and speech recognition to let you practice answering citizenship test questions out loud — simulating the real USCIS interview experience.

        - For practice quizzes and reading/writing exercises, your spoken answers are transcribed on your device using Apple's Speech framework. Your voice audio does not leave your device for these features.
        - To read questions aloud in a natural voice (text-to-speech), the question and answer TEXT — not your voice — may be sent over a secure connection to our backend (hosted on Supabase) and OpenAI's text-to-speech service. If this is unavailable, the app falls back to the built-in system voice.
        - For the Mock Interview feature, your spoken answer is recorded as a short audio clip and sent over a secure connection to our backend (Supabase), which forwards it to OpenAI's Whisper service for transcription. The transcript — together with the question and answer choices — may also be sent to OpenAI's language model to evaluate whether your answer is correct. Audio and transcripts are processed transiently and are not retained by us; they are subject to OpenAI's API data policy (OpenAI states API data is not used to train their models and is retained only as needed to provide the service).
        - We log non-content metadata for each request (timestamp, audio size in bytes, language code, and a per-install random identifier) for abuse prevention and rate limiting. We do not log or store the audio content or the resulting transcript.
        - You can avoid sending anything off-device by tapping answer choices instead of speaking, and you can use the built-in system voice instead of the enhanced voice.

        3. In-App Purchases

        CitiZen offers optional in-app purchases (monthly subscription and lifetime access). Purchases are processed entirely by Apple through the App Store. We do not collect or store any payment information.

        - Subscription management is handled through your Apple ID settings
        - We receive confirmation of your purchase status from Apple to unlock features
        - No credit card numbers, billing addresses, or financial data passes through our app

        4. Analytics

        We collect anonymous usage data to improve the app. This is sent to our backend (Supabase) and includes:

        - Which features are used (e.g., quiz started/completed, voice used, language selected)
        - In-app purchase events (e.g., purchase started, completed, restored)
        - App version and a per-install random device identifier
        - No name, email, location, or other personally identifiable information is included
        - This data is not used to track you across other apps or websites, and is not sold to third parties

        5. Data Storage

        Your quiz progress, scores, and preferences are stored locally on your device using standard iOS storage. We do not store these on our servers.

        Voice requests pass through our backend on Supabase, which logs only the non-content metadata listed in section 2 (no audio, no transcript). Anonymous analytics events (section 4) are stored on our backend. If you delete the app, locally stored data is permanently removed.

        6. Third-Party Service Providers

        We use the following service providers to operate the voice and analytics features:
        - Supabase (backend and edge-function hosting; receives audio, text, and metadata in transit, and stores analytics events and request metadata)
        - OpenAI (Whisper speech-to-text for transcription, a language model for answer matching, and text-to-speech for spoken question playback; receives audio, transcripts, and question text)

        Both are bound by their respective privacy and data-processing terms.

        7. Children's Privacy

        CitiZen is not directed at children under 13. We do not knowingly collect personal information from children. The app is designed for adults preparing for the U.S. citizenship test.

        8. Advertising

        CitiZen does not integrate with third-party advertising networks. We do not share your data with advertisers.

        9. Your Rights

        You have full control over your data:
        - Delete the app to remove all locally stored data
        - Deny microphone permission to disable voice features
        - Use the Mock Interview by tapping answer choices instead of speaking, if you do not wish to send audio to our service providers
        - Manage your subscription through Apple ID settings

        10. Changes to This Policy

        We may update this Privacy Policy from time to time. Changes will be reflected in the "Last Updated" date above. Continued use of the app after changes constitutes acceptance.

        11. Contact Us

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
    var language: AppLanguage = .english
    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(termsText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(20)
            }
            .navigationTitle(s.paywallTerms)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(s.resultDone) { dismiss() }
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
