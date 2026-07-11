import SwiftUI

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        s = s.replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)
        let r, g, b, a: Double
        switch s.count {
        case 6:
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
            a = 1
        case 8:
            r = Double((value >> 24) & 0xFF) / 255
            g = Double((value >> 16) & 0xFF) / 255
            b = Double((value >> 8) & 0xFF) / 255
            a = Double(value & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

enum ZColor {
    // Surfaces
    static let modalBg = Color(hex: "#EFE9E1")
    static let appBg = Color(hex: "#F1ECE3")
    static let card = Color.white
    static let scrim = Color.black.opacity(0.4)

    // Text
    static let ink = Color(hex: "#171717")
    static let textSecondary = Color(hex: "#6b6b6b")
    static let textTertiary = Color(hex: "#8a8a8a")
    static let textMuted = Color(hex: "#9a9a9a")
    static let chevron = Color(hex: "#c4bda9")

    // Borders / dividers
    static let inputBorder = Color(hex: "#d8d2c8")
    static let divider = Color(hex: "#ddd6c9")
    static let rowDivider = Color(hex: "#eee7db")
    static let disabled = Color(hex: "#c9c2b4")

    // Brand
    static let teal = Color(hex: "#1B7A72")
    static let blue = Color(hex: "#3D5A99")
    static let blueDeep = Color(hex: "#2F5F8F")
    static let purple = Color(hex: "#6B4A8F")
    static let indigo = Color(hex: "#463A78")

    // Status
    static let successBg = Color(hex: "#d7f0e0")
    static let successText = Color(hex: "#1c6b41")
    static let warningBg = Color(hex: "#faf0d0")
    static let warningText = Color(hex: "#8a6d1c")
    static let overdueAccent = Color(hex: "#B5453F")
    static let overdueBg = Color(hex: "#F5E6E4")
    static let scheduledAccent = Color(hex: "#3E9C6E")
    static let scheduledBg = Color(hex: "#E9F5EE")
    static let upcomingAccent = Color(hex: "#B08A2E")
    static let upcomingBg = Color(hex: "#F5EFDF")

    // Home
    static let heroGradientStart = Color(hex: "#DCEBE8")
    static let heroGradientEnd = Color(hex: "#DEE4F2")
    static let ringTrack = Color(hex: "#E5DFD3")
    static let trackFill = Color(hex: "#eee7db")

    // Splash gradient
    static let splashGradient = LinearGradient(
        colors: [teal, blueDeep, indigo],
        startPoint: UnitPoint(x: 0.15, y: 0.0),
        endPoint: UnitPoint(x: 0.85, y: 1.0)
    )

    static let carouselGradient = LinearGradient(
        colors: [Color(hex: "#D9E6E4"), Color(hex: "#F4F1EA"), .white],
        startPoint: UnitPoint(x: 0.1, y: 0.0),
        endPoint: UnitPoint(x: 0.9, y: 1.0)
    )

    static let aiGradient = LinearGradient(
        colors: [teal, purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let aiButtonGradient = LinearGradient(
        colors: [blueDeep, purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let fabGradient = LinearGradient(
        colors: [teal, blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let uploadProgressGradient = LinearGradient(
        colors: [teal, purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    static func carouselSlideGradient(_ index: Int) -> LinearGradient {
        let pairs: [[String]] = [
            ["#CDE3DF", "#D6DEEE"],
            ["#B9D6D0", "#B9C6E3"],
            ["#9FC6BE", "#9FB0D9"],
            ["#6FA79A", "#6B7FC8"],
        ]
        let p = pairs[index % pairs.count]
        return LinearGradient(colors: [Color(hex: p[0]), Color(hex: p[1])], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

enum ZFontWeight {
    case regular, medium, semibold, bold
}

extension Font {
    /// DM Sans, the app's body/UI typeface.
    static func z(_ size: CGFloat, _ weight: ZFontWeight = .regular) -> Font {
        switch weight {
        case .regular: return .custom("DM Sans", size: size)
        case .medium: return .custom("DM Sans Medium", size: size)
        case .semibold: return .custom("DM Sans SemiBold", size: size)
        case .bold: return .custom("DM Sans", size: size).bold()
        }
    }

    /// Instrument Serif, the app's display typeface.
    static func zSerif(_ size: CGFloat, italic: Bool = false) -> Font {
        italic ? .custom("Instrument Serif", size: size).italic() : .custom("Instrument Serif", size: size)
    }
}

enum ZRadius {
    static let button: CGFloat = 12
    static let input: CGFloat = 10
    static let card: CGFloat = 14
    static let sheet: CGFloat = 28
    static let icon: CGFloat = 8
}
