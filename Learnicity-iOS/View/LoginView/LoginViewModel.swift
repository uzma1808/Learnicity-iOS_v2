//
//  LoginViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/08/2025.
//
import SwiftUI

extension LoginView {
    @MainActor
    class LoginViewModel: BaseViewModel {
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var isRemember: Bool = false
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError = false

        @MainActor
        func callLoginApi() async {
            isLoading = true
            errorMessage = nil

            do {
                let response: LoginResponse = try await APIService.shared.login(email: email, password: password)

                if let status = response.status, status == true {
                    if let token = response.data?.token {
                        if isRemember {
                            UserSession.shared.saveLogin(response: response)
                        }
                    }

                } else {
                    showError = false
                    errorMessage = response.message ?? "Login failed. Please try again."
                    showError = true
                }

            } catch {
                showError = false
                errorMessage = "Login failed. Please try again."
                showError = true
                print("Login failed: \(error.localizedDescription)")
            }

            isLoading = false
        }


        func validate() -> Bool {
            showError = false
            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorMessage = "Please enter your email."
                return false
            }

            if !Validator.isValidEmail(email) {
                errorMessage = "Please enter a valid email address."
                return false
            }

            if password.isEmpty {
                errorMessage = "Please enter your password."
                return false
            }

            return true
        }
    }
}
