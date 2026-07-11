import SwiftUI

/// Maps the prototype's inline SVG icons to their closest SF Symbol equivalents.
/// The prototype ships one-off bezier paths for each glyph; recreating every path by hand
/// wouldn't read any more faithfully than the system's line-icon set at these sizes (11-26pt),
/// so icons are ported semantically rather than path-for-path.
enum ZIcon {
    static func name(for icon: FolderIcon) -> String {
        switch icon {
        case .general: return "bell"
        case .bloodwork: return "drop"
        case .cardiology: return "heart"
        case .dermatology: return "plus.circle"
        case .mentalHealth: return "brain.head.profile"
        case .dental: return "mouth"
        }
    }

    static func name(for icon: WearableIcon) -> String {
        switch icon {
        case .apple: return "applelogo"
        case .fitbit: return "circle.circle"
        case .googleFit: return "plus"
        case .garmin: return "waveform.path.ecg"
        case .flo: return "drop.fill"
        }
    }

    static func name(for icon: CarouselIcon) -> String {
        switch icon {
        case .folder: return "folder"
        case .clock: return "clock"
        case .pin: return "mappin.and.ellipse"
        case .star: return "star.fill"
        }
    }
}

/// Circular icon tile used for folders and wearable rows.
struct IconTile: View {
    var systemName: String
    var background: Color
    var foreground: Color = Color(hex: "#3a3a3a")
    var size: CGFloat = 42
    var iconSize: CGFloat = 18
    var corner: CGFloat = 12

    var body: some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(background)
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundStyle(foreground)
            )
    }
}

/// Segmented ring gauge used on the Home tab ("Screenings Completed").
struct ScreeningsRing: View {
    var progress: Double // 0...1
    var lineWidth: CGFloat = 14
    var diameter: CGFloat = 180

    var body: some View {
        ZStack {
            Circle()
                .stroke(ZColor.ringTrack, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, progress))
                .stroke(
                    AngularGradient(
                        colors: [ZColor.teal, ZColor.blue, ZColor.purple],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: diameter, height: diameter)
    }
}
