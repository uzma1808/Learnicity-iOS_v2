//
//  ProfileView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/10/2025.
//

import SwiftUI
import PopupView
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @Binding var path: NavigationPath
    @State private var showLogout: Bool = false
    @State private var showDelete: Bool = false
    @StateObject private var viewModel = ProfileViewModel()
    @State var userData : UserData?
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                CustomHeaderView(title: "Profile") {
                    path.pop()
                }
                
                // Profile Picture and Info
                VStack(spacing: 8) {
                    
                    WebImage(url: URL(string: userData?.profile_image ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle().foregroundColor(.lightgraybg)
                    }
                    .onSuccess { image, data, cacheType in  }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: 90, height: 90, alignment: .center)
                    .clipShape(Circle())
                    
                    
                    Text(userData?.name ?? "")
                        .customFont(style: .black, size: .h24)
                        .foregroundStyle(.black)
                    
                    Text(
                        [
                            userData?.age != nil ? "Age: \(userData!.age!)" : nil,
                            userData?.gender != nil ? "Gender: \(userData!.gender!)" : nil
                        ]
                            .compactMap { $0 }
                            .joined(separator: "   ")
                    )
                    .customFont(style: .semiBold, size: .h15)
                    .foregroundStyle(.graytext)
                }
                .padding(.top, 10)
                
                // Options List
                VStack(alignment: .leading, spacing: 18) {
                    ProfileRow(icon: "square.and.pencil", title: "Edit Profile")
                        .onTapGesture {
                            path.push(screen: .editProfile)
                        }
                    ProfileRow(icon: "gear", title: "Quiz Settings")
                        .onTapGesture {
                            path.push(screen: .chooseSubject(settings: true))
                        }
                    ProfileRow(icon: "trash", title: "Delete Account")
                        .onTapGesture {
                            showDelete = true
                        }
                    ProfileRow(icon: "envelope", title: "Contact us")
                        .onTapGesture {
                            openURL(Constants.contact_us)
                        }
                    ProfileRow(icon: "questionmark.circle", title: "FAQ")
                        .onTapGesture {
                            path.push(screen: .faq)
                        }
                    ProfileRow(icon: "lock.doc", title: "Privacy Policy")
                        .onTapGesture {
                            openURL(Constants.privacy_policy)
                        }
                    ProfileRow(icon: "doc.text", title: "Terms & Conditions")
                        .onTapGesture {
                            openURL(Constants.terms_conditions)
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
            .allowsHitTesting(!showLogout && !showDelete) // Disable touches on background when popup is open
            
            // Overlay to block background touches when popup is visible
            if showLogout || showDelete {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showLogout = false
                        showDelete = false
                    }
            }
        }
        .onAppear(perform: {
            userData = UserSession.shared.user
        })
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
                .backgroundColor(.clear) // We handle our own overlay now
            
        }
        .popup(isPresented: $showDelete) {
            DeleteConfirmationView(isPresented: $showDelete) {
                print("delete account ")
                Task {
                    await viewModel.deleteAccount()
                    if viewModel.accountDeleted {
                        UserSession.shared.clear()
                        path.popToRoot(index: 0)
                    }
                }
            }
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.clear) // We handle our own overlay now
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
