//
//  SubjectViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/09/2025.
//

import Foundation
import SwiftUI

extension ChooseSubjectView {
    @MainActor
    class SubjectViewModel: BaseViewModel {
        // MARK: - Published Properties
        @Published var subjects: [QuizSubject] = []
        @Published var dificulties: [QuizDifficulty] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false
        @Published var selectedSubject : QuizSubject?
        @Published var selectedDificultyLevel : QuizDifficulty?


        // MARK: - API Call
        func fetchSubjects() async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response: QuizSettingsResponse = try await APIService.shared.getQuizSettings()

                if let status = response.status, status == true {
                    subjects = response.data?.subjects ?? []
                    dificulties = response.data?.difficultyLevels ?? []
                } else {
                    errorMessage = response.message ?? "Failed to fetch subjects."
                    showError = true
                }
            } catch {
                errorMessage = "Something went wrong. Please try again."
                showError = true
                print("Fetch subjects failed: \(error.localizedDescription)")
            }

            isLoading = false
        }

        // MARK: - Validation
        func validateSubjectSelection() -> Bool {
            showError = false
            if selectedSubject == nil {
                errorMessage = "Please select a subject."
                showError = true
                return false
            } 
            if selectedDificultyLevel == nil {
                errorMessage = "Please select a difficulty level."
                showError = true
                return false
            }
            return true
        }

        func setQuizSettings() async throws -> HomeResponse {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response: HomeResponse = try await APIService.shared.setQuizSettings(
                    subjectId: selectedSubject?.id ?? 0,
                    difficultyLevelId: selectedDificultyLevel?.id ?? 0
                )
                isLoading = false
                return response
            } catch {
                isLoading = false
                errorMessage = "Something went wrong. Please try again."
                print("Set quiz settings failed: \(error.localizedDescription)")
                throw error
            }
        }

    }
}
