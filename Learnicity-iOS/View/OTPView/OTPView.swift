//
//  OTPView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 15/08/2025.
//

import SwiftUI

import SwiftUI

struct OTPView: View {

    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss

    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?

    @State private var timeRemaining: Int = 300 // 5 minutes
    @State private var timer: Timer?

    let email: String

    var body: some View {
        VStack(spacing: 24) {

            CustomHeaderView(title: "Verify") {
                path.pop()
            }

            Image(.celebration)
                .resizable()
                .scaledToFit()
                .frame(width: 78, height: 78)

            // Email Icon
            Image(.emailEnvelope)
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(.bluefont)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(width: 56, height: 56)
                )

            // OTP Title + Email
            VStack(alignment: .center, spacing: 4) {
                Text("OTP Verification")
                    .customFont(style: .bold, size: .h18)
                Text("Enter the OTP sent at")
                    .customFont(style: .medium, size: .h18)
                    .foregroundColor(.darkfont)
                    .font(.system(size: 14))
                Text(email)
                    .customFont(style: .medium, size: .h18)
                    .foregroundColor(.bluefont)
                    .font(.system(size: 14))
            }

            // OTP Fields2
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $otpFields[index])
                        .customFont(style: .medium, size: .h28)
                        .foregroundStyle(.maintheme)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.border, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: otpFields[index]) { newValue in
                            if newValue.count == 1 {
                                if index < 5 { focusedIndex = index + 1 }
                            } else if newValue.isEmpty {
                                if index > 0 { focusedIndex = index - 1 }
                            }
                        }
                }
            }

            // Timer & Resend
            VStack(spacing: 4) {
                Text("Code Expires in \(formattedTime)")
                    .customFont(style: .medium, size: .h18)
                    .foregroundColor(.darkfont)
                HStack {
                    Text("Didn't receive the code?")
                        .customFont(style: .medium, size: .h18)
                        .foregroundColor(.darkfont)
                    Button("Resend OTP") {
                        resendOTP()
                    }
                    .customFont(style: .medium, size: .h18)
                    .foregroundColor(.bluefont)
                }
                .font(.system(size: 14, weight: .bold))
            }

            Spacer()

            // Login Button
            CustomButtonView(title: "Login", action: {
                print("login clicked")
            })
            .padding(.horizontal, 17)
            .padding(.bottom)

        }
        .onAppear {
            startTimer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .background(Color.white.ignoresSafeArea())

    }

    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }

    private func resendOTP() {
        timeRemaining = 300
        startTimer()
        print("Resend OTP triggered")
    }
}


#Preview {
    OTPView(path: .constant(NavigationPath()), email: "john@gmail.com")
}
