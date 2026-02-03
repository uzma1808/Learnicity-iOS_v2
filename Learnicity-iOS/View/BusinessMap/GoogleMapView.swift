//
//  GoogleMapView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

import GoogleMaps
import GooglePlaces
import GooglePlacesSwift
import SwiftUI

// MARK: - Google Map Wrapper
struct GoogleMapView: UIViewRepresentable {

    var coordinate: CLLocationCoordinate2D?
    var businesses: [BusinessDetailData]
    var onMarkerTap: ((BusinessDetailData) -> Void)?
    @Binding var shouldRecenter: Bool  // <-- new binding

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate?.latitude ?? 31.5204,
            longitude: coordinate?.longitude ?? 74.3587,
            zoom: 15
        )
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Center map on first load OR when search triggers it
        if shouldRecenter, let coord = coordinate {
            let camera = GMSCameraPosition.camera(
                withLatitude: coord.latitude,
                longitude: coord.longitude,
                zoom: 15
            )
            uiView.animate(to: camera)
            DispatchQueue.main.async {
                self.shouldRecenter = false  // <-- reset after centering
            }
        }

        // Only re-add markers if list changed
        if context.coordinator.currentBusinessCount != businesses.count {
            uiView.clear()
            for business in businesses {
                if let latStr = business.latitude,
                   let lonStr = business.longitude,
                   let lat = Double(latStr),
                   let lon = Double(lonStr) {

                    let marker = GMSMarker(
                        position: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    )
                    marker.title = business.name
                    marker.snippet = business.address
                    marker.userData = business
                    if let image = UIImage(named: "mappin") {
                        marker.icon = image.resized(to: CGSize(width: 55, height: 55))
                    }
                    marker.map = uiView
                }
            }
            context.coordinator.currentBusinessCount = businesses.count
        }
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        var currentBusinessCount: Int = -1

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let business = marker.userData as? BusinessDetailData {
                parent.onMarkerTap?(business)
            }
            return true
        }
    }
}

struct PlacesAutocompleteSheet: UIViewControllerRepresentable {
    var onPlaceSelected: (GMSPlace?) -> Void

    func makeUIViewController(context: Context) -> UINavigationController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        return UINavigationController(rootViewController: autocompleteController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPlaceSelected: onPlaceSelected)
    }

    final class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var onPlaceSelected: (GMSPlace?) -> Void

        init(onPlaceSelected: @escaping (GMSPlace?) -> Void) {
            self.onPlaceSelected = onPlaceSelected
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            onPlaceSelected(place)
            viewController.dismiss(animated: true)
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("❌ Error: \(error.localizedDescription)")
            onPlaceSelected(nil)
            viewController.dismiss(animated: true)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            viewController.dismiss(animated: true)
            onPlaceSelected(nil)
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
}
