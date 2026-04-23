import MapKit
import SwiftUI

struct CornerMapView: View {
    let location: CLLocation?
    let annotationProvider: MapAnnotationProviding

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()

            ForEach(annotationProvider.annotations) { item in
                Annotation(item.title, coordinate: item.coordinate) {
                    Circle()
                        .fill(Color.orange.opacity(0.35))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls(.hidden)
        .onChange(of: location?.coordinate.latitude) { _, _ in
            updateCamera()
        }
        .onChange(of: location?.coordinate.longitude) { _, _ in
            updateCamera()
        }
        .onAppear {
            updateCamera()
        }
    }

    private func updateCamera() {
        guard let coordinate = location?.coordinate else { return }
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        cameraPosition = .region(region)
    }
}

#Preview {
    CornerMapView(location: nil, annotationProvider: EmptyMapAnnotationProvider())
        .frame(width: 180, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
}
