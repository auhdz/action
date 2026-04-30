import SwiftUI

// MARK: - Brand Colors

extension Color {
    static let actionRed    = Color(red: 142/255, green: 42/255,  blue: 11/255)
    static let safetyOrange = Color(red: 243/255, green: 154/255, blue: 30/255)
    static let trustyYellow = Color(red: 255/255, green: 209/255, blue: 102/255)
    static let trustNavy    = Color(red: 13/255,  green: 27/255,  blue: 42/255)
    static let safeCream    = Color(red: 247/255, green: 243/255, blue: 237/255)
}

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
                    .tint(Color.actionRed)
            } else {
                OnboardingView()
                    .environmentObject(model)
                    .environmentObject(model.locationManager)
                    .environmentObject(model.syncService)
                    .environmentObject(lang)
                    .tint(Color.actionRed)
            }
        }
    }
}
