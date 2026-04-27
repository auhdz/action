import SwiftUI

// MARK: - Language Manager

final class LanguageManager: ObservableObject {
    @Published var isSpanish: Bool {
        didSet { UserDefaults.standard.set(isSpanish, forKey: "appIsSpanish") }
    }

    init() {
        isSpanish = UserDefaults.standard.bool(forKey: "appIsSpanish")
    }
}

// MARK: - App Entry Point

@main
struct ActionApp: App {
    @StateObject private var model = AppModel()
    @StateObject private var lang = LanguageManager()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(model)
                    .environmentObject(model.locationManager)
                    .environmentObject(model.syncService)
                    .environmentObject(lang)
                    .tint(Color(red: 0.0, green: 0.45, blue: 0.90))
            } else {
                OnboardingView()
                    .environmentObject(model)
                    .environmentObject(model.locationManager)
                    .environmentObject(model.syncService)
                    .environmentObject(lang)
                    .tint(Color(red: 0.0, green: 0.45, blue: 0.90))
            }
        }
    }
}
