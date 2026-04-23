import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var syncService: LocationSyncService

    private let annotationProvider: MapAnnotationProviding = EmptyMapAnnotationProvider()

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

                statusSection
                    .padding(.top, 8)

                Spacer(minLength: 0)
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
