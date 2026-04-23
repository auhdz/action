import CoreLocation
import Foundation

/// Future hook for ICE/agent or crowd-sourced markers. The default implementation returns none.
struct MapAgentAnnotation: Identifiable {
    let id: String
    let title: String
    let coordinate: CLLocationCoordinate2D
}

protocol MapAnnotationProviding {
    var annotations: [MapAgentAnnotation] { get }
}

struct EmptyMapAnnotationProvider: MapAnnotationProviding {
    var annotations: [MapAgentAnnotation] { [] }
}
