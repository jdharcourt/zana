import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                TabHeader()
                    .padding(.bottom, 16)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Manage your screenings")
                            .font(.z(14.5, .bold))
                            .foregroundStyle(ZColor.ink)
                        Text("Never miss a screening reminder.\nSet a reminder to stay on track.")
                            .font(.z(12.5))
                            .foregroundStyle(ZColor.textSecondary)
                            .lineSpacing(2)
                    }
                    Spacer()
                    Circle()
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .overlay(Image(systemName: "bell").font(.system(size: 18)).foregroundStyle(ZColor.ink))
                }
                .padding(16)
                .background(LinearGradient(colors: [ZColor.heroGradientStart, ZColor.heroGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.bottom, 20)

                VStack(spacing: 0) {
                    ScreeningsRing(progress: 0.25)
                    VStack(spacing: 2) {
                        Text("1/4")
                            .font(.zSerif(30))
                            .foregroundStyle(ZColor.ink)
                        Text("Screenings Completed")
                            .font(.z(12.5, .semibold))
                            .foregroundStyle(ZColor.textSecondary)
                    }
                    .padding(.top, -38)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 22)

                HStack(spacing: 0) {
                    statTile(value: "1", label: "Up to date")
                    Divider().frame(height: 40)
                    statTile(value: "1", label: "Overdue")
                    Divider().frame(height: 40)
                    statTile(value: "\(state.recordsCount)", label: "Records")
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.bottom, 16)

                Button { state.goToTab(.screenings) } label: {
                    HStack {
                        Text("See More")
                            .font(.z(14, .semibold))
                            .foregroundStyle(ZColor.ink)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(ZColor.textTertiary)
                    }
                    .padding(15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 6)
            .padding(.bottom, 30)
        }
    }

    private func statTile(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.z(20, .bold)).foregroundStyle(ZColor.ink)
            Text(label).font(.z(11.5)).foregroundStyle(ZColor.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}
