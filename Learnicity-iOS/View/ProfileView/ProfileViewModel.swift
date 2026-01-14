//
//  DeleteAccountViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 14/10/2025.
//


import SwiftUI

extension ProfileView {
    @MainActor
    class ProfileViewModel: BaseViewModel {
        @Published var isLoading: Bool = false
        @Published var successMessage: String?
        @Published var errorMessage: String?
        @Published var showError: Bool = false
        @Published var accountDeleted: Bool = false

        func deleteAccount() async {
            isLoading = true
            errorMessage = nil
            showError = false
            successMessage = nil

            do {
                let response = try await APIService.shared.deleteAccount()
                if response.status ?? false {
                    successMessage = response.message ?? "Account Deleted"
                    accountDeleted = true
                } else {
                    errorMessage = response.message ?? "Failed to delete account."
                    showError = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }

            isLoading = false
        }
    }
}
