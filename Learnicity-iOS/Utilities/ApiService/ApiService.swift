//
//  File.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/08/2025.
//

import Foundation
import SwiftUI

class APIService {

    static let shared = APIService()
    private init() {}

    private let baseURL = "https://learnicityapp.com/api/v1/"

    func login(email: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: baseURL + Endpoints.login) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }

    // MARK: - Signup
       func signup(
           name: String,
           age: String,
           gender: String,
           email: String,
           password: String
       ) async throws -> SignupResponse {

           guard let url = URL(string: baseURL + Endpoints.signup) else {
               throw URLError(.badURL)
           }

           // Request body
           let body: [String: Any] = [
               "name": name,
               "age": age,
               "gender": gender,
               "email": email,
               "password": password
           ]

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpBody = try JSONSerialization.data(withJSONObject: body)

           // Send request
           let (data, response) = try await URLSession.shared.data(for: request)

           // Validate HTTP status
           guard let httpResponse = response as? HTTPURLResponse,
                 200..<300 ~= httpResponse.statusCode else {
               let errorResponse = try? JSONDecoder().decode(SignupResponse.self, from: data)
               throw NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                             userInfo: [NSLocalizedDescriptionKey: errorResponse?.message ?? "Signup failed"])
           }

           // Decode
           let signupResponse = try JSONDecoder().decode(SignupResponse.self, from: data)
           return signupResponse
       }

    // MARK: - home
    func fetchHomeData() async throws -> HomeResponse {
           guard let url = URL(string: baseURL + Endpoints.home) else {
               throw URLError(.badURL)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"

           // Attach token if available
           if let authHeader = UserSession.shared.authHeader {
               request.addValue(authHeader, forHTTPHeaderField: "Authorization")
           }

           let (data, response) = try await URLSession.shared.data(for: request)

           guard let httpResponse = response as? HTTPURLResponse,
                 (200..<300).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }

           return try JSONDecoder().decode(HomeResponse.self, from: data)
       }

    func getQuizSettings() async throws -> QuizSettingsResponse {
        guard let url = URL(string: baseURL + Endpoints.get_subjects) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // If auth is required, include Authorization header
        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(QuizSettingsResponse.self, from: data)
    }

    func setQuizSettings(subjectId: Int, difficultyLevelId: Int) async throws -> HomeResponse {
        guard let url = URL(string: baseURL + Endpoints.get_subjects) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let body: [String: Any] = [
            "subject_id": String(subjectId),
            "difficulty_level_id": String(difficultyLevelId)
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(HomeResponse.self, from: data)
    }

    func getBusinesses(latitude: Double? = nil, longitude: Double? = nil, type: String, page: Int = 1) async throws -> BusinessesResponse {
        guard let url = URL(string: baseURL + Endpoints.business_list) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
        var body: [String: Any]? = [:]
        if type == "nearby" {
            body = [
                "latitude": latitude ?? 0.0,
                "longitude": longitude ?? 0.0,
                "type": type
            ]
        } else if type == "favourite" || type == "list"{
            body = ["type": type]
        }


        request.httpBody = try JSONSerialization.data(withJSONObject: body ?? [:])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            if let authHeader = UserSession.shared.authHeader {
                request.setValue(authHeader, forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(BusinessesResponse.self, from: data)
        }

    // MARK: - Business Detail API
    func getBusinessDetail(businessId: Int) async throws -> BusinessDetailResponse {
        guard let url = URL(string: baseURL + Endpoints.business_details + "?business_id=\(businessId)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Attach token if available
        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(BusinessDetailResponse.self, from: data)
    }

    func fetchQuiz() async throws -> QuizModel {
        guard let url = URL(string: baseURL + Endpoints.get_quiz) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Attach token if available
        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(QuizModel.self, from: data)
    }

    func submitQuiz(_ requestBody: SubmitQuizRequest) async throws -> SubmitQuizResponse {
        guard let url = URL(string: baseURL + Endpoints.submit_quiz) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Attach token if available
            if let authHeader = UserSession.shared.authHeader {
                request.setValue(authHeader, forHTTPHeaderField: "Authorization")
            }

            // Encode request body
            request.httpBody = try JSONEncoder().encode(requestBody)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(SubmitQuizResponse.self, from: data)
        }

    func setFavouriteBusiness(businessId: Int) async throws -> QuizModel {
        guard let url = URL(string: baseURL + Endpoints.favourite + "?business_id=\(businessId)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(QuizModel.self, from: data)
    }

    // MARK: - API Function - add image parameter
    func updateProfile(
        name: String,
        age: String,
        gender: String,
        image: UIImage?
    ) async throws -> UpdateResponse {

        guard let url = URL(string: baseURL + Endpoints.update_profile) else {
            throw URLError(.badURL)
        }

        // Use multipart form data if image is present, otherwise JSON
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            let boundary = UUID().uuidString
            var body = Data()

            // Name field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(name)\r\n".data(using: .utf8)!)

            // Age field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"age\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(age)\r\n".data(using: .utf8)!)

            // Gender field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"gender\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(gender)\r\n".data(using: .utf8)!)

            // Image field
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profile_image\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)

            // Close boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
            if let authHeader = UserSession.shared.authHeader {
                request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let errorResponse = try? JSONDecoder().decode(UpdateResponse.self, from: data)
                throw NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                              userInfo: [NSLocalizedDescriptionKey: errorResponse?.message ?? "Update failed"])
            }

            return try JSONDecoder().decode(UpdateResponse.self, from: data)

        } else {
            // No image — send as JSON like before
            let body: [String: Any] = [
                "name": name,
                "age": age,
                "gender": gender,
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let authHeader = UserSession.shared.authHeader {
                request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            }


            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let errorResponse = try? JSONDecoder().decode(UpdateResponse.self, from: data)
                throw NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                              userInfo: [NSLocalizedDescriptionKey: errorResponse?.message ?? "Update failed"])
            }

            return try JSONDecoder().decode(UpdateResponse.self, from: data)
        }
    }

    func fetchFAQs() async throws -> FAQResponse {
        guard let url = URL(string: baseURL + Endpoints.faq) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Attach token if available
        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(FAQResponse.self, from: data)
    }

    func fetchLeaderboard() async throws -> LeaderboardResponse {
        guard let url = URL(string: baseURL + Endpoints.leaderboard) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Attach token if available
        if let authHeader = UserSession.shared.authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(LeaderboardResponse.self, from: data)
    }

    func deleteAccount() async throws -> LeaderboardResponse {
            guard let url = URL(string: baseURL + Endpoints.delete_account) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // Attach token if available
            if let authHeader = UserSession.shared.authHeader {
                request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(LeaderboardResponse.self, from: data)
        }

    func forgotPassword(email: String) async throws -> ForgotPasswordResponse {
           guard let url = URL(string: baseURL + "auth/forgot-password/\(email)") else {
               throw URLError(.badURL)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")

           let (data, response) = try await URLSession.shared.data(for: request)
           guard let httpResponse = response as? HTTPURLResponse,
                 (200..<300).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }

           return try JSONDecoder().decode(ForgotPasswordResponse.self, from: data)
       }

       func resetPassword(email: String, password: String) async throws -> ResetPasswordResponse {
           guard let url = URL(string: baseURL + "auth/reset-password") else {
               throw URLError(.badURL)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")

           let body = ["email": email, "password": password]
           request.httpBody = try JSONSerialization.data(withJSONObject: body)

           let (data, response) = try await URLSession.shared.data(for: request)
           guard let httpResponse = response as? HTTPURLResponse,
                 (200..<300).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }

           return try JSONDecoder().decode(ResetPasswordResponse.self, from: data)
       }

    func redeemProduct(productID: Int) async throws -> RedeemProductResponse {
            guard let url = URL(string: baseURL + "app/redeem-product?product_id=\(productID)") else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(RedeemProductResponse.self, from: data)
        }

}
