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
        @Published var isFavourite: Bool = false
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
                    self.isFavourite = (response.data?.favourite ?? 0) == 0 ? false : true
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

        // Toggle Favourite
                func toggleFavourite() async {
                    guard let businessId = businessDetail?.id else { return }
                    do {
                        let response = try await APIService.shared.setFavouriteBusiness(businessId: businessId)
                        if response.status == true {
                            // API auto toggles, so just flip our state
                            self.isFavourite.toggle()
                            print("✅ \(response.message ?? "")")
                        } else {
                            print("⚠️ \(response.message ?? "Failed to update favourite")")
                        }
                    } catch {
                        print("❌ Favourite API failed: \(error.localizedDescription)")
                    }
                }

    }
}
