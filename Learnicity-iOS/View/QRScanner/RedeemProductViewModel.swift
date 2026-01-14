//
//  RedeemProductViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/10/2025.
//


import SwiftUI

@MainActor
class RedeemProductViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var successMessage: String?

    // MARK: - Redeem Product API Call
    func redeemProduct(productID: Int) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        showError = false
        successMessage = nil
        errorMessage = nil

        do {
            let response: RedeemProductResponse = try await APIService.shared.redeemProduct(productID: productID)

            if let status = response.status, status == true {
                successMessage = response.message ?? "Coins Redeemed Successfully"
                return true
            } else {
                errorMessage = response.message ?? "Failed to redeem product."
                showError = true
                return false
            }

        } catch {
            errorMessage = "Something went wrong. Please try again."
            showError = true
            return false
        }
    }
}
