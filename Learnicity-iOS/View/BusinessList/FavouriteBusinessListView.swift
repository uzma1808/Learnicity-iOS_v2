//
//  FavouriteBusinessListView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/10/2025.
//

import SwiftUI

struct FavouriteBusinessListView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = BusinessListView.BusinessViewModel()

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
            CustomHeaderView(title: "My Favourites") {
                path.pop()
            }
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
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchBusinesses(type: "favourite")
            }
        }
    }
}

#Preview {
    FavouriteBusinessListView(path: .constant(NavigationPath()))
}
