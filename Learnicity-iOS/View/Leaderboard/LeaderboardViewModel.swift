//
//  LeaderboardViewModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 14/10/2025.
//
import Combine

extension LeaderboardView {
    @MainActor
    class LeaderboardViewModel: BaseViewModel {
        @Published var leaderboard: [LeaderboardModelData] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        @Published var showError: Bool = false

        func fetchLeaderboard() async {
            isLoading = true
            errorMessage = nil
            showError = false

            do {
                let response = try await APIService.shared.fetchLeaderboard()
                if response.status ?? false {
                    leaderboard = response.data ?? []
                } else {
                    errorMessage = response.message ?? "Failed to load leaderboard."
                    showError = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }

            isLoading = false
        }
    }
}
