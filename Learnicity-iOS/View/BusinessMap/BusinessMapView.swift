//
//  BusinessMapView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 27/08/2025.
//

import SwiftUI
import CoreLocation

// MARK: - Main View
struct BusinessMapView: View {
    @State private var showingAutocomplete = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var shouldRecenter: Bool = true  // <-- true on first load
    @Binding var path: NavigationPath
    @StateObject private var viewModel = BusinessListView.BusinessViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .top) {
            GoogleMapView(
                coordinate: selectedCoordinate,
                businesses: viewModel.businesses,
                onMarkerTap: { business in
                    path.push(screen: .businessDetails(business.id ?? 0))
                },
                shouldRecenter: $shouldRecenter  // <-- pass binding
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingAutocomplete = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .frame(width: 50)
                }
                .padding()

                Spacer()

                HStack(spacing: 12) {
                    Button(action: { path.pop() }) {
                        HStack {
                            Image(.globe)
                                .resizable()
                                .frame(width: 26, height: 26)
                            Text("View All List of Business")
                                .customFont(style: .bold, size: .h16)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }

                    Button(action: { path.popViews(2) }) {
                        Image(.home)
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .frame(width: 50)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showingAutocomplete) {
            PlacesAutocompleteSheet { place in
                if let place = place {
                    selectedCoordinate = place.coordinate
                    shouldRecenter = true  // <-- trigger recenter on search
                    Task {
                        await viewModel.fetchBusinesses(
                            latitude: place.coordinate.latitude,
                            longitude: place.coordinate.longitude,
                            type: "nearby"
                        )
                    }
                }
            }
        }
        .onAppear {
            if let coord = locationManager.currentLocation {
                selectedCoordinate = coord
                shouldRecenter = true  // <-- center on first load
                Task {
                    await viewModel.fetchBusinesses(
                        latitude: coord.latitude,
                        longitude: coord.longitude,
                        type: "list"
                    )
                }
            }
        }
        .onReceive(locationManager.$currentLocation.compactMap { $0 }) { coord in
            if selectedCoordinate == nil {
                selectedCoordinate = coord
                shouldRecenter = true  // <-- center only on very first location
                Task {
                    await viewModel.fetchBusinesses(
                        latitude: coord.latitude,
                        longitude: coord.longitude,
                        type: "list"
                    )
                }
            }
        }
    }
}


struct BusinessMapView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessMapView(path: .constant(NavigationPath()))
    }
}
