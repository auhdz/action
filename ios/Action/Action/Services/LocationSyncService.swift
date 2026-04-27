import Combine
import CoreLocation
import Foundation
import Supabase

@MainActor
final class LocationSyncService: ObservableObject {
    @Published var lastSuccessfulPing: Date?
    @Published var lastError: String?

    private let locationManager: LocationManager
    private let configuration: AppConfiguration
    private let supabase: SupabaseClient

    private var cancellables = Set<AnyCancellable>()

    private var lastSentAt: Date = .distantPast
    private var lastSentLocation: CLLocation?

    private let minimumInterval: TimeInterval = 5
    private let heartbeatInterval: TimeInterval = 60
    private let minimumDistance: CLLocationDistance = 25

    init(locationManager: LocationManager, configuration: AppConfiguration) {
        self.locationManager = locationManager
        self.configuration = configuration
        self.supabase = SupabaseClient(
            supabaseURL: configuration.supabaseURL,
            supabaseKey: configuration.supabaseAnonKey
        )

        locationManager.$location
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self, let location else { return }
                Task { await self.handle(location: location) }
            }
            .store(in: &cancellables)
    }

    private func handle(location: CLLocation) async {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastSentAt)

        if elapsed < minimumInterval { return }

        if let previous = lastSentLocation {
            let distance = location.distance(from: previous)
            let movedEnough = distance >= minimumDistance
            let heartbeat = elapsed >= heartbeatInterval
            if !movedEnough, !heartbeat { return }
        }

        await send(location: location, now: now)
    }

    private func send(location: CLLocation, now: Date) async {
        await sendPing(location: location, now: now, pingType: "normal")
    }

    func insertAlertPing() async throws {
        guard let location = locationManager.location else {
            lastError = "No location available"
            throw NSError(domain: "LocationSyncService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location available"])
        }
        await sendPing(location: location, now: Date(), pingType: "alert")
    }

    func resetAlertPing() async throws {
        guard let location = locationManager.location else {
            lastError = "No location available"
            throw NSError(domain: "LocationSyncService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location available"])
        }
        await sendPing(location: location, now: Date(), pingType: "normal")
    }

    private func sendPing(location: CLLocation, now: Date, pingType: String) async {
        lastError = nil

        if configuration.supabaseAnonKey == AppConfiguration.placeholder.supabaseAnonKey {
            lastError = "Configure Supabase URL and anon key (see Secrets.xcconfig)."
            return
        }

        do {
            try await ensureAnonymousSessionIfNeeded()

            let row = LocationPingRow(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                accuracyM: location.horizontalAccuracy,
                recordedAt: LocationPingRow.iso8601.string(from: location.timestamp),
                pingType: pingType
            )

            try await supabase
                .from("location_pings")
                .insert(row)
                .execute()

            lastSentAt = now
            lastSentLocation = location
            lastSuccessfulPing = now
        } catch {
            lastError = error.localizedDescription
        }
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
            lastError = "Auth: enable Anonymous sign-in in Supabase Auth settings. (\(error.localizedDescription))"
            throw error
        }
    }
}

private struct LocationPingRow: Encodable {
    static let iso8601: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    let latitude: Double
    let longitude: Double
    let accuracyM: Double
    let recordedAt: String
    let pingType: String

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case accuracyM = "accuracy_m"
        case recordedAt = "recorded_at"
        case pingType = "ping_type"
    }
}
