//
//  CustomTextfieldView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 02/08/2025.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct CustomTextfieldView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var placeholderColor: UIColor = .black
    var textColor: UIColor = .black
    var font: UIFont = UIFont(name: "Roboto-Bold",size: 18) ?? .systemFont(ofSize: 18)

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.textColor = textColor
        textField.font = font
        textField.isSecureTextEntry = isSecure
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        textField.setLeftPaddingPoints(12)

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ]
        )

        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecure
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc func textChanged(_ sender: UITextField) {
            let currentText = sender.text ?? ""
            text.wrappedValue = currentText
        }
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
