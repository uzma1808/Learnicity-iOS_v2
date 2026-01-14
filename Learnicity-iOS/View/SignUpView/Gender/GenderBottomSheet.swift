//
//  GenderBottomSheet.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//


import SwiftUI

struct GenderBottomSheet: View {
    @Binding var isPresented: Bool
    var actionSave: (String) -> Void?
    @State var selectedGender: String?

    let options = [
        "Male",
        "Female",
        "Non-Binary"
    ]

    var body: some View {
        ZStack {
            // Bottom sheet
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)

                Text("Gender")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(options, id: \.self) { option in
                    HStack {
                        Text(option)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: selectedGender == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedGender = option
                    }
                }

                CustomButtonView(title: "Save") {
                    isPresented = false
                    actionSave(selectedGender ?? "")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

