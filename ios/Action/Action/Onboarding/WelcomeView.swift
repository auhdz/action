import SwiftUI

struct WelcomeView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var lang: LanguageManager

    var body: some View {
        ZStack {
            Color.safeCream
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Language toggle
                HStack {
                    Spacer()
                    LanguageToggle()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Header
                VStack(spacing: 12) {
                    Text("Acción")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundStyle(.primary)

                    Text(lang.isSpanish
                         ? "Tu seguridad. Tus contactos de confianza. En tiempo real."
                         : "Your safety. Your trusted contacts. In real time.")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)

                // Feature Cards
                VStack(spacing: 16) {
                    FeatureCard(
                        icon: "mappin.circle.fill",
                        title: lang.isSpanish ? "Ubicación en vivo" : "Live Location",
                        description: lang.isSpanish
                            ? "Comparte tu ubicación con quien confías"
                            : "Share your location with people you trust"
                    )

                    FeatureCard(
                        icon: "bell.fill",
                        title: lang.isSpanish ? "Botón de emergencia" : "Emergency Button",
                        description: lang.isSpanish
                            ? "Alerta a tus contactos al instante"
                            : "Alert your contacts instantly"
                    )

                    FeatureCard(
                        icon: "lock.fill",
                        title: lang.isSpanish ? "Privado y seguro" : "Private & Secure",
                        description: lang.isSpanish
                            ? "Solo tú controlas quién ve tu ubicación"
                            : "Only you control who sees your location"
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: {
                    onboardingState.step = .tos
                }) {
                    Text(lang.isSpanish ? "Continuar" : "Continue")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.actionRed)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - FeatureCard

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.actionRed)
                .frame(width: 40, alignment: .center)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.actionRed.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Language Toggle (shared across onboarding screens)

struct LanguageToggle: View {
    @EnvironmentObject var lang: LanguageManager

    var body: some View {
        Menu {
            Button(action: { lang.isSpanish = false }) {
                Label("English", systemImage: lang.isSpanish ? "" : "checkmark")
            }
            Button(action: { lang.isSpanish = true }) {
                Label("Español", systemImage: lang.isSpanish ? "checkmark" : "")
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "globe")
                    .font(.system(size: 13))
                Text(lang.isSpanish ? "ES" : "EN")
                    .font(.system(size: 13, weight: .semibold))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.actionRed.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(Color.actionRed)
        }
    }
}

#Preview {
    @Previewable @StateObject var onboardingState = OnboardingState()

    WelcomeView(onboardingState: onboardingState)
        .environmentObject(LanguageManager())
}
