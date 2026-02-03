//
//  NameBottomSheet.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 14/08/2025.
//

import SwiftUI
import KeyboardManager_SwiftUI

struct NameBottomSheet: View {
    @Binding var isPresented: Bool
    @State var fName: String = ""
    @State var lName: String = ""
    @StateObject private var keyboard = KeyboardObserver()

    var actionSave: (String, String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Full Name")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextfieldView(placeholder: "First name", text: $fName)
                .frame(height: 58)

            CustomTextfieldView(placeholder: "Last name", text: $lName)
                .frame(height: 58)

            CustomButtonView(title: "Save") {
                isPresented = false
                actionSave(fName, lName)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, keyboard.height) // <-- this is the key line
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    NameBottomSheet(isPresented: .constant(false), fName: "", lName: "", actionSave: {_,_ in})
}


