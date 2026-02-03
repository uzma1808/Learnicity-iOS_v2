//
//  KeyboardHeightAdaptable.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 13/10/2025.
//
import SwiftUI
import Combine
import UIKit

class KeyboardObserver: ObservableObject {
    @Published var height: CGFloat = 0
    private var showToken: Any?
    private var hideToken: Any?

    init() {
        showToken = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil, queue: .main
        ) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.height = frame.height
                }
            }
        }
        hideToken = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil, queue: .main
        ) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                self.height = 0
            }
        }
    }

    deinit {
        if let show = showToken { NotificationCenter.default.removeObserver(show) }
        if let hide = hideToken { NotificationCenter.default.removeObserver(hide) }
    }
}
