//
//  ScanScreen.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 27/09/2025.
//

import SwiftUI

struct ScanScreen: View {
    @State private var scannedCode: String? = nil
    var productDetails: Product?
    @Binding var path: NavigationPath
    @StateObject var viewModel = RedeemProductViewModel()
    var body: some View {
        VStack(spacing: 20) {
            CustomHeaderView(title: "") {
                path.pop()
            }
            // Title
            Text("Scan QR Code")
                .customFont(style: .black, size: .h30)

            // Subtitle
            Text("Scan the Learnicity QR Code in the Business. It is normally placed near the register.")
                .customFont(style: .regular, size: .h18)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // QR Scanner
            ZStack {
                QRScannerView(scannedCode: $scannedCode)
                    .frame(width: 250, height: 250)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 4)
                    )
            }

            // Result or Hint
            Text("Scan Me")
                .customFont(style: .medium, size: .h30)
                .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .loadingIndicator($viewModel.isLoading)
        .onChange(of: scannedCode) { oldValue, newValue in
            print("***QRCode", newValue)
            if newValue != nil {
                if productDetails?.qrcodeString == newValue {
                    if let id = productDetails?.id {
                        Task {
                            let status = await viewModel.redeemProduct(productID: id)
                            if status {
                                path.push(screen: .redeemSuccess(productDetails!))
                            } else {
                                path.push(screen: .redeemFailed)
                            }
                        }
                    }
                } else {
                    path.push(screen: .redeemFailed)
                }
            }
        }
    }
}


#Preview {
    ScanScreen(path: .constant(NavigationPath()))
}
