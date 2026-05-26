import SwiftUI

// MARK: - Typography System
// Manrope for headlines/display, Inter for body/labels

extension Font {
    // MARK: - Headline (Manrope)

    static func headline(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        let name: String
        switch weight {
        case .black, .heavy: name = "Manrope-ExtraBold"
        case .bold: name = "Manrope-Bold"
        case .semibold: name = "Manrope-SemiBold"
        case .medium: name = "Manrope-Medium"
        default: name = "Manrope-Regular"
        }
        // Variable font registers under family name; use custom font with weight
        return .custom("Manrope", size: size).weight(weight)
    }

    // MARK: - Body (Inter)

    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("Inter", size: size).weight(weight)
    }

    // MARK: - Label (Inter)

    static func label(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        return .custom("Inter", size: size).weight(weight)
    }

    // MARK: - Convenience Presets

    /// Display large — e.g. remaining calorie count
    static let dsDisplayLG = Font.headline(42, weight: .heavy)

    /// Title — e.g. screen title
    static let dsTitle = Font.headline(20, weight: .bold)

    /// Headline — e.g. card titles
    static let dsHeadline = Font.headline(16, weight: .bold)

    /// Body medium
    static let dsBody = Font.body(14, weight: .regular)

    /// Body small
    static let dsBodySM = Font.body(13, weight: .medium)

    /// Label small — e.g. "PROTEIN", "REMAINING"
    static let dsLabelSM = Font.label(10, weight: .bold)

    /// Label medium
    static let dsLabelMD = Font.label(12, weight: .semibold)

    /// Caption
    static let dsCaption = Font.body(11, weight: .medium)
}
