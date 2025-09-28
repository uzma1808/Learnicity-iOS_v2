//
//  BusinessModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

// MARK: - Businesses Response
struct BusinessesResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [BusinessDetailData]?
}

// MARK: - Pagination Data
struct BusinessesData: Codable {
    let currentPage: Int?
    let data: [BusinessDetailData]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [PageLink]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}


// MARK: - Pagination Link
struct PageLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
