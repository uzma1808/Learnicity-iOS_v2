//
//  ForgotPasswordView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI
import PopupView

struct ForgotPasswordView: View {

    @Binding var path: NavigationPath
    @StateObject private var viewModel = ForgotPasswordViewModel()

    var body: some View {
            VStack(spacing: 24) {

                CustomHeaderView(title: "Forgot Password", backAction: {
                    path.pop()
                })

                Image(.animal)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 135, height: 135)

                    // email
                CustomTextfieldView(placeholder: "Email", text: $viewModel.email,isSecure: false)
                        .frame(height: 58)
                        .padding(.horizontal, 28)

                Spacer()
                CustomButtonView(title: "Verify") {
                    Task {
                        let success = await viewModel.callForgotPasswordAPI()
                        if success {
                            path.push(screen: .otpView(viewModel))
                        }
                    }
                }
                .padding(.horizontal, 17)
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
#Preview {
    ForgotPasswordView(path: .constant(NavigationPath()))
}
