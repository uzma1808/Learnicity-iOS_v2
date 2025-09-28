//
//  CustomButtonView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//

import SwiftUI

struct CustomButtonView: View {
    var title: String
    var backgroundColor: Color = Color.blue
    var textColor: Color = .white
    var cornerRadius: CGFloat = 12
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}


#Preview {
    CustomButtonView(title: "Login", action: {})
}
