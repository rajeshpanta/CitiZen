import Foundation

/// Supabase project credentials.
///
/// The anon key is shipped in every iOS install — it's not a secret, it's the
/// public client identity. Server-side protection comes from JWT verification
/// + RLS in the Edge Function and SQL.
///
/// Override at runtime via Info.plist keys `SUPABASE_URL` / `SUPABASE_ANON_KEY`
/// (useful for staging vs prod). Defaults below are placeholders — fill in
/// before shipping.
enum SupabaseConfig {

    private static let placeholderURL = "https://YOUR-PROJECT-REF.supabase.co"
    private static let placeholderAnonKey = "YOUR_SUPABASE_ANON_KEY"

    static let url: URL = {
        let raw = (Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String)
            ?? placeholderURL
        return URL(string: raw) ?? URL(string: placeholderURL)!
    }()

    static let anonKey: String = {
        (Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String)
            ?? placeholderAnonKey
    }()

    static var isConfigured: Bool {
        url.absoluteString != placeholderURL && anonKey != placeholderAnonKey
    }
}
