//
//  LoginView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import SwiftUI
import PopupView

struct LoginView: View {

    @Binding var path: NavigationPath
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        VStack(spacing: 24) {

            CustomHeaderView(title: "Welcome Back") {
                path.pop()
            }

            Image(.animallogin)
                .resizable()
                .scaledToFit()
                .frame(width: 135, height: 135)

            VStack(spacing: 16) {
                CustomTextfieldView(placeholder: "Email", text: $viewModel.email)
                    .frame(height: 58)

                CustomTextfieldView(placeholder: "Password", text: $viewModel.password,isSecure: true)
                    .frame(height: 58)
            }
            .padding(.horizontal, 28)


            HStack {
                Toggle(isOn: $viewModel.isRemember) {
                    Text("Remember me")
                        .customFont(style: .semiBold, size: .h18)
                        .foregroundColor(.primary500)
                }
                .toggleStyle(CheckboxToggleStyle())
                Spacer()
                Button("Forgot Password?") {
                    path.push(screen: .forgetPassword)
                }
                .foregroundColor(.bluefont)
                .customFont(style: .bold, size: .h18)
            }
            .padding(.horizontal, 28)

            Spacer()

            HStack(alignment: .center, spacing: 2) {
                Text("Do you want to Create an account?")
                    .customFont(style: .bold, size: .h18)
                    .foregroundColor(.darkfont)
                Button("Signup") {
                    path.push(screen: .signupView)
                }
                .foregroundColor(.bluefont)
                .customFont(style: .bold, size: .h18)
            }

            CustomButtonView(title: "Login") {
                Task {
                    if viewModel.validate() {  // Run validation first
                        await viewModel.callLoginApi()
                        if viewModel.errorMessage == nil {
                            path.push(screen: .onboardingWelcome)
                        }
                    } else {
                        viewModel.showError = true
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

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(.primary500)
                .frame(width: 24,height: 24)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }

    }
}

#Preview {
    LoginView(path: .constant(NavigationPath()))
}
