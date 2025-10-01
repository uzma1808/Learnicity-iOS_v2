//
//  RootNavigation.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import Foundation
import SwiftUI

extension SplashView {
    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .loginView:
            LoginView(path: $path)
        case .signupView:
            SignupView(path: $path)
        case .otpView(let email):
            OTPView(path: $path, email: email)
        case .forgetPassword:
            ForgotPasswordView(path: $path)
        case .onboardingWelcome:
            OnboardingWelcomeView(path: $path)
        case .chooseSubject:
            ChooseSubjectView(path: $path)
        case .home:
            HomeView(path: $path)
        case .streak:
            StreakView(path: $path)
        case .leaderboard:
            LeaderboardView(path: $path)
        case .businessMap:
            BusinessMapView(path: $path)
        case .businessList:
            BusinessListView(path: $path)
        case .businessDetails(let id):
            BusinessDetailView(path: $path, businessId: id)
        case .scanner(let product):
            ScanScreen(productDetails: product, path: $path)
        case .redeemSuccess(let product):
            RedeemSuccessView(productDetails: product, path: $path)
        case .redeemFailed:
            RedeemFailedView(path: $path)
        case .profileView:
            ProfileView(path: $path)

        }
    }
}

