//
//  HomeModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/09/2025.
//

struct HomeResponse: Decodable {
    let status: Bool?
    let message: String?
    let data: HomeData?
}

struct HomeData: Decodable {
    let quizSettings: Bool?
    let userStreak: Int?
    let totalCoins: Int?
    let redeemableCoins: Int?
    let subjects: [Subject]?
    let difficultyLevels: [DifficultyLevel]?

    enum CodingKeys: String, CodingKey {
        case quizSettings = "quiz_settings"
        case userStreak = "user_streak"
        case totalCoins = "total_coins"
        case redeemableCoins = "redeemable_coins"
        case subjects
        case difficultyLevels = "difficulty_levels"
    }
}

// Empty for now, but you can extend as per API
struct Subject: Decodable {
    let id: Int?
    let name: String?
}

struct DifficultyLevel: Decodable {
    let id: Int?
    let level: String?
}
