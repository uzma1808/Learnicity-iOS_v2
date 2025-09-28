//
//  BusinessDetailViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

import Foundation

// MARK: - Business Detail ViewModel
extension BusinessDetailView {
    @MainActor
    class BusinessDetailViewModel: BaseViewModel {
        @Published var businessDetail: BusinessDetailData?
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false

        // MARK: - Fetch Business Detail
        func fetchBusinessDetail(businessId: Int) async {
            isLoading = true
            errorMessage = nil
            showError = false
            do {
                let response: BusinessDetailResponse = try await APIService.shared.getBusinessDetail(businessId: businessId)

                if let status = response.status, status == true {
                    self.businessDetail = response.data
                } else {
                    errorMessage = response.message ?? "Failed to load business details."
                    showError = true
                }

            } catch {
                errorMessage = "Something went wrong. Please try again."
                showError = true
                print("❌ Fetch business detail failed: \(error.localizedDescription)")
            }

            isLoading = false
        }
    }
}
