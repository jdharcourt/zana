import SwiftUI

/// Full-width solid button matching the prototype's `.btn` style: 12pt radius, 15pt vertical padding.
struct PrimaryButton: View {
    let title: String
    var background: Color = ZColor.ink
    var foreground: Color = .white
    var gradient: LinearGradient? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.z(15, .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .foregroundStyle(foreground)
        .background {
            if let gradient {
                gradient
            } else {
                background
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: ZRadius.button, style: .continuous))
        .disabled(isDisabled)
    }
}

/// Outlined button matching `border:1px solid #171717` buttons.
struct OutlineButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.z(13, .semibold))
                .foregroundStyle(ZColor.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
        }
        .overlay(
            RoundedRectangle(cornerRadius: ZRadius.button, style: .continuous)
                .stroke(ZColor.ink, lineWidth: 1)
        )
    }
}

/// Labeled text field matching the prototype's uppercase micro-label + boxed input.
struct ZLabeledField: View {
    let label: String
    var placeholder: String = "Placeholder"
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.z(11.5, .semibold))
                .tracking(0.5)
                .foregroundStyle(ZColor.textTertiary)
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(ZColor.ink.opacity(0.65)))
                .font(.z(15))
                .foregroundStyle(ZColor.ink)
                .tint(ZColor.ink)
                .keyboardType(keyboardType)
                .padding(15)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: ZRadius.input, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: ZRadius.input, style: .continuous)
                        .stroke(ZColor.inputBorder, lineWidth: 1)
                )
        }
    }
}

struct ZSecureField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.z(11.5, .semibold))
                .tracking(0.5)
                .foregroundStyle(ZColor.textTertiary)
            SecureField("", text: $text, prompt: Text("At least 8 characters").foregroundStyle(ZColor.ink.opacity(0.65)))
                .font(.z(15))
                .foregroundStyle(ZColor.ink)
                .tint(ZColor.ink)
                .textContentType(.password)
                .padding(15)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: ZRadius.input, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: ZRadius.input, style: .continuous)
                        .stroke(ZColor.inputBorder, lineWidth: 1)
                )
        }
    }
}

/// Row of progress dots shown in the onboarding modal header.
struct ProgressDots: View {
    let total: Int
    let filledUpTo: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<total, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i <= filledUpTo ? ZColor.ink : ZColor.divider)
                    .frame(height: 4)
            }
        }
    }
}

/// Small square checkbox used in privacy consent and condition rows.
struct ZCheckbox: View {
    let checked: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(checked ? ZColor.ink : Color.clear)
            .frame(width: 18, height: 18)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(ZColor.ink, lineWidth: 1.5)
            )
            .overlay {
                if checked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
    }
}

/// Close (X) button used across sheets.
struct ZCloseButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ZColor.ink)
                .frame(width: 28, height: 28)
        }
    }
}

/// Back chevron button used in folder detail / screening detail headers.
struct ZBackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ZColor.ink)
                .frame(width: 28, height: 28)
        }
    }
}
