//
//  GenderBottomSheet.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//


import SwiftUI

struct GenderBottomSheet: View {
    @Binding var isPresented: Bool
    var actionSave: (String) -> Void
    @State var selectedGender: String

    let options = [
        "Male",
        "Female",
        "Non-Binary"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Gender")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Wrap options in ScrollView for proper scrolling
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Text(option)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: selectedGender == option ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.blue)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedGender = option
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .frame(maxHeight: 140) // Limit height if you have many options

            CustomButtonView(title: "Save") {
                isPresented = false
                actionSave(selectedGender)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

