//
//  HomeView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @State var screenSize : CGSize = .zero
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 14) {
                HomeHeader
                HStack(spacing : 14) {
                    StreakView
                    BusinessView
                }
                CoinView
                QuizView(vm: viewModel)

            }
            .padding()
            .onAppear {
                screenSize = geometry.size
                Task {
                    await viewModel.fetchHomeData()
                }
            }
            .onDisappear {
                viewModel.coinsEarned = nil
                viewModel.startQuiz =  false
                viewModel.selectedTrueFalse = nil
                viewModel.selectedMCQs.removeAll()
                viewModel.coinsEarned = nil
                viewModel.currentIndex = 0
            }

        }
        .navigationBarBackButtonHidden()

    }

    var HomeHeader: some View {
        HStack {
            Text("Hiya, \(UserSession.shared.user?.name ?? "")!")
                .customFont(style: .black, size: .h32)
            Spacer()
            Button(action: {
                path.push(screen: .profileView)

            }) {
                Image(.profile)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }

    var StreakView: some View {
        Button(action: {
            path.push(screen: .streak)
        }) {
            VStack {
                Image(.streak)
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(String(viewModel.homeData?.userStreak ?? 0) )
                    .customFont(style: .bold, size: .h24)
                    .foregroundStyle(.black)
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .foregroundStyle(.cardbg)
                    .frame(height: 110)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            )
        }
    }

    var BusinessView: some View {
        
        Button(action: {
            path.push(screen: .businessList)
        }) {
            VStack {
                Image(.business)
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(String(viewModel.homeData?.redeemableCoins ?? 0))
                    .customFont(style: .bold, size: .h24)
                    .foregroundStyle(.black)
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .foregroundStyle(.cardbg)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            )
        }
    }

    var CoinView: some View {
        Button(action: {
            path.push(screen: .leaderboard)
        }, label: {
            HStack {
                Image(.coin)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 16)
                Text(String(viewModel.homeData?.totalCoins ?? 0))
                    .customFont(style: .black, size: .h36)
                    .foregroundStyle(.black)
                Spacer()
                Image(.arrowLeft)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 16)

            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .foregroundStyle(.cardbg)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            )
        })
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}
