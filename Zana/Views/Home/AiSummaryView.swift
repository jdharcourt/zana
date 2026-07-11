import SwiftUI

struct AiSummaryView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { state.closeAiSummary() }

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    ZCloseButton { state.closeAiSummary() }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 4)

                ScrollView {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(ZColor.aiGradient)
                            .frame(width: 56, height: 56)
                            .overlay(Image(systemName: "sparkles").font(.system(size: 22)).foregroundStyle(.white))
                            .padding(.top, 6)

                        Text("Hi \(state.firstName)! Keep in mind that these are answers generated from the information I have and I might make mistakes. Consider consulting a doctor.")
                            .font(.z(13))
                            .foregroundStyle(ZColor.textTertiary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        HStack(spacing: 12) {
                            IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: Color(hex: "#3a3a3a"), size: 36, iconSize: 15, corner: 8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Bloodwork Panel Report")
                                    .font(.z(13.5, .semibold))
                                    .foregroundStyle(ZColor.ink)
                                Text("Dr. Murphy · Mar 2026")
                                    .font(.z(11.5))
                                    .foregroundStyle(ZColor.textTertiary)
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("WHAT THIS MEANS")
                                .font(.z(11.5, .bold))
                                .tracking(0.6)
                                .foregroundStyle(Color(hex: "#2b6b63"))
                            Text("Your cholesterol and glucose levels are close to ideal ranges. One value, LDL cholesterol, is slightly above target — this is common and usually managed with diet and activity, not medication.")
                                .font(.z(13.5))
                                .foregroundStyle(Color(hex: "#243b37"))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(ZColor.heroGradientStart)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        VStack(alignment: .leading, spacing: 10) {
                            Text("KEY VALUES")
                                .font(.z(11.5, .bold))
                                .tracking(0.6)
                                .foregroundStyle(ZColor.textTertiary)

                            keyValueRow("Total cholesterol", badge: "Normal ✓", bg: ZColor.successBg, color: ZColor.successText)
                            keyValueRow("LDL cholesterol", badge: "Slightly high ⚠", bg: ZColor.warningBg, color: ZColor.warningText)
                            keyValueRow("Fasting glucose", badge: "Normal ✓", bg: ZColor.successBg, color: ZColor.successText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        HStack(spacing: 8) {
                            Circle()
                                .fill(ZColor.aiGradient)
                                .frame(width: 22, height: 22)
                                .overlay(Image(systemName: "sparkles").font(.system(size: 10)).foregroundStyle(.white))
                            Text("Zana AI")
                                .font(.z(13, .semibold))
                                .foregroundStyle(ZColor.ink)
                        }

                        PrimaryButton(title: "Book / find a clinic", gradient: ZColor.aiButtonGradient) {}
                        PrimaryButton(title: "Set a screening reminder") { state.closeAiSummary() }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .frame(maxHeight: .infinity)
            .background(ZColor.modalBg)
            .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
            .padding(.top, 56)
        }
    }

    private func keyValueRow(_ label: String, badge: String, bg: Color, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.z(13.5))
                .foregroundStyle(ZColor.ink)
            Spacer()
            Text(badge)
                .font(.z(11, .semibold))
                .foregroundStyle(color)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(bg)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding(.vertical, 6)
    }
}
