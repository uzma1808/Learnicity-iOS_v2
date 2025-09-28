//
//  LoginModel.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/08/2025.
//

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let status : Bool?
    let message : String?
    let data : LoginData?
}
struct LoginData : Codable {
    let user : UserData?
    let token : String?
    let token_type : String?
}
struct UserData : Codable {
    let id : Int?
    let uuid : String?
    let name : String?
    let age : Int?
    let gender : String?
    let email : String?
    let profile_image : String?
}
