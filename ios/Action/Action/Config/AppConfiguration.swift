import Foundation

struct AppConfiguration: Sendable {
    let supabaseURL: URL
    let supabaseAnonKey: String

    /// Populated from Info.plist via `$(SUPABASE_URL)` / `$(SUPABASE_ANON_KEY)` in `Shared.xcconfig` / `Secrets.xcconfig`.
    static var current: AppConfiguration {
        let bundle = Bundle.main
        let urlString = (bundle.object(forInfoDictionaryKey: "SUPABASE_URL") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let key = (bundle.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if let url = URL(string: urlString), urlString.isEmpty == false, key.isEmpty == false {
            return AppConfiguration(supabaseURL: url, supabaseAnonKey: key)
        }

        #if DEBUG
        return .placeholder
        #else
        fatalError("Missing SUPABASE_URL or SUPABASE_ANON_KEY in Info.plist / xcconfig.")
        #endif
    }

    static let placeholder = AppConfiguration(
        supabaseURL: URL(string: "https://example.supabase.co")!,
        supabaseAnonKey: "placeholder-anon-key"
    )
}
