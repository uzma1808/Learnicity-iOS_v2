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
    var actionSave: (String) -> Void?

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)

                Text("Age")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                CustomTextfieldView(placeholder: "Enter age", text: $selectedAge)
                    .frame(height: 58)

                CustomButtonView(title: "Save") {
                    isPresented = false
                    actionSave(selectedAge)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .keyboardHeightAdaptable()
        }
    }
}

#Preview {
    AgeBottomSheet(isPresented: .constant(false), selectedAge: "", actionSave: {_ in})
}
