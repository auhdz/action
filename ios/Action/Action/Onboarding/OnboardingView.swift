import Combine
import SwiftUI

// MARK: - OnboardingStep Enum

enum OnboardingStep {
    case welcome
    case contacts
    case locationPermission
    case complete
}

// MARK: - OnboardingState Class

final class OnboardingState: ObservableObject {
    @Published var step: OnboardingStep = .welcome
    @Published var selectedContacts: [TrustedContact] = []
    @Published var isLoading = false
}

// MARK: - OnboardingView

struct OnboardingView: View {
    @StateObject var onboardingState = OnboardingState()
    @EnvironmentObject var appModel: AppModel
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            switch onboardingState.step {
            case .welcome:
                WelcomeView(onboardingState: onboardingState)
            case .contacts:
                ContactPickerView(onboardingState: onboardingState)
            case .locationPermission:
                LocationPermissionView(onboardingState: onboardingState)
            case .complete:
                ContentView()
                    .onAppear { hasSeenOnboarding = true }
            }
        }
    }
}

// MARK: - LocationPermissionView

struct LocationPermissionView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var lang: LanguageManager
    @State private var authorizationObserver: AnyCancellable?

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    LanguageToggle()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))

                    VStack(spacing: 12) {
                        Text(lang.isSpanish ? "Ubicación en tiempo real" : "Real-Time Location")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text(lang.isSpanish
                             ? "Acción necesita acceso a tu ubicación para compartir tu posición con tus contactos de confianza en tiempo real."
                             : "Acción needs location access to share your position with your trusted contacts in real time.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: {
                        appModel.locationManager.requestAuthorizationIfNeeded()
                        authorizationObserver = appModel.locationManager.$authorizationStatus
                            .filter { $0 != .notDetermined }
                            .first()
                            .sink { _ in onboardingState.step = .complete }
                    }) {
                        Text(lang.isSpanish ? "Permitir ubicación" : "Allow Location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.0, green: 0.45, blue: 0.90))
                            .cornerRadius(12)
                    }

                    Button(action: { onboardingState.step = .complete }) {
                        Text(lang.isSpanish ? "Más tarde" : "Not Now")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.0, green: 0.45, blue: 0.90).opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onDisappear { authorizationObserver?.cancel() }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppModel())
        .environmentObject(LanguageManager())
}
