//
//  EditProfileView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 04/10/2025.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var path: NavigationPath
    @State private var showGenderMenu: Bool = false
    @State private var showAge: Bool = false
    @State private var showName: Bool = false
    @State var actionSheets = ActionSheetsState()
    @StateObject private var viewModel = EditProfileViewModel()
    let genders = ["Male", "Female", "Other"]
    @State private var showToast: Bool = false

    // MARK: - Image Picker States
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceActionSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                CustomHeaderView(title: "Edit Profile", backAction: {
                    path.pop()
                })

                // MARK: - Profile Image with Camera Button
                ZStack(alignment: .bottomTrailing) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: UserSession.shared.user?.profile_image ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())

                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())

                            case .failure:
                                Image(.user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())

                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                    }

                    // Camera button
                    Button(action: {
                        showSourceActionSheet = true
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .offset(x: -5, y: 0)
                }

                // MARK: - Fields
                VStack(spacing: 16) {
                    CustomTextfieldView(placeholder: "Name", text: $viewModel.name)
                        .frame(height: 58)
                        .overlay(
                            Button(action: { showName = true }) {
                                Color.clear
                            }
                        )

                    HStack(spacing: 16) {
                        CustomTextfieldView(placeholder: "Age", text: $viewModel.age)
                            .frame(height: 58)
                            .overlay(
                                Button(action: { showAge = true }) {
                                    Color.clear
                                }
                            )

                        CustomTextfieldView(placeholder: "Gender", text: $viewModel.gender)
                            .frame(height: 58)
                            .overlay(
                                Button(action: { showGenderMenu = true }) {
                                    Color.clear
                                }
                            )
                    }

                    CustomTextfieldView(placeholder: "Email", text: $viewModel.email)
                        .frame(height: 58)
                        .opacity(0.5)
                        .disabled(true)
                }
                .padding(.horizontal, 28)

                Spacer()

                // MARK: - Update Button
                CustomButtonView(title: "Update") {
                    if viewModel.validate() {
                        Task {
                            await viewModel.callUpdateApi()
                            if !viewModel.showError {
                                showToast = true
                            }
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
        .toast($showToast, "Profile updated!")
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
            $0.type(.toast).position(.bottom).closeOnTap(false).backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $showName) {
            NameBottomSheet(isPresented: $showName, fName: viewModel.fname, lName: viewModel.lname) { fname, lname in
                viewModel.name = fname + " " + lname
                viewModel.fname = fname
                viewModel.lname = lname
            }
        } customize: {
            $0.type(.toast).position(.bottom).closeOnTap(false).backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $viewModel.showError) {
            ErrorView(errorMessage: viewModel.errorMessage ?? "")
        } customize: {
            $0.type(.toast).autohideIn(1.5).position(.top)
        }
        .loadingIndicator($viewModel.isLoading)
        .onTapGesture { hideKeyboard() }
        .onAppear {
            let names = viewModel.name.components(separatedBy: " ")
            viewModel.fname = names.first ?? ""
            viewModel.lname = names.last ?? ""
        }

        // MARK: - Image Picker Sheets
        .confirmationDialog("Select Image Source", isPresented: $showSourceActionSheet) {
            Button("Camera") {
                imagePickerSource = .camera
                showImagePicker = true
            }
            Button("Photo Library") {
                imagePickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSource, selectedImage: $selectedImage)
        }
    }
}


#Preview {
    EditProfileView(path: .constant(NavigationPath()))
}
