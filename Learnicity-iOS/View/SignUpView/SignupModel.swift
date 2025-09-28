//
//  SignupModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/09/2025.
//


struct SignupResponse: Decodable {
    let status: Bool?
    let message: String?
    let data: LoginData?
}

extension SignupResponse {
    func toLoginResponse() -> LoginResponse {
        return LoginResponse(status: status, message: message, data: data)
    }
}
