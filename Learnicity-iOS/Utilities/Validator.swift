//
//  Validator.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/08/2025.
//

import Foundation

class Validator {
    /// Validates if the given email string matches the standard email format.
    ///
    /// - Parameter email: The email string to be validated.
    /// - Returns: `true` if the email is valid, `false` otherwise.
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^(?!.*\.\.)(?!\.)(?!.*\.$)[a-zA-Z0-9]+([._%+-][a-zA-Z0-9]+)*@([a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}"#
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    /// Validates if the given password string meets the minimum length requirement.
    ///
    /// - Parameter password: The password string to be validated.
    /// - Returns: `true` if the password length is 6 or more characters, `false` otherwise.
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    /// Checks if the given string is either empty or contains only whitespace characters.
    ///
    /// - Parameter string: The string to be checked.
    /// - Returns: `true` if the string is empty or contains only whitespace, `false` otherwise.
    static func isEmptyOrWhitespace(_ string: String) -> Bool {
        return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}
