//
//  BusinessDetailsView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 17/09/2025.
//

import SwiftUI

struct BusinessDetailView: View {
    @StateObject private var viewModel = BusinessDetailViewModel()
    @Binding var path: NavigationPath
    let images = ["cafeheader", "cafeheader", "cafeheader"]
    var businessId: Int?

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header Image with Back Button
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: viewModel.businessDetail?.businessCover ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)

                    case .success(let image):
                        image.resizable()
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()

                    case .failure:
                        Image(.product) // fallback if failed
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()

                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 300)

                Button(action: {
                    path.pop()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(.leading, 40)
                .padding(.top, 40)
            }


            // MARK: - Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    // Title & Address
                    Text(viewModel.businessDetail?.name ?? "")
                        .customFont(style: .black, size: .h24)
                        .foregroundStyle(.black)

                    Text(viewModel.businessDetail?.address ?? "")
                        .customFont(style: .semiBold, size: .h18)
                        .foregroundStyle(.darkfont)

                    // Avatars
                    HStack(spacing: -10) {
                        ForEach(viewModel.businessDetail?.recentRedeemUsers ?? [], id: \.self) { person in
                            AsyncImage(url: URL(string: person)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 40, height: 40)

                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 2)
                                        )

                                case .failure:
                                    Image(.product) // fallback if failed
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 2)
                                        )

                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }


                    // Description
                    Text(viewModel.businessDetail?.description ?? "")
                        .customFont(style: .regular, size: .h18)
                        .foregroundStyle(.darkfont)

                    // Rewards List
                    VStack(spacing: 12) {
                        ForEach(viewModel.businessDetail?.products ?? [], id: \.id) { product in
                            RewardRowView(
                                title: product.name ?? "",
                                coins: product.requiredCoins ?? 0,
                                imageName: product.image ?? "coffee"
                            )
                            .onTapGesture {
                                path.push(screen: .scanner(product))
                            }
                        }
                        Spacer().frame(height: 80) // leave space so button won’t overlap content
                    }
                }
                .padding()
            }

            // MARK: - Sticky Bottom Button
            VStack {
                Button(action: {
                    // action
                }) {
                    Text("\(viewModel.businessDetail?.redeemableCoins ?? 0)" + " Coins" )
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchBusinessDetail(businessId: businessId ?? 0)
            }
        }
    }
}

struct RewardRowView: View {
    let title: String
    let coins: Int
    let imageName: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageName)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)

                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)


                case .failure:
                    Image(.product) // fallback if failed
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)


                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(style: .semiBold, size: .h18)
                    .foregroundStyle(.darkfont)

                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.orange)
                    Text("\(coins) Coins")
                        .customFont(style: .semiBold, size: .h14)
                        .foregroundStyle(.darkfont)
                }
            }
            Spacer()

            Image(systemName: "qrcode")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.black.opacity(0.7))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
