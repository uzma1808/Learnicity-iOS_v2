//
//  BusinessViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

import Foundation
// MARK: - Business ViewModel
extension BusinessListView {
    @MainActor
    class BusinessViewModel: BaseViewModel {
        @Published var businesses: [BusinessDetailData] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError = false

        // pagination if needed
        @Published var currentPage: Int = 1
        @Published var totalPages: Int = 1

        // MARK: - Fetch Businesses
        func fetchBusinesses(latitude: Double? = nil, longitude: Double? = nil, type: String = "list", page: Int = 1) async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response: BusinessesResponse = try await APIService.shared.getBusinesses(
                    latitude: latitude,
                    longitude: longitude,
                    type: type,
                    page: page
                )

                if let status = response.status, status == true {
                    if let data = response.data {
                        self.businesses = data
//                        self.currentPage = data.currentPage ?? 1
//                        self.totalPages = data.lastPage ?? 1
                    }
                } else {
                    errorMessage = response.message ?? "Failed to load businesses."
                    showError = true
                }

            } catch {
                errorMessage = "Something went wrong. Please try again."
                showError = true
                print("Fetch businesses failed: \(error.localizedDescription)")
            }

            isLoading = false
        }

    }
}
