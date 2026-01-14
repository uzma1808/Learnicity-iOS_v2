//
//  ForgotPasswordResponse.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/10/2025.
//


struct ForgotPasswordResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ForgotPasswordData?
}

struct ForgotPasswordData: Codable {
    let email: String?
    let code: Int?
}

struct ResetPasswordResponse: Codable {
    let status: Bool?
    let message: String?
}
