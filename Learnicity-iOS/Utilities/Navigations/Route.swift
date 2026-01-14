//
//  Route.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import Foundation
import Observation
import SwiftUI
import UIKit

enum Route: Hashable {
    case loginView
    case signupView
    case otpView(ForgotPasswordViewModel)
    case forgetPassword
    case onboardingWelcome
    case chooseSubject(settings: Bool)
    case home
    case streak
    case leaderboard
    case businessMap
    case businessList
    case businessDetails(Int)
    case scanner(Product)
    case redeemSuccess(Product)
    case redeemFailed
    case profileView
    case favourite
    case editProfile
    case faq
    case resetPassword(ForgotPasswordViewModel)

}
extension NavigationPath {
    mutating func push(screen: Route) {
        self.append(screen)
    }

    mutating func pop() {
        self.removeLast()
    }

    mutating func popToRoot(index: Int) {
        debugPrint(self.count)
        self.removeLast( self.count - index)
    }

    mutating func popViews(_ numberOfViews: Int) {
        self.removeLast(numberOfViews)
    }

     func popViewsFromNavigationController(_ numberOfViews: Int) {
        self.getNavigationController().popViewControllers(viewsToPop: numberOfViews, animated: false)
    }

    func popView() {
        self.getNavigationController().popViewController(animated: false)
    }

    func pushViewController(_ controller: UIViewController) {
        self.getNavigationController().pushViewController(controller, animated: false)
    }

    private func getNavigationController() -> UINavigationController {
        let window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
        for item in window?.rootViewController?.children ?? [] {
            if let navigation = item as? UINavigationController {
                return navigation
            }
        }
        return UINavigationController()
//        let navigation = window?.rootViewController?.children.first as? UINavigationController ?? UINavigationController()
//        return navigation
    }
}
