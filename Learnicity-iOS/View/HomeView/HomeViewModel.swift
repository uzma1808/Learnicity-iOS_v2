//
//  HomeViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/09/2025.
//

import SwiftUI
import Combine

extension HomeView {
    @MainActor
    class HomeViewModel: BaseViewModel {
        @Published var homeData: HomeData?
        @Published var trueFalseQuiz: TrueFalseQuiz?
        @Published var mcqQuizzes: [MCQQuiz] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false
        @Published var startQuiz: Bool = false

        @Published var selectedTrueFalse: SubmitTrueFalse?
        @Published var selectedMCQs: [SubmitMCQ] = []
        @Published var coinsEarned: Int?
        @Published var currentIndex : Int = 0


        @MainActor
        func fetchHomeData() async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response: HomeResponse = try await APIService.shared.fetchHomeData()

                if let status = response.status, status == true {
                    self.homeData = response.data
                    UserSession.shared.saveUserStreak(self.homeData?.userStreak ?? 0)
                    UserSession.shared.saveTotalCoins(self.homeData?.totalCoins ?? 0)
                    UserSession.shared.saveRedeemableCoins(self.homeData?.redeemableCoins ?? 0)
                } else {
                    errorMessage = response.message ?? "Failed to load home data."
                    showError = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                print("Home API failed: \(error.localizedDescription)")
            }

            isLoading = false
        }

        func fetchQuiz() async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response = try await APIService.shared.fetchQuiz()

                if response.status ?? false {
                    self.trueFalseQuiz = response.data?.true_false
                    self.mcqQuizzes = response.data?.mcqs ?? []
                } else {
                    errorMessage = response.message
                    showError = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }

            isLoading = false
        }

        @MainActor
        func submitQuiz() async {
                guard let tf = selectedTrueFalse else { return }
                let request = SubmitQuizRequest(true_false: tf, mcqs: selectedMCQs)

                do {
                    let response = try await APIService.shared.submitQuiz(request)
                    if response.status ?? false {
                        coinsEarned = response.data?.coins_earned
                        await fetchHomeData()
                    } else {
                        coinsEarned = 0
                        errorMessage = response.message
                        showError = true
                    }
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }

        func resetQuiz() {
                currentIndex = 0
                selectedTrueFalse = nil
                selectedMCQs.removeAll()
                mcqQuizzes.removeAll()
                trueFalseQuiz = nil
                coinsEarned = nil
                Task { await fetchQuiz() }
            }
    }
}
