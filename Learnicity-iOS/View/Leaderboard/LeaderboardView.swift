//
//  LeaderboardView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI

import SwiftUI

struct LeaderboardBar: View {
    var color: Color
    var height: CGFloat
    var rank: Int
    var name: String
    var coins: Int
    var image: String

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 80, height: height)

                VStack {
                    if let url = URL(string: image), !image.isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable()
                            default:
                                Image(.user).resizable()
                            }
                        }
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(y: -25)
                    } else {
                        Image(.user)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(y: -25)
                    }

                    Spacer()

                    Text("\(rank)")
                        .customFont(style: .extraBold, size: .h24)
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                }
                .frame(height: height)
            }

            Text(name)
                .customFont(style: .bold, size: .h18)

            Text("Coin: \(coins)")
                .customFont(style: .bold, size: .h18)
                .foregroundColor(.black)
        }
        .frame(width: 100)
    }
}


struct LeaderboardView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = LeaderboardViewModel()

    var body: some View {
        VStack(spacing: 20) {
            CustomHeaderView(title: "Leaderboard", backAction: {
                path.pop()
            })

            Image(.animalLeaderboard)
                .resizable()
                .frame(width: 102, height: 102)

            Text("COINS EARNED")
                .customFont(style: .black, size: .h30)

            Spacer()

            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            } else if viewModel.leaderboard.isEmpty {
                Text("No leaderboard data available.")
                    .customFont(style: .regular, size: .h16)
                    .foregroundColor(.gray)
            } else {
                HStack(alignment: .bottom, spacing: 20) {
                    ForEach(viewModel.leaderboard.prefix(3)) { entry in
                        LeaderboardBar(
                            color: colorForRank(entry.position ?? 0),
                            height: heightForRank(entry.position ?? 0),
                            rank: entry.position ?? 0,
                            name: entry.name ?? "Anonymous",
                            coins: entry.redeemed_coins ?? 0,
                            image: entry.profile_image ?? ""
                        )
                    }
                }
                .padding(.top, 40)
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchLeaderboard()
            }
        }
        .popup(isPresented: $viewModel.showError) {
            ErrorView(errorMessage: viewModel.errorMessage ?? "")
        } customize: {
            $0.type(.toast).position(.top).autohideIn(1.5)
        }
        .loadingIndicator($viewModel.isLoading)
    }

    // MARK: - Helpers

    private func colorForRank(_ rank: Int) -> Color {
        switch rank {
        case 1: return .leaderboard1
        case 2: return .leaderboard2
        case 3: return .leaderboard3
        default: return .gray.opacity(0.3)
        }
    }

    private func heightForRank(_ rank: Int) -> CGFloat {
        switch rank {
        case 1: return 400
        case 2: return 267
        case 3: return 134
        default: return 100
        }
    }
}


#Preview {
    LeaderboardView(path: .constant(NavigationPath()))
}

