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
            }
        }
    }
}

// MARK: - LocationPermissionView

struct LocationPermissionView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))

                    VStack(spacing: 12) {
                        Text("Ubicación en tiempo real")
                            .font(.system(size: 24, weight: .semibold, design: .default))
                            .foregroundStyle(.primary)

                        Text("Acción necesita acceso a tu ubicación para compartir tu posición con tus contactos de confianza en tiempo real.")
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            onboardingState.step = .complete
                        }
                    }) {
                        Text("Permitir ubicación")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.0, green: 0.45, blue: 0.90))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        onboardingState.step = .complete
                    }) {
                        Text("Más tarde")
                            .font(.system(size: 16, weight: .semibold, design: .default))
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
    }
}

// MARK: - Placeholder ContactPickerView

struct ContactPickerView: View {
    @ObservedObject var onboardingState: OnboardingState

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                Text("Select Contacts")
                    .font(.title2)
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: {
                    onboardingState.step = .locationPermission
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.0, green: 0.45, blue: 0.90))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppModel())
}
