//
//  ForgotPasswordView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI

struct ForgotPasswordView: View {

    @Binding var path: NavigationPath
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
            VStack(spacing: 24) {

                CustomHeaderView(title: "Forgot Password", backAction: {
                    path.pop()
                })

                Image(.celebration)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 76, height: 76)

                VStack(spacing: 16) {
                    // Password
                    CustomTextfieldView(placeholder: "New Password", text: $password,isSecure: true)
                        .frame(height: 58)

                    // Confirm Password
                    CustomTextfieldView(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                        .frame(height: 58)
                }
                .padding(.horizontal, 28)

                Spacer()
                CustomButtonView(title: "Change Password") {

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

    }
}
#Preview {
    ForgotPasswordView(path: .constant(NavigationPath()))
}
