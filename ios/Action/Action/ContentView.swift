import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var syncService: LocationSyncService
    @EnvironmentObject private var lang: LanguageManager

    @AppStorage("userName") private var userName = ""

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
        ZStack {
            Color.safeCream.ignoresSafeArea()

            VStack(spacing: 0) {
                // Scrollable content — title + cards
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Acción")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundStyle(Color.trustNavy)
                                Text(timeBasedGreeting)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            LanguageToggle()
                        }

                        if isSosActive && smsPending {
                            sosPendingCard
                        } else if isSosActive && !smsPending {
                            sosSentCard
                        } else {
                            safetyStatusCard
                        }

                        kyrCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                }

                // EMERGENCIA button pinned at bottom — hidden during active SOS
                if !isSosActive {
                    sosGestureButton
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                        .background(Color.safeCream)
                }
            }
        }
        .onAppear {
            locationManager.requestAuthorizationIfNeeded()
        }
    }

    // MARK: - Safety Status Card (map inside)

    private var safetyStatusCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(locationStatusColor)
                        .frame(width: 9, height: 9)
                    Text(lang.isSpanish ? "Estás protegido" : "You are safe")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                if let detail = locationStatusDetail {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            CornerMapView(
                location: locationManager.location,
                annotationProvider: annotationProvider
            )
            .frame(maxWidth: .infinity)
            .frame(height: 145)
        }
        .background(Color.trustNavy)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Know Your Rights Card (Cards Against Humanity style)

    private var kyrCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                Text(lang.isSpanish ? "TUS DERECHOS" : "KNOW YOUR RIGHTS")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .tracking(2)
                Spacer()
            }

            kyrScenarioPicker

            VStack(alignment: .leading, spacing: 14) {
                ForEach(kyrItems, id: \.phrase) { item in
                    KYRItem(phrase: item.phrase, detail: item.detail)
                }
            }

            Text(lang.isSpanish
                 ? "Fuente: CHIRLA — chirla.org · Línea de ayuda: 888-624-4752"
                 : "Source: CHIRLA — chirla.org · Hotline: 888-624-4752")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.25))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var kyrScenarioPicker: some View {
        HStack(spacing: 0) {
            ForEach(KYRScenario.allCases, id: \.self) { scenario in
                Button(action: { kyrScenario = scenario }) {
                    HStack(spacing: 5) {
                        Image(systemName: scenario.icon)
                            .font(.system(size: 12, weight: .medium))
                        Text(scenario.label(isSpanish: lang.isSpanish))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(kyrScenario == scenario ? Color(red: 0.07, green: 0.07, blue: 0.07) : .white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(kyrScenario == scenario ? Color.white : Color.clear)
                    .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
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

    // MARK: - SOS Pending Card (countdown with cancel)

    private var sosPendingCard: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.10), lineWidth: 7)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: CGFloat(sosCountdown) / 60.0)
                    .stroke(
                        sosCountdown > 20
                            ? Color(red: 0.95, green: 0.65, blue: 0.10)
                            : Color(red: 0.87, green: 0.15, blue: 0.15),
                        style: StrokeStyle(lineWidth: 7, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: sosCountdown)
                VStack(spacing: 1) {
                    Text("\(sosCountdown)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text(lang.isSpanish ? "seg." : "sec.")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.45))
                }
            }

            VStack(spacing: 4) {
                Text(lang.isSpanish ? "Alerta en camino…" : "Alert in progress…")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Text(lang.isSpanish
                     ? "Tu ubicación se enviará cuando termine la cuenta regresiva."
                     : "Your location will be sent when the countdown reaches zero.")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.50))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(action: { Task { await fireSOS() } }) {
                Text(lang.isSpanish ? "Enviar ahora — acción inmediata" : "Send now — immediate action")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.87, green: 0.15, blue: 0.15))
                    .cornerRadius(12)
            }

            Button(action: { cancelSOS() }) {
                Text(lang.isSpanish ? "Cancelar — estoy bien" : "Cancel — I'm safe")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
            }
        }
        .padding(22)
        .background(Color(red: 0.08, green: 0.09, blue: 0.11))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - SOS Sent Confirmation Card

    private var sosSentCard: some View {
        let appleGreen = Color(red: 0.204, green: 0.780, blue: 0.349)
        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(appleGreen.opacity(0.15))
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(appleGreen)
            }

            VStack(spacing: 6) {
                Text(lang.isSpanish ? "Alerta enviada" : "Alert sent")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.trustNavy)
                Text(lang.isSpanish
                     ? "Tu ubicación fue enviada a tus contactos de confianza. La ayuda está en camino."
                     : "Your location was sent to your trusted contacts. Help is on the way.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.trustNavy.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(action: { resetSOS() }) {
                Text(lang.isSpanish ? "Entendido" : "Got it")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(appleGreen)
                    .cornerRadius(12)
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.07), radius: 16, x: 0, y: 4)
    }

    // MARK: - SOS Button

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
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.actionRed)

            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.actionRed.opacity(0.35), lineWidth: 5)
                .scaleEffect(1 + sosHoldProgress * 0.08)
                .opacity(1 - sosHoldProgress)

            VStack(spacing: 5) {
                Text("EMERGENCIA")
                    .font(.system(size: 17, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(.white)

                if sosHoldProgress > 0 {
                    Text(lang.isSpanish ? "Alertando contactos…" : "Alerting contacts…")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                } else {
                    Text(lang.isSpanish
                         ? "Mantén 3s para alertar tus contactos"
                         : "Hold 3s to alert your trusted contacts")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.72))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .gesture(gesture)
    }

    // MARK: - Computed Properties

    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let prefix: String
        switch hour {
        case 5..<12: prefix = lang.isSpanish ? "Buenos días" : "Good morning"
        case 12..<17: prefix = lang.isSpanish ? "Buenas tardes" : "Good afternoon"
        default:      prefix = lang.isSpanish ? "Buenas noches" : "Good evening"
        }
        return userName.isEmpty ? prefix : "\(prefix), \(userName)"
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
                : "Enable location in Settings."
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
        HStack(alignment: .top, spacing: 12) {
            Text("—")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.actionRed)
            VStack(alignment: .leading, spacing: 4) {
                Text(phrase)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.5))
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
