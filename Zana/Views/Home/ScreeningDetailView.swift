import SwiftUI

struct ScreeningDetailView: View {
    @EnvironmentObject var state: AppState

    var detail: ScreeningItemDef? { state.activeScreeningDetail }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { state.closeScreeningDetail() }

            VStack(spacing: 0) {
                ZStack {
                    Text("Screening")
                        .font(.z(15, .bold))
                        .foregroundStyle(ZColor.ink)
                    HStack {
                        Spacer()
                        ZCloseButton { state.closeScreeningDetail() }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)

                if let detail {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(detail.status)
                                        .font(.z(11, .semibold))
                                        .foregroundStyle(detail.accent)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 4)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    Spacer()
                                    Text(detail.meta)
                                        .font(.z(11.5))
                                        .foregroundStyle(ZColor.textTertiary)
                                }
                                Text(detail.name)
                                    .font(.zSerif(22))
                                    .foregroundStyle(ZColor.ink)
                            }
                            .padding(16)
                            .background(detail.bg)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2).fill(detail.accent).frame(width: 4)
                            }

                            HStack(spacing: 10) {
                                Button {} label: {
                                    Text("Find a clinic")
                                        .font(.z(13, .semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 13)
                                }
                                .background(ZColor.ink)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                                OutlineButton(title: "Mark as booked") {}
                            }

                            Text("PAST RESULTS")
                                .font(.z(11.5, .bold))
                                .tracking(0.6)
                                .foregroundStyle(ZColor.textTertiary)

                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(detail.history.enumerated()), id: \.element.id) { index, entry in
                                    HStack(alignment: .top, spacing: 12) {
                                        VStack(spacing: 4) {
                                            Circle()
                                                .fill(ZColor.ink)
                                                .frame(width: 22, height: 22)
                                                .overlay(Image(systemName: "checkmark").font(.system(size: 9, weight: .bold)).foregroundStyle(.white))
                                            if index < detail.history.count - 1 {
                                                Rectangle().fill(ZColor.divider).frame(width: 1.5).frame(maxHeight: .infinity)
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(entry.date)
                                                    .font(.z(11.5))
                                                    .foregroundStyle(ZColor.textTertiary)
                                                Spacer()
                                                Text(entry.badge)
                                                    .font(.z(10.5, .semibold))
                                                    .foregroundStyle(entry.badgeColor)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 3)
                                                    .background(entry.badgeBg)
                                                    .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                                            }
                                            Text(entry.title)
                                                .font(.z(13.5, .bold))
                                                .foregroundStyle(ZColor.ink)
                                            Text(entry.detail)
                                                .font(.z(12))
                                                .foregroundStyle(ZColor.textTertiary)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }
                                    .padding(.bottom, 16)
                                }
                            }

                            Text("Add a result +")
                                .font(.z(13.5, .semibold))
                                .foregroundStyle(ZColor.ink)
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 24)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(ZColor.modalBg)
            .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
            .padding(.top, 56)
        }
    }
}
