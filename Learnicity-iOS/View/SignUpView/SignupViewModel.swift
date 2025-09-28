//
//  SignupViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/09/2025.
//

import Foundation
import Combine

extension SignupView {
    @MainActor
    class SignupViewModel: BaseViewModel {
        @Published var name: String = ""
        @Published var age: String = ""
        @Published var gender: String = ""
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var confirmPassword: String = ""
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false

        // Call Signup API
        @MainActor
        func callSignupApi() async {
            isLoading = true
            errorMessage = nil

            do {
                let response: SignupResponse = try await APIService.shared.signup(
                    name: name,
                    age: age,
                    gender: gender.lowercased(),
                    email: email,
                    password: password
                )

                if let status = response.status, status == true {
                    // Save user session
                    UserSession.shared.saveLogin(response: response.toLoginResponse())
                    print("Signup successful, user: \(UserSession.shared.user?.name ?? "")")
                } else {
                    errorMessage = response.message ?? "Signup failed. Please try again."
                    showError = true
                }

            } catch {
                errorMessage = "Signup failed. Please try again."
                showError = true
                print("Signup error: \(error.localizedDescription)")
            }

            isLoading = false
        }

        // Validation before calling API
        func validate() -> Bool {
            showError = false
            if name.isEmpty && age.isEmpty && gender.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty {
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

            if password.isEmpty {
                errorMessage = "Please enter a password."
                return false
            }

            if confirmPassword.isEmpty {
                errorMessage = "Please confirm your password."
                return false
            }
            if !isValidPassword(password) {
                errorMessage = "Password must contain at least 1 uppercase, 1 lowercase, 1 number, and 1 special character and 8 characters long."
                return false
            }
            if password != confirmPassword {
                errorMessage = "Passwords do not match."
                return false
            }

            return true
        }

        func isValidPassword(_ password: String) -> Bool {
               // At least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character
               let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}$"
               return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
           }
    }
}
