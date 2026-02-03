//
//  AgeView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 14/08/2025.
//

import SwiftUI
import KeyboardManager_SwiftUI

struct AgeBottomSheet: View {
    @Binding var isPresented: Bool
    @State var selectedAge: String
    var actionSave: (String) -> Void
    @StateObject private var keyboard = KeyboardObserver()


    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Age")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextfieldView(placeholder: "Enter age", text: $selectedAge)
                .frame(height: 58)

            CustomButtonView(title: "Save") {
                hideKeyboard()
                isPresented = false
                actionSave(selectedAge)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, keyboard.height)
        .onTapGesture {
            hideKeyboard()
        }
    }
}


#Preview {
    AgeBottomSheet(isPresented: .constant(false), selectedAge: "", actionSave: {_ in})
}
