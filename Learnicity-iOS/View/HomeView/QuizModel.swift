//
//  QuizModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/09/2025.
//


struct QuizModel : Codable {
    let status : Bool?
    let message : String?
    let data : QuizData?
}

struct QuizData : Codable {
    let true_false : TrueFalseQuiz?
    let mcqs : [MCQQuiz]?
}

struct TrueFalseQuiz: Codable, Identifiable {
    let id : Int?
    let question : String?
    let answer : Bool?
}

struct MCQQuiz: Codable, Identifiable {
    let id : Int?
    let question : String?
    let option1 : String?
    let option2 : String?
    let option3 : String?
    let option4 : String?
    let correct_option : String?

    var options: [String] {
        [option1, option2, option3, option4].compactMap { $0 }
    }
}

// MARK: - Request Models
struct SubmitTrueFalse: Codable {
    let id: Int
    let answer: Bool
}

struct SubmitMCQ: Codable {
    let id: Int
    let answer: String
}

struct SubmitQuizRequest: Codable {
    let true_false: SubmitTrueFalse
    let mcqs: [SubmitMCQ]
}

// MARK: - Response Models
struct SubmitQuizResponse: Codable {
    let status: Bool?
    let message: String?
    let data: SubmitQuizData?
}

struct SubmitQuizData: Codable {
    let coins_earned: Int?
}
