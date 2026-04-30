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
    @State private var smsPending = false  // true while counting down before SMS fires

    private let annotationProvider: MapAnnotationProviding = EmptyMapAnnotationProvider()
    private let sosHoldDuration: Double = 3.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.white
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("Acción")
                    .font(.system(size: 34, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)

                Text(lang.isSpanish
                     ? "Tu ubicación. Tus contactos de confianza."
                     : "Your location. Your trusted contacts.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isSosActive {
                    alertBanner
                        .padding(.top, 8)
                } else {
                    statusSection
                        .padding(.top, 8)
                }

                Spacer(minLength: 0)

                sosButton
                    .padding(.horizontal, 24)
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

    private var alertBanner: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Circle()
                    .fill(smsPending ? Color.orange : Color.red)
                    .frame(width: 8, height: 8)
                Text(smsPending
                     ? (lang.isSpanish ? "ENVIANDO EN \(sosCountdown)s" : "SENDING IN \(sosCountdown)s")
                     : (lang.isSpanish ? "ALERTA ENVIADA" : "ALERT SENT"))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(smsPending ? .orange : .red)
                Spacer()
                Text("\(sosCountdown)s")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(smsPending ? .orange : .red)
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
        .background((smsPending ? Color.orange : Color.red).opacity(0.08))
        .cornerRadius(8)
    }

    private var sosButton: some View {
        VStack(spacing: 16) {
            if isSosActive {
                Button(action: { cancelSOS() }) {
                    Text(lang.isSpanish ? "Cancelar alerta" : "Cancel Alert")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.red)
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
                    Task {
                        await activateSOS()
                    }
                }
                resetHoldState()
            }

        return ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red)

            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.red.opacity(0.3), lineWidth: 4)
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

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Circle()
                    .fill(locationStatusColor)
                    .frame(width: 8, height: 8)
                Text(locationStatusTitle)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            if let detail = locationStatusDetail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            if let err = syncService.lastError {
                Text(err)
                    .font(.caption)
                    .foregroundStyle(.red.opacity(0.85))
            }
        }
    }

    private var locationStatusTitle: String {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return "Location on"
        case .denied, .restricted:
            return "Location denied"
        case .notDetermined:
            return "Location permission needed"
        @unknown default:
            return "Location unknown"
        }
    }

    private var locationStatusColor: Color {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return .green.opacity(0.85)
        case .denied, .restricted:
            return .orange
        case .notDetermined:
            return .gray
        @unknown default:
            return .gray
        }
    }

    private var locationStatusDetail: String? {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let last = syncService.lastSuccessfulPing {
                return "Last ping \(RelativeDateTimeFormatter().localizedString(for: last, relativeTo: Date()))"
            }
            return "Waiting for GPS…"
        case .denied, .restricted:
            return "Enable location in Settings to share pings."
        case .notDetermined:
            return "Tap Allow when prompted."
        @unknown default:
            return nil
        }
    }

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
        // Start 60s countdown — SMS fires AFTER countdown expires, not immediately.
        // Cancel within 60s = no SMS sent at all.
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
                // Countdown expired — now fire the alert ping and SMS
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
        // Cancelled before SMS fired — no ping inserted, no SMS sent
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
