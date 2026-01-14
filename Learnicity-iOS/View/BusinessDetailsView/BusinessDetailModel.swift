//
//  BusinessDetailModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

struct BusinessDetailResponse: Codable {
    let status: Bool?
    let message: String?
    var data: BusinessDetailData?
}

struct BusinessDetailData: Codable, Identifiable {
    let id: Int?
    let name: String?
    let profileImage: String?
    let businessCover: String?
    let description: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let productsCount: Int?
    var favourite: Int?
    let redeemableCoins: Int?
    let recentRedeemUsers: [String]?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, address, latitude, longitude, productsCount = "products_count"
        case profileImage = "profile_image"
        case businessCover = "business_cover"
        case favourite, redeemableCoins = "redeemable_coins"
        case recentRedeemUsers = "recent_redeem_users"
        case products
    }
}

struct Product: Codable, Hashable {
    let id: Int?
    let businessId: String?
    let rewardTierId: String?
    let name: String?
    let image: String?
    let description: String?
    let quantityPerQRCodeScan: String?
    let requiredCoins: Int?
    let qrcodeString: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, description, requiredCoins = "required_coins", qrcodeString = "qrcode_string"
        case businessId = "business_id"
        case rewardTierId = "reward_tier_id"
        case quantityPerQRCodeScan = "quantity_per_qrcode_scan"
    }
}
