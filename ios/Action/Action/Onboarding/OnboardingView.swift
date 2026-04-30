import Combine
import SwiftUI

// MARK: - OnboardingStep Enum

enum OnboardingStep {
    case welcome
    case tos
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
            case .tos:
                TOSView(onboardingState: onboardingState)
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

// MARK: - TOSView

struct TOSView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var lang: LanguageManager
    @State private var agreed = false

    private var tosItems: [(Bool, String)] {
        lang.isSpanish ? [
            (true,  "Acción es una app de seguridad personal. Compartes tu ubicación solo con las personas que tú eliges, cuando tú decides."),
            (true,  "Tu ubicación solo se comparte cuando activas una alerta de seguridad."),
            (true,  "No se recopila ni almacena información personal más allá de tu sesión activa."),
            (false, "Acción no rastrea, monitorea ni reporta a ningún individuo."),
            (false, "Acción no garantiza tu seguridad ni la respuesta de tus contactos."),
            (false, "Acción no reemplaza los servicios de emergencia. Si estás en peligro inmediato, llama al 911 cuando sea seguro hacerlo."),
        ] : [
            (true,  "Acción is a personal safety app. You share your location only with people YOU choose, when YOU choose."),
            (true,  "Your location is only shared when you activate a safety alert."),
            (true,  "No personal information is collected or stored beyond your active session."),
            (false, "Acción does not track, monitor, or report on any individuals."),
            (false, "Acción cannot guarantee your safety or the response of your contacts."),
            (false, "Acción is not a replacement for emergency services. If you are in immediate danger, call 911 when safe to do so."),
        ]
    }

    var body: some View {
        ZStack {
            Color.safeCream.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    LanguageToggle()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(lang.isSpanish ? "Antes de continuar" : "Before You Continue")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(.top, 8)

                        Text(lang.isSpanish
                             ? "Aquí está lo que Acción es y no es:"
                             : "Here's what Acción is and isn't:")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(tosItems.indices, id: \.self) { i in
                                let (isPositive, text) = tosItems[i]
                                HStack(alignment: .top, spacing: 10) {
                                    Text(isPositive ? "✓" : "✗")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(isPositive
                                            ? Color.actionRed
                                            : .red)
                                        .frame(width: 16)
                                    Text(text)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.03))
                        .cornerRadius(12)

                        Text(lang.isSpanish
                             ? "Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad completos."
                             : "By continuing, you agree to our full Terms of Service and Privacy Policy.")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }

                VStack(spacing: 16) {
                    // Explicit checkbox — required per legal doc
                    Button(action: { agreed.toggle() }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(agreed
                                        ? Color.actionRed
                                        : Color.gray.opacity(0.4), lineWidth: 1.5)
                                    .frame(width: 22, height: 22)
                                if agreed {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color.actionRed)
                                }
                            }
                            Text(lang.isSpanish
                                 ? "He leído y acepto los Términos y la Política de Privacidad"
                                 : "I have read and agree to the Terms & Privacy Policy")
                                .font(.system(size: 14))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Button(action: { onboardingState.step = .contacts }) {
                        Text(lang.isSpanish ? "Acepto" : "I Agree")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(agreed
                                ? Color.actionRed
                                : Color.gray.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .disabled(!agreed)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
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
            Color.safeCream.ignoresSafeArea()

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
                        .foregroundColor(Color.actionRed)

                    VStack(spacing: 12) {
                        Text(lang.isSpanish ? "Acceso a ubicación" : "Location Access")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text(lang.isSpanish
                             ? "Acción necesita tu ubicación solo cuando actives una alerta de seguridad. Nunca te rastreamos en segundo plano."
                             : "Acción needs your location only when you activate a safety alert. We never track you in the background.")
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
                            .background(Color.actionRed)
                            .cornerRadius(12)
                    }

                    Button(action: { onboardingState.step = .complete }) {
                        Text(lang.isSpanish ? "Más tarde" : "Not Now")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.actionRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.actionRed.opacity(0.1))
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
