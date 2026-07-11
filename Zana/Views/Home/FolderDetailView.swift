import SwiftUI

struct FolderDetailView: View {
    @EnvironmentObject var state: AppState

    var folder: FolderDef? { state.activeFolder }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZBackButton { state.closeFolderDetail() }
                Text(folder?.name ?? "")
                    .font(.z(16, .bold))
                    .foregroundStyle(ZColor.ink)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 18)

            ScrollView {
                if state.hasUploadedDoc {
                    VStack(spacing: 12) {
                        ForEach(state.activeFolderDocs, id: \.name) { doc in
                            HStack(spacing: 12) {
                                IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: Color(hex: "#3a3a3a"), size: 38, iconSize: 16, corner: 8)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(doc.name)
                                        .font(.z(13.5, .semibold))
                                        .foregroundStyle(ZColor.ink)
                                    Text(doc.date)
                                        .font(.z(11.5))
                                        .foregroundStyle(ZColor.textTertiary)
                                }
                                Spacer()
                                Button { state.openAiSummary() } label: {
                                    Circle()
                                        .fill(ZColor.aiGradient)
                                        .frame(width: 34, height: 34)
                                        .overlay(Image(systemName: "sparkles").font(.system(size: 14)).foregroundStyle(.white))
                                }
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 22)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "folder")
                            .font(.system(size: 44))
                            .foregroundStyle(ZColor.disabled)
                        Text("No files yet")
                            .font(.zSerif(24))
                            .foregroundStyle(ZColor.ink)
                        Text("No results yet. Add your first one.")
                            .font(.z(13.5))
                            .foregroundStyle(ZColor.textTertiary)
                    }
                    .padding(.vertical, 70)
                    .frame(maxWidth: .infinity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Upload files +") { state.openUploadSheet() }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 24)
                    .padding(.top, 6)
            }
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ZColor.appBg.ignoresSafeArea())
    }
}
