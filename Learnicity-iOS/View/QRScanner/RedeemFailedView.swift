//
//  RedeemFailedView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/09/2025.
//

import SwiftUI

struct RedeemFailedView: View {

    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            CustomHeaderView(title: "") {
                path.pop()
            }
            // Title
            Text("Redeem Failed!")
                .customFont(style: .black, size: .h30)
                .foregroundStyle(.errorred)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("We didn't catch that, try and scan again.")
                .customFont(style: .regular, size: .h18)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            // QR Scanner
            Image(.redeemfailed)
                .resizable()
                .frame(width: 200, height: 200)
            Spacer()
            // Result or Hint
            HStack {
                Text("You have ")
                    .font(.headline)
                +
                Text("\(UserSession.shared.redeemableCoins) ")
                    .font(.headline)
                    .foregroundColor(.green)
                +
                Text("Redeemable Coins")
                    .font(.headline)
            }
            .padding(.horizontal)

            Spacer()

                Button(action: {
                    path.pop()
                }) {
                    Text("Try Again")
                        .customFont(style: .bold, size: .h16)
                    .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)

            Button(action: {
            }) {
                HStack {
                    Image(.home)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.blue)
                        .frame(width: 26, height: 26)

                    Text("Go To Home")
                        .customFont(style: .bold, size: .h16)
                }
                .foregroundColor(.blue) // 👈 text & icon color
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white) // 👈 white background
                .frame(height: 58)
                .cornerRadius(12)
                .overlay(                  // 👈 blue border
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(height: 58)
                )
            }

        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }

    }
}

#Preview {
    RedeemFailedView(path: .constant(NavigationPath()))
}
