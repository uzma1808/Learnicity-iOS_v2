//
//  Fonts.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import Foundation
import SwiftUI

/// Enum for custom fonts
enum CustomFonts: String {
    case roboto = "Roboto"
}

/// Enum for different styles of the custom fonts
enum CustomFontStyle: String {
    case bold = "-Bold"
    case light = "-Light"
    case medium = "-Medium"
    case regular = "-Regular"
    case semiBold = "-SemiBold"
    case thin = "-Thin"
    case black = "-Black"
    case extraBold = "-ExtraBold"
    case italic = "-Italic"
}

/// Enum for font sizes
enum CustomFontSize: CGFloat {
    case h50 = 50.0
    case h40 = 40.0
    case h36 = 36.0
    case h35 = 35.0
    case h34 = 34.0
    case h32 = 32.0
    case h30 = 30.0
    case h28 = 28.0
    case h26 = 26.0
    case h24 = 24.0
    case h22 = 22.0
    case h20 = 20.0
    case h18 = 18.0
    case h16 = 16.0
    case h15 = 15.0
    case h14 = 14.0
    case h13 = 13.0
    case h12 = 12.0
    case h11 = 11.0
    case h10 = 10.0
    case h9 = 9.0

}

/// Custom font modifier for applying font settings to views
struct CustomFontModifier: ViewModifier {
    var font: CustomFonts
    var style: CustomFontStyle
    var size: CustomFontSize
    var isScaled: Bool = true

    func body(content: Content) -> some View {
        let fontName = font.rawValue + style.rawValue // Construct the full font name

        // Attempt to load the custom font
        guard let uiFont = UIFont(name: fontName, size: size.rawValue) else {
            // Return default system font if custom font cannot be loaded
            return content.font(Font.system(size: size.rawValue))
        }

        // Scale the font if required
        let scaledUIFont = isScaled ? UIFontMetrics.default.scaledFont(for: uiFont) : uiFont
        let font = Font(scaledUIFont)

        // Apply the font to the content
        return content.font(font)
    }
}

/// Extension to easily apply custom fonts to any view
extension View {
    func customFont(
        font: CustomFonts? = .roboto,
        style: CustomFontStyle,
        size: CustomFontSize,
        isScaled: Bool = true) -> some View {
            // Apply the custom font modifier to the view
            return self.modifier(CustomFontModifier(font: font ?? .roboto, style: style, size: size, isScaled: isScaled))
        }
}
