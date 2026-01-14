//
//  ResetPasswordView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 21/10/2025.
//

import SwiftUI
import PopupView

struct ResetPasswordView: View {

    @Binding var path: NavigationPath
    @ObservedObject var viewModel: ForgotPasswordViewModel

    var body: some View {
        VStack(spacing: 24) {

            CustomHeaderView(title: "Reset Password", backAction: {
                path.pop()
            })

            Image(.celebration)
                .resizable()
                .scaledToFit()
                .frame(width: 76, height: 76)

            VStack(spacing: 16) {
                // Password
                CustomTextfieldView(placeholder: "New Password", text: $viewModel.password,isSecure: true)
                    .frame(height: 58)

                // Confirm Password
                CustomTextfieldView(placeholder: "Confirm Password", text: $viewModel.confirmPassword, isSecure: true)
                    .frame(height: 58)
            }
            .padding(.horizontal, 28)

            Spacer()
            CustomButtonView(title: "Reset") {
                Task {
                    let success = await viewModel.callResetPasswordAPI()
                    if success {
                        path.popToRoot(index: 1)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()

        .onTapGesture {
            hideKeyboard()
        }
        .popup(isPresented: $viewModel.showError) {
            ErrorView(errorMessage: viewModel.errorMessage ?? "" )
        } customize: {
            $0
                .type(.toast)
                .autohideIn(1.5)
                .position(.top)
        }
        .loadingIndicator($viewModel.isLoading)

    }
}
