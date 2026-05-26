import SwiftUI
import UIKit

// MARK: - "The Vitality Layer" Design System Color Tokens
// Light: Vitality Core (Fidelity, seed #22C55E, neutral #F9FAFB)
// Dark:  Vitality Core Dynamic (Vibrant, seed #22C55E, neutral #0F172A)

// MARK: - Adaptive Color Helper

extension Color {
    /// Creates an adaptive `Color` that resolves to `light` in light mode and `dark` in dark mode.
    init(light: UInt, dark: UInt) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(
                    red: CGFloat((dark >> 16) & 0xFF) / 255.0,
                    green: CGFloat((dark >> 8) & 0xFF) / 255.0,
                    blue: CGFloat(dark & 0xFF) / 255.0,
                    alpha: 1.0
                )
                : UIColor(
                    red: CGFloat((light >> 16) & 0xFF) / 255.0,
                    green: CGFloat((light >> 8) & 0xFF) / 255.0,
                    blue: CGFloat(light & 0xFF) / 255.0,
                    alpha: 1.0
                )
        })
    }

    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

// MARK: - Adaptive UIColor Helper

extension UIColor {
    /// Creates an adaptive `UIColor` that resolves to `light` hex in light mode and `dark` hex in dark mode.
    static func adaptive(light: UInt, dark: UInt) -> UIColor {
        UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255.0,
                green: CGFloat((hex >> 8) & 0xFF) / 255.0,
                blue: CGFloat(hex & 0xFF) / 255.0,
                alpha: 1.0
            )
        }
    }
}

// MARK: - Design System Namespace

enum DS {

    // MARK: - Primary
    //   Light: #006E2F    Dark: #6BFF8F
    static let primary = Color(light: 0x006E2F, dark: 0x6BFF8F)
    //   Light: #FFFFFF    Dark: #005F28
    static let onPrimary = Color(light: 0xFFFFFF, dark: 0x005F28)
    //   Light: #22C55E    Dark: #0ABC56
    static let primaryContainer = Color(light: 0x22C55E, dark: 0x0ABC56)
    //   Light: #004B1E    Dark: #002C0F
    static let onPrimaryContainer = Color(light: 0x004B1E, dark: 0x002C0F)

    // MARK: - Secondary
    //   Light: #2F6A3C    Dark: #7AFBB7
    static let secondary = Color(light: 0x2F6A3C, dark: 0x7AFBB7)
    //   Light: #FFFFFF    Dark: #005E3A
    static let onSecondary = Color(light: 0xFFFFFF, dark: 0x005E3A)
    //   Light: #AFEFB4    Dark: #006D44
    static let secondaryContainer = Color(light: 0xAFEFB4, dark: 0x006D44)
    //   Light: #346E40    Dark: #E1FFE9
    static let onSecondaryContainer = Color(light: 0x346E40, dark: 0xE1FFE9)

    // MARK: - Tertiary
    //   Light: #9E4036    Dark: #7DE9FF
    static let tertiary = Color(light: 0x9E4036, dark: 0x7DE9FF)
    //   Light: #FFFFFF    Dark: #005561
    static let onTertiary = Color(light: 0xFFFFFF, dark: 0x005561)
    //   Light: #FF8B7C    Dark: #00E0FD
    static let tertiaryContainer = Color(light: 0xFF8B7C, dark: 0x00E0FD)
    //   Light: #76231B    Dark: #004B56
    static let onTertiaryContainer = Color(light: 0x76231B, dark: 0x004B56)

    // MARK: - Error
    //   Light: #BA1A1A    Dark: #FF7351
    static let error = Color(light: 0xBA1A1A, dark: 0xFF7351)
    //   Light: #FFDAD6    Dark: #B92902
    static let errorContainer = Color(light: 0xFFDAD6, dark: 0xB92902)

    // MARK: - Surface / Background
    //   Light: #F8F9FA    Dark: #060E20
    static let surface = Color(light: 0xF8F9FA, dark: 0x060E20)
    //   Light: #F8F9FA    Dark: #1F2B49
    static let surfaceBright = Color(light: 0xF8F9FA, dark: 0x1F2B49)
    //   Light: #EDEEEF    Dark: #0F1930
    static let surfaceContainer = Color(light: 0xEDEEEF, dark: 0x0F1930)
    //   Light: #E7E8E9    Dark: #141F38
    static let surfaceContainerHigh = Color(light: 0xE7E8E9, dark: 0x141F38)
    //   Light: #E1E3E4    Dark: #192540
    static let surfaceContainerHighest = Color(light: 0xE1E3E4, dark: 0x192540)
    //   Light: #F3F4F5    Dark: #091328
    static let surfaceContainerLow = Color(light: 0xF3F4F5, dark: 0x091328)
    //   Light: #FFFFFF    Dark: #000000
    static let surfaceContainerLowest = Color(light: 0xFFFFFF, dark: 0x000000)
    //   Light: #D9DADB    Dark: #060E20
    static let surfaceDim = Color(light: 0xD9DADB, dark: 0x060E20)
    //   Light: #E1E3E4    Dark: #192540
    static let surfaceVariant = Color(light: 0xE1E3E4, dark: 0x192540)

