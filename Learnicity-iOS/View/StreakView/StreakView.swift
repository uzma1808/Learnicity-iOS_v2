//
//  StreakView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI

struct StreakView: View {
    @Binding var path: NavigationPath
    @State var screenHeight : CGFloat = UIScreen.main.bounds.height
    var body: some View {
        VStack {
            CustomHeaderView(title: "Streaks") {
                path.pop()
            }
            Color.clear
                .frame(height: screenHeight * 0.20)
            VStack(spacing: 30) {
                Image(.streak2)
                    .resizable()
                    .frame(width: 120, height: 120)
                Text("You’re on a\n\(UserSession.shared.fetchUserStreak()) Day\nLearning Streak!")
                    .customFont(style: .black, size: .h36)
                    .multilineTextAlignment(.center)

            }
            Spacer()

        }
        .navigationBarBackButtonHidden()

    }
}

#Preview {
    StreakView(path: .constant(NavigationPath()))
}
