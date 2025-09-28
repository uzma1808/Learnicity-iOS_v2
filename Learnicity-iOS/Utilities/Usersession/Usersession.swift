//
//  Usersession.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/09/2025.
//

import Foundation

final class UserSession {
    static let shared = UserSession()
    private init() {
        loadSession()
    }

    private(set) var user: UserData?
    private(set) var token: String?
    private(set) var tokenType: String?

    private(set) var selectedSubject: QuizSubject?
    private(set) var selectedDifficulty: QuizDifficulty?
    // New values
    private(set) var userStreak: Int = 0
    private(set) var totalCoins: Int = 0
    private(set) var redeemableCoins: Int = 0
    // Keys for persistence
    private let userKey = "savedUser"
    private let tokenKey = "savedToken"
    private let tokenTypeKey = "savedTokenType"
    private let subjectKey = "savedSubject"
    private let difficultyKey = "savedDifficulty"

    private let streakKey = "savedUserStreak"
    private let totalCoinsKey = "savedTotalCoins"
    private let redeemableCoinsKey = "savedRedeemableCoins"


    // Save login response
    func saveLogin(response: LoginResponse) {
        self.user = response.data?.user
        self.token = response.data?.token
        self.tokenType = response.data?.token_type

        // Persist user
        if let user = response.data?.user,
           let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: userKey)
        }
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set(tokenType, forKey: tokenTypeKey)
    }

    // Save quiz settings
    func saveQuizSettings(subject: QuizSubject?, difficulty: QuizDifficulty?) {
        self.selectedSubject = subject
        self.selectedDifficulty = difficulty

        if let subject = subject,
           let encodedSubject = try? JSONEncoder().encode(subject) {
            UserDefaults.standard.set(encodedSubject, forKey: subjectKey)
        } else {
            UserDefaults.standard.removeObject(forKey: subjectKey)
        }

        if let difficulty = difficulty,
           let encodedDifficulty = try? JSONEncoder().encode(difficulty) {
            UserDefaults.standard.set(encodedDifficulty, forKey: difficultyKey)
        } else {
            UserDefaults.standard.removeObject(forKey: difficultyKey)
        }
    }

    // Clear session
    func clear() {
        self.user = nil
        self.token = nil
        self.tokenType = nil
        self.selectedSubject = nil
        self.selectedDifficulty = nil
        self.userStreak = 0
        self.totalCoins = 0
        self.redeemableCoins = 0

        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: tokenTypeKey)
        UserDefaults.standard.removeObject(forKey: subjectKey)
        UserDefaults.standard.removeObject(forKey: difficultyKey)
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: totalCoinsKey)
        UserDefaults.standard.removeObject(forKey: redeemableCoinsKey)
    }

    // Load saved session at app launch
    private func loadSession() {
        if let savedUserData = UserDefaults.standard.data(forKey: userKey),
           let decodedUser = try? JSONDecoder().decode(UserData.self, from: savedUserData) {
            self.user = decodedUser
        }
        self.token = UserDefaults.standard.string(forKey: tokenKey)
        self.tokenType = UserDefaults.standard.string(forKey: tokenTypeKey)

        if let savedSubjectData = UserDefaults.standard.data(forKey: subjectKey),
           let decodedSubject = try? JSONDecoder().decode(QuizSubject.self, from: savedSubjectData) {
            self.selectedSubject = decodedSubject
        }

        if let savedDifficultyData = UserDefaults.standard.data(forKey: difficultyKey),
           let decodedDifficulty = try? JSONDecoder().decode(QuizDifficulty.self, from: savedDifficultyData) {
            self.selectedDifficulty = decodedDifficulty
        }
    }

    var authHeader: String? {
        guard let type = tokenType, let token = token else { return nil }
        return "\(type) \(token)"
    }

    var isLoggedIn: Bool {
        return user != nil && token != nil
    }

    // MARK: - Save individual values
    func saveUserStreak(_ streak: Int) {
        self.userStreak = streak
        UserDefaults.standard.set(streak, forKey: streakKey)
    }

    func saveTotalCoins(_ coins: Int) {
        self.totalCoins = coins
        UserDefaults.standard.set(coins, forKey: totalCoinsKey)
    }

    func saveRedeemableCoins(_ coins: Int) {
        self.redeemableCoins = coins
        UserDefaults.standard.set(coins, forKey: redeemableCoinsKey)
    }

    // MARK: - Fetch individual values
    func fetchUserStreak() -> Int {
        return UserDefaults.standard.integer(forKey: streakKey)
    }

    func fetchTotalCoins() -> Int {
        return UserDefaults.standard.integer(forKey: totalCoinsKey)
    }

    func fetchRedeemableCoins() -> Int {
        return UserDefaults.standard.integer(forKey: redeemableCoinsKey)
    }
}
