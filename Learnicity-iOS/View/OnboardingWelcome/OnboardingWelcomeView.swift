//
//  OnboardingWelcomeView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Image(.animalwelcome)
                .resizable()
                .scaledToFit()
                .frame(width: 198, height: 230)
            Text("Welcome")
                .customFont(style: .black, size: .h30)
            Text("Ready to Learn & Earn")
                .customFont(style: .black, size: .h30)
            Spacer()
            Image(.celebration)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Spacer()
            CustomButtonView(title: "Let’s Go!", action: {
                path.push(screen: .chooseSubject)
            })
            .padding(.horizontal, 17)
            .padding(.bottom)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OnboardingWelcomeView(path: .constant(NavigationPath()))
}
