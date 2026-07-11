import SwiftUI

struct ScreeningsCheckStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Screenings check")
                .font(.zSerif(27))
                .foregroundStyle(ZColor.ink)
                .padding(.vertical, 8)

            Text("Based on your age and health profile, these screenings are relevant to you. When was your last...")
                .font(.z(13.5))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 18)

            VStack(spacing: 0) {
                ForEach(AppData.screeningDefs, id: \.self) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.z(14.5, .semibold))
                            .foregroundStyle(ZColor.ink)

                        FlowChips(
                            options: AppData.chipLabels,
                            selected: state.screeningAnswers[question]
                        ) { chip in
                            state.setScreeningAnswer(question, chip)
                        }
                    }
                    .padding(.vertical, 12)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(ZColor.divider).frame(height: 1)
                    }
                }
            }
            .padding(.bottom, 16)

            PrimaryButton(title: "Next →") { state.submitScreeningsCheck() }
        }
    }
}

/// Wrapping row of selectable pill chips (screening-recency answers).
struct FlowChips: View {
    let options: [String]
    let selected: String?
    let onSelect: (String) -> Void

    var body: some View {
        FlowLayout(spacing: 6) {
            ForEach(options, id: \.self) { option in
                Button { onSelect(option) } label: {
                    Text(option)
                        .font(.z(11.5, .medium))
                        .foregroundStyle(selected == option ? .white : ZColor.ink)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(selected == option ? ZColor.ink : Color.white)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

/// Simple wrapping flow layout for chip rows.
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX, y: CGFloat = bounds.minY, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
