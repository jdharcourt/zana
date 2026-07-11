import SwiftUI

struct ScreeningsTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                TabHeader()
                    .padding(.bottom, 20)

                ForEach(state.screeningsByGroup, id: \.0) { group, items in
                    if !items.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(group.rawValue)
                                .font(.z(11.5, .bold))
                                .tracking(0.6)
                                .foregroundStyle(ZColor.textTertiary)

                            ForEach(items) { item in
                                Button {
                                    state.openScreeningDetail(item.id)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name)
                                                .font(.z(14.5, .bold))
                                                .foregroundStyle(ZColor.ink)
                                            Text(item.meta)
                                                .font(.z(12))
                                                .foregroundStyle(ZColor.textTertiary)
                                        }
                                        Spacer()
                                        Text(item.btnLabel)
                                            .font(.z(12, .semibold))
                                            .foregroundStyle(item.btnFilled ? .white : ZColor.ink)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(item.btnFilled ? ZColor.ink : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    }
                                    .padding(14)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(item.accent)
                                            .frame(width: 4)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 18)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 6)
            .padding(.bottom, 30)
        }
    }
}
