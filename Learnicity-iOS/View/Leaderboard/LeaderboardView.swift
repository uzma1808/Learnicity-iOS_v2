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
    var image: String // image name in Assets

    var body: some View {
        VStack {
            // Bar with profile pic + rank
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 80, height: height)

                VStack {
                    // Profile image inside circle
                    Image(.profile)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(y: -25)

                    Spacer()

                    // Rank number at bottom inside bar
                    Text("\(rank)")
                        .customFont(style: .extraBold, size: .h24)
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                }
                .frame(height: height)
            }

            // Name
            Text(name)
                .customFont(style: .bold, size: .h18)

            // Coins
            Text("Coin: \(coins)")
                .customFont(style: .bold, size: .h18)
                .foregroundColor(.black)
        }
        .frame(width: 100)
    }
}

struct LeaderboardView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            CustomHeaderView(title: "Leader Board", backAction: {
                path.pop()
            })
            Image(.animalLeaderboard) // Replace with your mascot image
                .resizable()
                .frame(width: 102, height: 102)

            Text("COINS EARNED")
                .customFont(style: .black, size: .h30)
            Spacer()
            HStack(alignment: .bottom, spacing: 20) {
                LeaderboardBar(
                    color: .leaderboard1,
                    height: 400,
                    rank: 1,
                    name: "Mia",
                    coins: 2514,
                    image: "mia"
                )
                LeaderboardBar(
                    color: .leaderboard2,
                    height: 267,
                    rank: 2,
                    name: "Sophie",
                    coins: 1824,
                    image: "sophie"
                )
                LeaderboardBar(
                    color: .leaderboard3,
                    height: 134,
                    rank: 3,
                    name: "Ella",
                    coins: 895,
                    image: "ella"
                )
            }
            .padding(.top, 40)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LeaderboardView(path: .constant(NavigationPath()))
}

