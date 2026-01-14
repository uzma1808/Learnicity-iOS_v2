//
//  LeaderboardModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 12/10/2025.
//

struct LeaderboardResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [LeaderboardModelData]?
}

struct LeaderboardModelData: Codable, Identifiable {
    var id: Int { position ?? 0 }
    let position: Int?
    let user_id: Int?
    let redeemed_coins: Int?
    let current_week: Int?
    let week_start: String?
    let week_end: String?
    let name: String?
    let profile_image: String?
}
