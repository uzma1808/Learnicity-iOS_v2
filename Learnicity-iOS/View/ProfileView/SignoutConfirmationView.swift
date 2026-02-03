//
//  SignoutConfirmationView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/10/2025.
//

import SwiftUI

struct SignoutConfirmationView: View {
    @Binding var isPresented: Bool
    var action: () -> Void  // Fixed: removed the optional (?) from Void

    var body: some View {
        VStack(spacing: 40) {
            Text("Sign Out")
                .customFont(style: .bold, size: .h20)
            Text("Are you sure want to Sign out your Account?")
                .customFont(style: .semiBold, size: .h18)
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .customFont(style: .bold, size: .h18)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.clear)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1)
                )

                Button(action: {
                    isPresented = false
                    action()
                }) {
                    Text("Sign out")
                        .customFont(style: .bold, size: .h18)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    SignoutConfirmationView(isPresented: .constant(false), action: {})
}
