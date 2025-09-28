//
//  CustomHeader.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//


import SwiftUI

struct CustomHeaderView: View {
    var title: String
    var backAction: () -> Void

    var body: some View {
        ZStack {
            Text(title)
                .customFont(style: .black, size: .h32)
                .foregroundColor(.black)

            HStack {
                Button(action: backAction) {
                    Image(.backarrow)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
