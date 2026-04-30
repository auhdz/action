import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var syncService: LocationSyncService
    @EnvironmentObject private var lang: LanguageManager

    @State private var sosStartTime: Date?
    @State private var isSosActive = false
    @State private var sosCountdown: Int = 60
    @State private var sosHoldProgress: Double = 0
    @State private var timer: Timer?
    @State private var smsPending = false
    @State private var kyrScenario: KYRScenario = .street

    private let annotationProvider: MapAnnotationProviding = EmptyMapAnnotationProvider()
    private let sosHoldDuration: Double = 3.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.safeCream
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Acción")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.trustNavy)
                    Text(timeBasedGreeting)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.trailing, 196)

                if isSosActive {
                    alertBanner
                } else {
                    safetyStatusCard
                }

                kyrCard

                Spacer(minLength: 0)

                sosButton
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .onAppear {
                locationManager.requestAuthorizationIfNeeded()
            }

            CornerMapView(
                location: locationManager.location,
                annotationProvider: annotationProvider
            )
            .frame(width: 180, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
            .padding(.trailing, 16)
            .padding(.top, 16)
        }
    }

    // MARK: - Subviews

    private var safetyStatusCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Circle()
                    .fill(locationStatusColor)
                    .frame(width: 8, height: 8)
                Text(lang.isSpanish ? "Estás protegido" : "You are safe")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            if let detail = locationStatusDetail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            if let err = syncService.lastError {
                Text(err)
                    .font(.caption)
                    .foregroundStyle(Color.safetyOrange)
            }
        }
        .padding(16)
        .background(Color.trustNavy)
        .cornerRadius(14)
    }

    private var kyrCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color.actionRed)
                Text(lang.isSpanish ? "Tus derechos" : "Know Your Rights")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.trustNavy)
                Spacer()
            }

            kyrScenarioPicker

            VStack(alignment: .leading, spacing: 8) {
                ForEach(kyrItems, id: \.phrase) { item in
                    KYRItem(phrase: item.phrase, detail: item.detail)
                }
            }

            Button(action: {
                Task { await activateSOS() }
            }) {
                Text(lang.isSpanish
                     ? "Estoy siendo detenido — alertar a mis contactos"
                     : "I am being detained — alert my contacts")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.actionRed)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 40)
                    .background(Color.actionRed.opacity(0.07))
                    .cornerRadius(8)
            }

            Text(lang.isSpanish
                 ? "Fuente: CHIRLA — chirla.org · Línea de ayuda: 888-624-4752"
                 : "Source: CHIRLA — chirla.org · Hotline: 888-624-4752")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black.opacity(0.07), lineWidth: 1)
        )
    }

    private var kyrScenarioPicker: some View {
        HStack(spacing: 0) {
            ForEach(KYRScenario.allCases, id: \.self) { scenario in
                Button(action: { kyrScenario = scenario }) {
                    HStack(spacing: 4) {
                        Image(systemName: scenario.icon)
                            .font(.system(size: 11))
                        Text(scenario.label(isSpanish: lang.isSpanish))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(kyrScenario == scenario ? Color.actionRed : .secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(kyrScenario == scenario ? Color.actionRed.opacity(0.09) : Color.clear)
                    .cornerRadius(6)
                }
            }
        }
        .padding(3)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
    }

    private var kyrItems: [(phrase: String, detail: String)] {
        switch kyrScenario {
        case .home:
            return lang.isSpanish ? [
                (phrase: "NO abras la puerta.",
                 detail: "ICE debe tener una orden judicial de un juez para entrar."),
                (phrase: "\"¿Tiene una orden judicial?\"",
                 detail: "Pídeles que la deslicen bajo la puerta. Un doc. de ICE NO es una orden judicial."),
                (phrase: "\"Me acojo a mi derecho a guardar silencio.\"",
                 detail: "No tienes que contestar preguntas ni por la puerta."),
                (phrase: "\"Quiero hablar con un abogado.\"",
                 detail: "No abras. No firmes nada sin hablar con un abogado primero."),
            ] : [
                (phrase: "Do NOT open the door.",
                 detail: "ICE must have a judicial warrant signed by a judge to enter."),
                (phrase: "\"Do you have a judicial warrant?\"",
                 detail: "Ask them to slip it under the door. An ICE document is NOT a judicial warrant."),
                (phrase: "\"I choose to remain silent.\"",
                 detail: "You don't have to answer questions, even through the door."),
                (phrase: "\"I want to speak to a lawyer.\"",
                 detail: "Don't open the door. Don't sign anything without a lawyer."),
            ]
        case .street:
            return lang.isSpanish ? [
                (phrase: "\"¿Estoy libre para irme?\"",
                 detail: "Si dicen sí, aléjate con calma. No corras — puede usarse en tu contra."),
                (phrase: "\"Me acojo a mi derecho a guardar silencio.\"",
                 detail: "No tienes que contestar preguntas sobre tu origen o estatus."),
                (phrase: "\"No doy mi consentimiento a un registro.\"",
                 detail: "Puedes negarte a registros de tu persona y pertenencias."),
                (phrase: "\"Quiero hablar con un abogado.\"",
                 detail: "Si te detienen, di esto de inmediato. No firmes nada."),
            ] : [
                (phrase: "\"Am I free to go?\"",
                 detail: "If yes, walk away calmly. Don't run — it can be used against you."),
                (phrase: "\"I choose to remain silent.\"",
                 detail: "You don't have to answer questions about your origin or status."),
                (phrase: "\"I do not consent to a search.\"",
                 detail: "You can refuse searches of your person and belongings."),
                (phrase: "\"I want to speak to a lawyer.\"",
                 detail: "If arrested, say this immediately. Don't sign anything."),
            ]
        case .car:
            return lang.isSpanish ? [
                (phrase: "Estaciona con seguridad. Manos visibles.",
                 detail: "Baja la ventana parcialmente — no necesitas abrirla completamente."),
                (phrase: "\"Me acojo a mi derecho a guardar silencio.\"",
                 detail: "No estás obligado a contestar más allá de identificación básica."),
                (phrase: "\"No doy mi consentimiento a registrar mi vehículo.\"",
                 detail: "Puedes negarte. No tienes que abrir la cajuela sin una orden judicial."),
                (phrase: "\"Quiero hablar con un abogado.\"",
                 detail: "Si te arrestan, di esto de inmediato. No firmes nada."),
            ] : [
                (phrase: "Pull over safely. Keep hands visible.",
                 detail: "Roll window down partially — you don't have to open it fully."),
                (phrase: "\"I choose to remain silent.\"",
                 detail: "You are not required to answer beyond basic identification."),
                (phrase: "\"I do not consent to a search of my vehicle.\"",
                 detail: "You can refuse. You don't have to open your trunk without a warrant."),
                (phrase: "\"I want to speak to a lawyer.\"",
                 detail: "If placed under arrest, say this immediately. Don't sign anything."),
            ]
        }
    }

    private var alertBanner: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Circle()
                    .fill(smsPending ? Color.safetyOrange : Color.actionRed)
                    .frame(width: 8, height: 8)
                Text(smsPending
                     ? (lang.isSpanish ? "ENVIANDO EN \(sosCountdown)s" : "SENDING IN \(sosCountdown)s")
                     : (lang.isSpanish ? "ALERTA ENVIADA" : "ALERT SENT"))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(smsPending ? Color.safetyOrange : Color.actionRed)
                Spacer()
                Text("\(sosCountdown)s")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(smsPending ? Color.safetyOrange : Color.actionRed)
            }
            Text(smsPending
                 ? (lang.isSpanish
                    ? "Tus contactos serán notificados en \(sosCountdown) segundos. Cancela para detener."
                    : "Your contacts will be notified in \(sosCountdown) seconds. Cancel to stop.")
                 : (lang.isSpanish
                    ? "Tus contactos fueron notificados con tu ubicación."
                    : "Your trusted contacts have been sent your location."))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background((smsPending ? Color.safetyOrange : Color.actionRed).opacity(0.08))
        .cornerRadius(10)
    }

    private var sosButton: some View {
        VStack(spacing: 16) {
            if isSosActive {
                Button(action: { cancelSOS() }) {
                    Text(lang.isSpanish ? "Cancelar alerta" : "Cancel Alert")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.actionRed)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            } else {
                sosGestureButton
            }
        }
    }

    private var sosGestureButton: some View {
        let gesture = LongPressGesture(minimumDuration: sosHoldDuration)
            .onChanged { isPressing in
                if isPressing {
                    if sosStartTime == nil {
                        sosStartTime = Date()
                        startHoldAnimation()
                    }
                } else {
                    resetHoldState()
                }
            }
            .onEnded { success in
                if success {
                    Task { await activateSOS() }
                }
                resetHoldState()
            }

        return ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.actionRed)

            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.actionRed.opacity(0.3), lineWidth: 4)
                .scaleEffect(1 + sosHoldProgress * 0.1)
                .opacity(1 - sosHoldProgress)

            VStack(spacing: 6) {
                Text("EMERGENCIA")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundStyle(.white)

                if sosHoldProgress > 0 {
                    Text(lang.isSpanish ? "Alertando contactos…" : "Alerting contacts…")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
                } else {
                    Text(lang.isSpanish
                         ? "Mantén 3s para alertar tus contactos"
                         : "Hold 3s to alert your trusted contacts")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .gesture(gesture)
    }

    // MARK: - Computed Properties

    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return lang.isSpanish ? "Buenos días" : "Good morning"
        case 12..<17: return lang.isSpanish ? "Buenas tardes" : "Good afternoon"
        default:      return lang.isSpanish ? "Buenas noches" : "Good evening"
        }
    }

    private var locationStatusColor: Color {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return .green.opacity(0.85)
        case .denied, .restricted:                    return Color.safetyOrange
        case .notDetermined:                          return .gray
        @unknown default:                             return .gray
        }
    }

    private var locationStatusDetail: String? {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let last = syncService.lastSuccessfulPing {
                let rel = RelativeDateTimeFormatter().localizedString(for: last, relativeTo: Date())
                return lang.isSpanish ? "Último ping \(rel)" : "Last ping \(rel)"
            }
            return lang.isSpanish ? "Esperando GPS…" : "Waiting for GPS…"
        case .denied, .restricted:
            return lang.isSpanish
                ? "Activa la ubicación en Ajustes."
                : "Enable location in Settings to share pings."
        case .notDetermined:
            return lang.isSpanish ? "Toca Permitir cuando se solicite." : "Tap Allow when prompted."
        @unknown default:
            return nil
        }
    }

    // MARK: - SOS Logic

    private func startHoldAnimation() {
        var progress: Double = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            progress += (0.016 / sosHoldDuration)
            sosHoldProgress = min(progress, 1.0)
            if sosHoldProgress >= 1.0 {
                timer?.invalidate()
                timer = nil
            }
        }
    }

    private func resetHoldState() {
        sosStartTime = nil
        sosHoldProgress = 0
        timer?.invalidate()
        timer = nil
    }

    private func activateSOS() async {
        isSosActive = true
        smsPending = true
        sosCountdown = 60
        startCancelWindowTimer()
    }

    private func startCancelWindowTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if sosCountdown > 0 {
                sosCountdown -= 1
            } else {
                Task { await fireSOS() }
            }
        }
    }

    private func fireSOS() async {
        smsPending = false
        timer?.invalidate()
        timer = nil
        do {
            try await syncService.insertAlertPing()
        } catch {
            syncService.lastError = "SOS failed: \(error.localizedDescription)"
            resetSOS()
        }
    }

    private func cancelSOS() {
        resetSOS()
    }

    private func resetSOS() {
        isSosActive = false
        smsPending = false
        sosCountdown = 60
        sosStartTime = nil
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - KYRScenario

private enum KYRScenario: CaseIterable {
    case home, street, car

    func label(isSpanish: Bool) -> String {
        switch self {
        case .home:   return isSpanish ? "Casa" : "Home"
        case .street: return isSpanish ? "Calle" : "Public"
        case .car:    return isSpanish ? "Auto" : "Car"
        }
    }

    var icon: String {
        switch self {
        case .home:   return "house.fill"
        case .street: return "figure.walk"
        case .car:    return "car.fill"
        }
    }
}

// MARK: - KYRItem

private struct KYRItem: View {
    let phrase: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.actionRed.opacity(0.5))
                .frame(width: 5, height: 5)
                .padding(.top, 5)
            VStack(alignment: .leading, spacing: 2) {
                Text(phrase)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.trustNavy)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewContentContainer()
}

private struct PreviewContentContainer: View {
    @StateObject private var model = AppModel()
    @StateObject private var lang = LanguageManager()

    var body: some View {
        ContentView()
            .environmentObject(model.locationManager)
            .environmentObject(model.syncService)
            .environmentObject(lang)
    }
}
