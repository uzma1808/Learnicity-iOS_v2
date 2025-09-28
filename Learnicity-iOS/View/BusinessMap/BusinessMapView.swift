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
    @Binding var path: NavigationPath
    @StateObject private var viewModel = BusinessListView.BusinessViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .top) {
            GoogleMapView(
                coordinate: selectedCoordinate,
                businesses: viewModel.businesses
            ) { business in
                path.push(screen: .businessDetails(business.id ?? 0))
            }
            .ignoresSafeArea()

            .ignoresSafeArea()

            VStack {
                // Search Button
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
                // Bottom bar
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
        .onReceive(locationManager.$currentLocation.compactMap { $0 }) { coord in
            selectedCoordinate = coord
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


struct BusinessMapView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessMapView(path: .constant(NavigationPath()))
    }
}
