//
//  FAQViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 05/10/2025.
//

import SwiftUI
import Combine

// MARK: - Models
struct FAQResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [FAQData]?
}

struct FAQData: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
}

// MARK: - ViewModel
extension FAQView {
    @MainActor
    class FAQViewModel: BaseViewModel {
        @Published var faqs: [FAQData] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false

        // Fetch FAQs from API
        func fetchFAQs() async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response: FAQResponse = try await APIService.shared.fetchFAQs()

                if let status = response.status, status == true {
                    self.faqs = response.data ?? []
                } else {
                    self.errorMessage = response.message ?? "Failed to load FAQs."
                    self.showError = true
                }
            } catch {
                self.errorMessage = "Something went wrong. Please try again."
                self.showError = true
                print("FAQ API Error: \(error.localizedDescription)")
            }

            isLoading = false
        }
    }
}
