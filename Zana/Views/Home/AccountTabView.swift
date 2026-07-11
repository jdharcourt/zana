import SwiftUI

struct AccountTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(state.firstName) \(state.lastName)")
                    .font(.zSerif(30))
                    .foregroundStyle(ZColor.ink)
                    .padding(.bottom, 4)

                Text(state.email)
                    .font(.z(13))
                    .foregroundStyle(ZColor.textTertiary)
                    .padding(.bottom, 24)

                VStack(spacing: 0) {
                    ForEach(Array(AppData.accountRows.enumerated()), id: \.offset) { index, label in
                        HStack {
                            Text(label)
                                .font(.z(14.5))
                                .foregroundStyle(ZColor.ink)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(ZColor.chevron)
                        }
                        .padding(16)
                        .overlay(alignment: .bottom) {
                            if index < AppData.accountRows.count - 1 {
                                Rectangle().fill(ZColor.rowDivider).frame(height: 1)
                            }
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 22)
            .padding(.top, 6)
            .padding(.bottom, 30)
        }
    }
}
