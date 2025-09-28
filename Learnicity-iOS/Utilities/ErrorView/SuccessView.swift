//
//  SuccessView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/09/2025.
//

import SwiftUI

struct SuccessView: View {
    var successMessage: String
    var body: some View {
        Text(successMessage)
            .customFont(style: .medium, size: .h14)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 60, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: .infinity)
            .background(Color.red)
    }
}

#Preview {
    SuccessView(successMessage: "")
}
