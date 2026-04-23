import SwiftUI

@main
struct ActionApp: App {
    @StateObject private var model = AppModel()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(model)
                    .environmentObject(model.locationManager)
                    .environmentObject(model.syncService)
                    .tint(Color(red: 0.0, green: 0.45, blue: 0.90))
            } else {
                OnboardingView()
                    .environmentObject(model)
                    .environmentObject(model.locationManager)
                    .environmentObject(model.syncService)
                    .tint(Color(red: 0.0, green: 0.45, blue: 0.90))
            }
        }
    }
}
