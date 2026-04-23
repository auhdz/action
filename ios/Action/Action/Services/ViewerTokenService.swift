import Combine
import CryptoKit
import Foundation
import Supabase

// MARK: - ViewerTokenRow Model

struct ViewerTokenRow: Codable {
    let id: String
    let user_id: String
    let token: String
    let created_at: String
}

// MARK: - ViewerTokenService

@MainActor
final class ViewerTokenService: ObservableObject {
    @Published var viewerToken: String?
    @Published var isLoading = false

    private let configuration: AppConfiguration
    private let supabase: SupabaseClient

    init(configuration: AppConfiguration) {
        self.configuration = configuration
        self.supabase = SupabaseClient(
            supabaseURL: configuration.supabaseURL,
            supabaseKey: configuration.supabaseAnonKey
        )
    }

    // MARK: - Public Methods

    func ensureViewerTokenExists() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Ensure we have an authenticated session
            try await ensureAnonymousSessionIfNeeded()

            // Get the current user ID
            let session = try await supabase.auth.session
            let userId = session.user.id.uuidString

            // Query for existing token
            let response = try await supabase
                .from("viewer_tokens")
                .select()
                .eq("user_id", value: userId)
                .limit(1)
                .execute()

            let decoder = JSONDecoder()
            let tokens = try decoder.decode([ViewerTokenRow].self, from: response.data)

            if let existingToken = tokens.first {
                // Token exists, use it
                viewerToken = existingToken.token
            } else {
                // Token doesn't exist, insert a new one with generated token
                let newToken = generateSecureToken()
                let insertResponse = try await supabase
                    .from("viewer_tokens")
                    .insert(["user_id": userId, "token": newToken])
                    .select()
                    .single()
                    .execute()

                let newRow = try decoder.decode(ViewerTokenRow.self, from: insertResponse.data)
                viewerToken = newRow.token
            }
        } catch {
            // Silently handle errors
            #if DEBUG
            print("ViewerTokenService error: \(error.localizedDescription)")
            #endif
        }
    }

    func getViewerLink() -> URL? {
        guard let token = viewerToken else { return nil }
        return URL(string: "https://accion.app/watch/\(token)")
    }

    // MARK: - Private Methods

    private func generateSecureToken() -> String {
        // Generate 24 bytes of random data and encode as hex
        // Matches server-side gen_random_bytes(24) approach
        let randomBytes = (0..<24).map { _ in UInt8.random(in: 0...255) }
        return randomBytes.map { String(format: "%02x", $0) }.joined()
    }

    private func ensureAnonymousSessionIfNeeded() async throws {
        do {
            _ = try await supabase.auth.session
            return
        } catch {
            // No session; try anonymous sign-in.
        }

        do {
            _ = try await supabase.auth.signInAnonymously()
        } catch {
            throw error
        }
    }
}
