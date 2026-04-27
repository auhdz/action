import Combine
import Foundation

/// Owns shared services so `LocationSyncService` receives the same `LocationManager` instance as the UI.
@MainActor
final class AppModel: ObservableObject {
    @Published var locationManager: LocationManager
    @Published var syncService: LocationSyncService

    init() {
        let lm = LocationManager()
        self.locationManager = lm
        self.syncService = LocationSyncService(
            locationManager: lm,
            configuration: AppConfiguration.current
        )
    }
}
