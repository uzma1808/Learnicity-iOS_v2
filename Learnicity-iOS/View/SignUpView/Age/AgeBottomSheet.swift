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
    @FocusState private var isFocused: Bool

    var actionSave: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Age")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextfieldView(placeholder: "Enter age", text: $selectedAge)
                .frame(height: 58)
                .focused($isFocused)

            CustomButtonView(title: "Save") {
                hideKeyboard()
                isPresented = false
                actionSave(selectedAge)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .keyboardAdaptive()
        .onAppear { isFocused = true }
    }
}

#Preview {
    AgeBottomSheet(isPresented: .constant(false), selectedAge: "", actionSave: {_ in})
}
