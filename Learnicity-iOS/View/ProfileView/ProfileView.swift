//
//  ProfileView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/10/2025.
//

import SwiftUI
import PopupView


struct ProfileView: View {

    @Binding var path: NavigationPath
    @State private var showLogout: Bool = false
    @State private var showDelete: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            CustomHeaderView(title: "Profile") {
                path.pop()
            }

            // Profile Picture and Info
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: UserSession.shared.user?.profile_image ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())

                    case .success(let image):
                        image.resizable()
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())

                    case .failure:
                        Image(.product) // fallback if failed
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

                Text(UserSession.shared.user?.name ?? "")
                    .customFont(style: .black, size: .h24)
                    .foregroundStyle(.black)

                Text("Age: \(String(UserSession.shared.user?.age ?? 0))   Gender: \(UserSession.shared.user?.gender ?? "")")
                    .customFont(style: .semiBold, size: .h15)
                    .foregroundStyle(.graytext)
            }
            .padding(.top, 10)

            // Options List
            VStack(alignment: .leading, spacing: 18) {
                ProfileRow(icon: "square.and.pencil", title: "Edit Profile")
                    .onTapGesture {
                        print("edit")
                    }
                ProfileRow(icon: "gear", title: "Quiz Settings")
                    .onTapGesture {
                        print("edit")
                    }
                ProfileRow(icon: "trash", title: "Delete Account")
                    .onTapGesture {
                        showDelete = true
                    }
                ProfileRow(icon: "envelope", title: "Contact us")
                    .onTapGesture {
                        print("cont")
                    }
                ProfileRow(icon: "questionmark.circle", title: "FAQ")
                    .onTapGesture {
                        print("faq")
                    }
                ProfileRow(icon: "lock.doc", title: "Privacy Policy")
                    .onTapGesture {
                        print("priv pol")
                    }
                ProfileRow(icon: "doc.text", title: "Terms & Conditions")
                    .onTapGesture {
                        print("t&c")
                    }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()

            // Logout Button
            Button(action: {
                showLogout = true
            }) {
                Text("LOG OUT")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden()
        .popup(isPresented: $showLogout) {
            SignoutConfirmationView(isPresented: $showLogout) {
                UserSession.shared.clear()
                path.popToRoot(index: 0)
            }
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $showDelete) {
            DeleteConfirmationView(isPresented: $showDelete) {
                print("delete account ")
            }
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}

// Reusable Row View
struct ProfileRow: View {
    var icon: String
    var title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .fontWeight(.semibold)
                .foregroundColor(.darkfont)
                .frame(width: 24)
            Text(title)
                .customFont(style: .bold, size: .h18)
                .foregroundStyle(.black)
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(path: .constant(NavigationPath()))
    }
}
