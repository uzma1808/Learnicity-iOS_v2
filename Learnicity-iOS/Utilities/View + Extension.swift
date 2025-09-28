//
//  View + Extension.swift
//  ePokratis-iOS
//
//  Created by UzmaAmjad on 12/07/2024.
//

import Foundation
import SwiftUI
import Combine
import PopupView
import ActivityIndicatorView

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }

    func loadingIndicator(_ isLoading: Binding<Bool>) -> some View {
        modifier(AppLoadingIndicator(isLoading: isLoading))
    }

    func toast(_ showToast: Binding<Bool>, _ message: String) -> some View {
        modifier(AppToast(showToast: showToast, message: message))
    }

    func topToast(_ showToast: Binding<Bool>, _ message: String) -> some View {
        modifier(AppTopToast(showToast: showToast, message: message))
    }
}

struct AppLoadingIndicator: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isLoading) {
                ActivityIndicatorView(isVisible: .constant(isLoading), type: .arcs(count: 1, lineWidth: 3)).frame(width: 30, height: 30).foregroundColor(.maintheme)
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .backgroundColor(.black.opacity(0.2))
        }
    }
}

struct AppToast: ViewModifier {
    @Binding var showToast: Bool
    var message: String

    func body(content: Content) -> some View {
        content
            .popup(isPresented: $showToast) {
            VStack {
                Text(message)
                    .foregroundStyle(Color.black)
                    .customFont(style: .regular, size: .h18)
                    .padding()
            }  .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: 180, minHeight: 50)
                .background(Color.white)
                .cornerRadius(30.0)
        } customize: {
            $0
                .type(.floater())
                 .position(.bottom)
                 .animation(.spring())
                 .autohideIn(2)
                 .isOpaque(true)
        }
    }
}
struct AppTopToast: ViewModifier {
    @Binding var showToast: Bool
    var message: String

    func body(content: Content) -> some View {
        content
            .popup(isPresented: $showToast) {
            VStack {
                Text(message)
                    .foregroundStyle(Color.black)
                    .customFont(style: .regular, size: .h18)
                    .padding()
            }  .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: 180, minHeight: 50)
                .background(Color.white)
                .cornerRadius(30.0)
        } customize: {
            $0
                .type(.floater())
                 .position(.top)
                 .animation(.spring())
                 .autohideIn(4)
                 .isOpaque(true)
        }
    }
}
