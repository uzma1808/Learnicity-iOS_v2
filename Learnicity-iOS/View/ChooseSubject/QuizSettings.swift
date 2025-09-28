//
//  QuizSettings.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/09/2025.
//

struct QuizSettingsResponse: Decodable {
    let status: Bool?
    let message: String?
    let data: QuizSettingsData?
}

struct QuizSettingsData: Decodable {
    let subjects: [QuizSubject]?
    let difficultyLevels: [QuizDifficulty]?

    enum CodingKeys: String, CodingKey {
        case subjects
        case difficultyLevels = "difficulty_levels"
    }
}

struct QuizSubject: Codable, Identifiable,Hashable {
    let id: Int?
    let subject: String?
}

struct QuizDifficulty: Codable, Identifiable, Hashable {
    let id: Int?
    let difficulty: String?
    let coins: String?
}
