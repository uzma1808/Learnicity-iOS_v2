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
        case .otpView(let vm):
            OTPView(path: $path, viewModel: vm)
        case .forgetPassword:
            ForgotPasswordView(path: $path)
        case .onboardingWelcome:
            OnboardingWelcomeView(path: $path)
        case .chooseSubject(let settings ):
            ChooseSubjectView(path: $path,isFromSetting: settings)
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
        case .favourite:
            FavouriteBusinessListView(path: $path)
        case .editProfile:
            EditProfileView(path: $path)
        case .faq:
            FAQView(path: $path)
        case .resetPassword(let vm):
            ResetPasswordView(path: $path, viewModel: vm)
        }
    }
}

