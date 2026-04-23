import Combine
import Foundation

/// Owns shared services so `LocationSyncService` receives the same `LocationManager` instance as the UI.
final class AppModel: ObservableObject {
    let locationManager: LocationManager
    let syncService: LocationSyncService

    init() {
        let lm = LocationManager()
        locationManager = lm
        syncService = LocationSyncService(
            locationManager: lm,
            configuration: AppConfiguration.current
        )
    }
}
