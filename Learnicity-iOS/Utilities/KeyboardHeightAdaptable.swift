//
//  KeyboardHeightAdaptable.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 13/10/2025.
//
import SwiftUI
import Combine
import UIKit

struct KeyboardHeightAdaptable: ViewModifier {
    
    @State private var bottomPadding: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, bottomPadding)
                .onReceive(KeyboardPublishers.heightPublisher) { keyboardHeight in
                    // Keyboard top position in screen coordinates
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    
                    // Find currently focused input view (UITextField/TextView)
                    let focusedInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    
                    // Compute how much the input is hidden by the keyboard
                    var overlap = focusedInputBottom - keyboardTop
                    
                    // If overlap is positive, push content up
                    if overlap > 0 {
                        overlap += geometry.safeAreaInsets.bottom + 16 // add small extra padding
                    } else {
                        overlap = 0
                    }
                    
                    withAnimation(.easeOut(duration: 0.25)) {
                        bottomPadding = overlap
                    }
                }
        }
    }
}

public extension View {
    func keyboardAdaptive() -> some View {
        modifier(KeyboardHeightAdaptable())
    }
}

enum KeyboardPublishers {

    /// Publishes the height of the keyboard whenever it appears, changes, or hides.
    static var heightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }

        return Publishers.Merge(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

public extension UIResponder {

    private static weak var _currentFirstResponder: UIResponder?

    /// Returns the current first responder (active text field / text view)
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trapFirstResponder), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func _trapFirstResponder() {
        UIResponder._currentFirstResponder = self
    }

    /// Global frame of the responder (e.g., UITextField, UITextView)
    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
