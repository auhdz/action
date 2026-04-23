import SwiftUI

@main
struct ActionApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(model)
                .environmentObject(model.locationManager)
                .environmentObject(model.syncService)
                .tint(Color(red: 0.0, green: 0.45, blue: 0.90))
        }
    }
}
