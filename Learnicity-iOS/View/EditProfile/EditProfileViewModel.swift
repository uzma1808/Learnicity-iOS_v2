//
//  EditProfileViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 04/10/2025.
//


import Foundation
import Combine
import SwiftUI

extension EditProfileView {
    @MainActor
    class EditProfileViewModel: BaseViewModel {
        @Published var name: String = UserSession.shared.user?.name ?? ""
        @Published var age: String = String(UserSession.shared.user?.age ?? 0)
        @Published var gender: String = UserSession.shared.user?.gender ?? ""
        @Published var email: String = UserSession.shared.user?.email ?? ""
        @Published var selectedImage: UIImage?
        @Published var fname : String = ""
        @Published var lname : String = ""
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false

        // Call Signup API
        @MainActor
        func callUpdateApi() async {
            isLoading = true
            errorMessage = nil

            do {
                let response: UpdateResponse = try await APIService.shared.updateProfile(
                    name: name,
                    age: age,
                    gender: gender.lowercased(),
                    image: selectedImage  // <-- pass image here
                )

                if let status = response.status, status == true {
                    let loginres = LoginResponse(
                        status: status,
                        message: response.message,
                        data: LoginData(
                            user: response.data,
                            token: UserSession.shared.token,
                            token_type: UserSession.shared.tokenType
                        )
                    )
                    UserSession.shared.saveLogin(response: loginres)
                } else {
                    errorMessage = response.message ?? "Update profile failed. Please try again."
                    showError = true
                }
            } catch {
                errorMessage = "Update profile failed. Please try again."
                showError = true
            }

            isLoading = false
        }

        // Validation before calling API
        func validate() -> Bool {
            showError = false
            if name.isEmpty && age.isEmpty && gender.isEmpty && email.isEmpty {
                errorMessage = "Please fill all fields!"
                return false
            }
            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                errorMessage = "Please enter your name."
                return false
            }

            if age.trimmingCharacters(in: .whitespaces).isEmpty {
                errorMessage = "Please enter your age."
                return false
            }

            if gender.isEmpty {
                errorMessage = "Please select your gender."
                return false
            }

            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorMessage = "Please enter your email."
                return false
            }

            if !Validator.isValidEmail(email) {
                errorMessage = "Please enter a valid email address."
                return false
            }

            return true
        }

    }
}
