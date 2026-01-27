//
//  SignupView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//

import SwiftUI
import PopupView

struct ActionSheetsState {
    var showingFirst = false
    var showingSecond = false
}

struct SignupView: View {

    @Binding var path: NavigationPath
    @State private var showGenderMenu: Bool = false
    @State private var showAge: Bool = false
    @State private var showName: Bool = false
    @State var actionSheets = ActionSheetsState()
    @StateObject private var viewModel = SignupViewModel()


    let genders = ["Male", "Female", "Other"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Back button + title
                CustomHeaderView(title: "Sign up", backAction: {
                    path.pop()
                })

                Image(.animalsignup)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                VStack(spacing: 16) {
                    CustomTextfieldView(placeholder: "Name", text: $viewModel.name)
                        .frame(height: 58)
                        .overlay(
                            Button(action: {
                                showName = true
                            }) {
                                Color.clear
                            }
                        )


                    // Age + Gender in horizontal stack
                    HStack(spacing: 16) {
                        CustomTextfieldView(placeholder: "Age", text: $viewModel.age)
                            .frame(height: 58)
                            .overlay(
                                Button(action: {
                                    showAge = true
                                }) {
                                    Color.clear
                                }
                            )

                        CustomTextfieldView(placeholder: "Gender", text: $viewModel.gender)
                            .frame(height: 58)
                            .overlay(
                                Button(action: {
                                    showGenderMenu = true
                                }) {
                                    Color.clear
                                }
                            )
                    }

                    // Email
                    CustomTextfieldView(placeholder: "Email", text: $viewModel.email)
                        .frame(height: 58)
                    // Password
                    CustomTextfieldView(placeholder: "Password", text: $viewModel.password,isSecure: true)
                        .frame(height: 58)

                    // Confirm Password
                    CustomTextfieldView(placeholder: "Confirm Password", text: $viewModel.confirmPassword, isSecure: true)
                        .frame(height: 58)
                }
                .padding(.horizontal, 28)
                // Name


                // Already have an account
                HStack(alignment: .center, spacing: 2) {
                    Text("Do you have an account?")
                        .customFont(style: .bold, size: .h18)
                        .foregroundColor(.darkfont)
                    Button("Login") {
                        path.pop()
                    }
                    .foregroundColor(.bluefont)
                    .customFont(style: .bold, size: .h18)
                    Spacer()
                }
                .padding(.horizontal, 28)
                Spacer()
                CustomButtonView(title: "Sign up") {
                    if viewModel.validate() {
                          Task {
                              await viewModel.callSignupApi()
                          }
                      } else {
                        viewModel.showError = true
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden()

        }
        .popup(isPresented: $showGenderMenu) {
            GenderBottomSheet(
                isPresented: $showGenderMenu,
                actionSave: { selectedGender in
                    viewModel.gender = selectedGender
                },
                selectedGender: viewModel.gender
            )
        } customize: {
            $0.type(.toast).position(.bottom).closeOnTap(false).backgroundColor(.black.opacity(0.4))
        }

        .popup(isPresented: $showAge) {
            AgeBottomSheet(isPresented: $showAge, selectedAge: viewModel.age) { selectedAge in
                viewModel.age = selectedAge
            }
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $showName) {
            NameBottomSheet(isPresented: $showName) { fname, lname in
                viewModel.name = fname + " " + lname
            }
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }

        .popup(isPresented: $viewModel.showError) {
            ErrorView(errorMessage: viewModel.errorMessage ?? "" )
        } customize: {
            $0
                .type(.toast)
                .autohideIn(1.5)
                .position(.top)
        }
        .popup(isPresented: $viewModel.signupSuccess) {
            SuccessView(successMessage: "You're signed up successfully!")
                .onDisappear {
                    path.pop()
                }
        } customize: {
            $0.type(.toast).autohideIn(1.5).position(.top)
        }
        .loadingIndicator($viewModel.isLoading)
        .onTapGesture {
            hideKeyboard()
        }

    }
}


#Preview {
    SignupView(path: .constant(NavigationPath()))
}
