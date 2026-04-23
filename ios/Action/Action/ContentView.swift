import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var syncService: LocationSyncService

    @State private var sosStartTime: Date?
    @State private var isSosActive = false
    @State private var sosCountdown: Int = 60
    @State private var sosHoldProgress: Double = 0
    @State private var timer: Timer?

    private let annotationProvider: MapAnnotationProviding = EmptyMapAnnotationProvider()
    private let sosHoldDuration: Double = 3.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.white
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("Action")
                    .font(.system(size: 34, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)

                Text("Your corner map and live ping status.")
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
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Text("ALERTA ACTIVADA")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.red)
                Spacer()
                Text("\(sosCountdown)s")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.red)
            }
            Text("Emergencia reportada. Cancelar se enviará dentro de \(sosCountdown) segundos.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.red.opacity(0.08))
        .cornerRadius(8)
    }

    private var sosButton: some View {
        VStack(spacing: 16) {
            if isSosActive {
                Button(action: {
                    cancelSOS()
                }) {
                    Text("Cancelar")
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

            VStack(spacing: 8) {
                Text("EMERGENCIA")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundStyle(.white)

                if sosHoldProgress > 0 {
                    Text("\(Int((1 - sosHoldProgress) * sosHoldDuration * 10)) / 30")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
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
        do {
            try await syncService.insertAlertPing()
            isSosActive = true
            sosCountdown = 60

            startCancelWindowTimer()
        } catch {
            syncService.lastError = "SOS failed: \(error.localizedDescription)"
        }
    }

    private func startCancelWindowTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if sosCountdown > 0 {
                sosCountdown -= 1
            } else {
                resetSOS()
            }
        }
    }

    private func cancelSOS() {
        Task {
            do {
                try await syncService.resetAlertPing()
                resetSOS()
            } catch {
                syncService.lastError = "Cancel failed: \(error.localizedDescription)"
            }
        }
    }

    private func resetSOS() {
        isSosActive = false
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

    var body: some View {
        ContentView()
            .environmentObject(model.locationManager)
            .environmentObject(model.syncService)
    }
}
