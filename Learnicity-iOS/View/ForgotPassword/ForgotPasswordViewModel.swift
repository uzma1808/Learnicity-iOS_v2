//
//  ForgotPasswordViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 21/10/2025.
//

import SwiftUI

@MainActor
class ForgotPasswordViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var serverOTP: String = ""   // To store code returned from server

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var successMessage: String?

    // MARK: - Forgot Password API
    func callForgotPasswordAPI() async -> Bool {
        isLoading = true
        defer { isLoading = false }

        showError = false
        errorMessage = nil
        successMessage = nil

        guard validateEmail() else { return false }

        do {
            let response: ForgotPasswordResponse = try await APIService.shared.forgotPassword(email: email)

            if let status = response.status, status == true {
                successMessage = response.message
                if let code = response.data?.code {
                    serverOTP = "\(code)"
                    print("OTP CODE", serverOTP)
                }
                return true
            } else {
                errorMessage = response.message ?? "Failed to send OTP."
                showError = true
                return false
            }
        } catch {
            errorMessage = "Something went wrong. Please try again."
            showError = true
            return false
        }
    }

    // MARK: - Verify OTP (local check)
    func verifyOTP() -> Bool {
        showError = false
        guard !otp.isEmpty else {
            errorMessage = "Please enter OTP."
            showError = true
            return false
        }

        guard otp == serverOTP else {
            errorMessage = "Invalid OTP. Please try again."
            showError = true
            return false
        }

        return true
    }

    // MARK: - Reset Password API
    func callResetPasswordAPI() async -> Bool {
        isLoading = true
        defer { isLoading = false }

        showError = false
        errorMessage = nil
        successMessage = nil

        guard validateResetFields() else { return false }

        do {
            let response: ResetPasswordResponse = try await APIService.shared.resetPassword(email: email, password: password)

            if let status = response.status, status == true {
                successMessage = response.message
                return true
            } else {
                errorMessage = response.message ?? "Password reset failed."
                showError = true
                return false
            }
        } catch {
            errorMessage = "Something went wrong. Please try again."
            showError = true
            return false
        }
    }

    // MARK: - Validations
    private func validateEmail() -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your email."
            showError = true
            return false
        }

        guard Validator.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            showError = true
            return false
        }

        return true
    }

    private func validateResetFields() -> Bool {
        guard !password.isEmpty else {
            errorMessage = "Please enter a new password."
            showError = true
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            showError = true
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return false
        }

        return true
    }
}