    // MARK: - On Surface
    //   Light: #191C1D    Dark: #DEE5FF
    static let onSurface = Color(light: 0x191C1D, dark: 0xDEE5FF)
    //   Light: #3D4A3D    Dark: #A3AAC4
    static let onSurfaceVariant = Color(light: 0x3D4A3D, dark: 0xA3AAC4)

    // MARK: - Outline
    //   Light: #6D7B6C    Dark: #6D758C
    static let outline = Color(light: 0x6D7B6C, dark: 0x6D758C)
    //   Light: #BCCBB9    Dark: #40485D
    static let outlineVariant = Color(light: 0xBCCBB9, dark: 0x40485D)

    // MARK: - Inverse
    //   Light: #2E3132    Dark: #FAF8FF
    static let inverseSurface = Color(light: 0x2E3132, dark: 0xFAF8FF)
    //   Light: #F0F1F2    Dark: #4D556B
    static let inverseOnSurface = Color(light: 0xF0F1F2, dark: 0x4D556B)
    //   Light: #4AE176    Dark: #006E2F
    static let inversePrimary = Color(light: 0x4AE176, dark: 0x006E2F)

    // MARK: - Zinc palette (subdued text — adaptive)
    //   Light: #A1A1AA    Dark: #6D758C (maps to dark outline)
    static let zinc400 = Color(light: 0xA1A1AA, dark: 0x6D758C)
    //   Light: #71717A    Dark: #A3AAC4 (maps to dark on-surface-variant)
    static let zinc500 = Color(light: 0x71717A, dark: 0xA3AAC4)
    //   Light: #52525B    Dark: #DEE5FF (maps to dark on-surface for readability)
    static let zinc600 = Color(light: 0x52525B, dark: 0xDEE5FF)

    // MARK: - Shadow

    /// Adaptive shadow color: subtle in light mode, deeper in dark mode.
    static let shadowColor = Color(light: 0x000000, dark: 0x000000)

    /// Light-mode shadow opacity for standard elevation.
    static let shadowOpacitySM: Double = 0.04
    /// Dark-mode shadow opacity for standard elevation (stronger to register on dark surfaces).
    static let shadowOpacityMD: Double = 0.20

    /// Returns an adaptive shadow color at the standard small elevation opacity.
    static var adaptiveShadowSM: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.black.withAlphaComponent(0.20)
                : UIColor.black.withAlphaComponent(0.04)
        })
    }

    /// Returns an adaptive shadow color at medium elevation opacity.
    static var adaptiveShadowMD: Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.black.withAlphaComponent(0.30)
                : UIColor.black.withAlphaComponent(0.06)
        })
    }

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 16
    static let spacingXL: CGFloat = 20
    static let spacing2XL: CGFloat = 24
    static let spacing3XL: CGFloat = 32

    // MARK: - Corner Radius
    static let radiusSM: CGFloat = 4
    static let radiusMD: CGFloat = 8
    static let radiusLG: CGFloat = 12
    static let radiusXL: CGFloat = 16
    static let radius2XL: CGFloat = 24
    static let radius3XL: CGFloat = 28
    static let radiusFull: CGFloat = 9999

    // MARK: - Shadows

    static func shadowSM(_ color: Color = DS.adaptiveShadowSM) -> some View {
        Color.clear
            .shadow(color: color, radius: 4, x: 0, y: 2)
    }

    // MARK: - Gradient

    static let primaryGradient = LinearGradient(
        colors: [primary, primaryContainer],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Card Style Modifier

struct DSCard: ViewModifier {
    var padding: CGFloat = DS.spacingXL
    var radius: CGFloat = DS.radiusMD

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(DS.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(DS.surfaceContainer, lineWidth: 1)
            )
    }
}

extension View {
    func dsCard(padding: CGFloat = DS.spacingXL, radius: CGFloat = DS.radiusMD) -> some View {
        modifier(DSCard(padding: padding, radius: radius))
    }
}
