//
//  RedeemSuccessView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/09/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct RedeemSuccessView: View {
    @State private var scannedCode: String? = nil
    var productDetails: Product?

    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            CustomHeaderView(title: "") {
                path.pop()
            }
            // Title
            Text("Product Successfully\nRedeem")
                .customFont(style: .black, size: .h30)
                .foregroundStyle(.green)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Congrats on the Prize! Show this screen to the associate. Keep Learning to get Free Things!")
                .customFont(style: .regular, size: .h18)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            // QR Scanner
            ZStack {
                WebImage(url: URL(string: productDetails?.image ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                            Rectangle().foregroundColor(.lightgraybg)
                    }
                    .onSuccess { image, data, cacheType in  }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(30)

            }

            Spacer()
            // Result or Hint
            HStack {
                Text("You have ")
                    .font(.headline)
                +
                Text("\(productDetails?.requiredCoins ?? 0) ")
                    .font(.headline)
                    .foregroundColor(.green)
                +
                Text("Redeemable Coins")
                    .font(.headline)
            }
            .padding(.horizontal)

            Spacer()
            Text("Keep Enjoying")
                .customFont(style: .black, size: .h28)
            Spacer()
            HStack(spacing: 12) {
                Button(action: {
                    path.push(screen: .businessMap)
                }) {
                    HStack {
                        Image(.home)
                            .resizable()
                            .frame(width: 26,height: 26)
                        Text("Go To Home")
                            .customFont(style: .bold, size: .h16)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    RedeemSuccessView(path: .constant(NavigationPath()))
}
