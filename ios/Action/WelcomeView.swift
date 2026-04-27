import SwiftUI

struct WelcomeView: View {
    @ObservedObject var onboardingState: OnboardingState

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("Acción")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundStyle(.primary)

                    Text("Tu seguridad. Tus contactos de confianza. En tiempo real.")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)

                // Feature Cards
                VStack(spacing: 16) {
                    FeatureCard(
                        icon: "mappin.circle.fill",
                        title: "Ubicación en vivo",
                        description: "Comparte tu ubicación con quien confías"
                    )

                    FeatureCard(
                        icon: "bell.fill",
                        title: "Botón de emergencia",
                        description: "Alerta a tus contactos al instante"
                    )

                    FeatureCard(
                        icon: "lock.fill",
                        title: "Privado y seguro",
                        description: "Solo tú controlas quién ve tu ubicación"
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue Button
                Button(action: {
                    onboardingState.step = .contacts
                }) {
                    Text("Continuar")
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
        }
    }
}

// MARK: - FeatureCard

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))
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
            .background(Color(red: 0.0, green: 0.45, blue: 0.90).opacity(0.05))
            .cornerRadius(12)
        }
    }
}

#Preview {
    @Previewable @StateObject var onboardingState = OnboardingState()

    WelcomeView(onboardingState: onboardingState)
}
