//
//  BusinessListView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 26/08/2025.
//

import SwiftUI

import SwiftUI

struct BusinessListView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = BusinessViewModel()

    @State private var searchText = ""
    let coins = UserSession.shared.fetchRedeemableCoins()
    var filteredBusinesses: [BusinessDetailData] {
            if searchText.isEmpty {
                return viewModel.businesses
            } else {
                return viewModel.businesses.filter { business in
                    (business.name ?? "")
                        .localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    var body: some View {
        VStack(spacing: 16) {

            // Search bar
            HStack {
                TextField("Search your dream Business", text: $searchText)
                    .customFont(style: .medium, size: .h14)
                    .padding(12)
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.trailing, 12)
            }
            .background(Color(.cardbg2))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.searchborder, lineWidth: 1)
            )
            .padding(.horizontal)


            // Coins Section
            HStack {
                Text("You have ")
                    .font(.headline)
                +
                Text("\(coins) ")
                    .font(.headline)
                    .foregroundColor(.green)
                +
                Text("Redeemable Coins")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)

            // List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredBusinesses) { business in
                        HStack {
                            AsyncImage(url: URL(string: business.profileImage ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // placeholder while loading
                                        .frame(width: 55, height: 55)

                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .clipShape(Circle())

                                case .failure:
                                    Image(.product) // fallback if failed
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .clipShape(Circle())

                                @unknown default:
                                    EmptyView()
                                }
                            }


                            VStack(alignment: .leading, spacing: 4) {
                                Text(business.name ?? "")
                                    .customFont(style: .semiBold, size: .h18)
                                    .foregroundColor(.graytext)

                                Text("\(business.productsCount ?? 0) Products")
                                    .customFont(style: .semiBold, size: .h12)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.graytext)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(Color(.cardbg2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .onTapGesture {
                            path.push(screen: .businessDetails(business.id ?? 0))
                        }

                    }
                }
                .padding(.bottom, 80)
            }

            // Bottom Bar
            HStack(spacing: 12) {
                Button(action: {
                    path.push(screen: .businessMap)
                }) {
                    HStack {
                        Image(.globe)
                            .resizable()
                            .frame(width: 26,height: 26)
                        Text("Search on Map")
                            .customFont(style: .bold, size: .h16)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                Button(action: {
                    path.pop()
                }) {
                    Image(.home)
                        .resizable()
                        .frame(width: 26,height: 26)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .frame(width: 50)
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchBusinesses(type: "list")
            }
        }
    }
}

struct BusinessListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView(path: .constant(NavigationPath()))
    }
}
