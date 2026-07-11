import SwiftUI

struct FoldersTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                TabHeader()
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    ForEach(AppData.folderDefs) { folder in
                        Button {
                            state.openFolder(folder.id)
                        } label: {
                            HStack(spacing: 14) {
                                IconTile(systemName: ZIcon.name(for: folder.icon), background: folder.iconBg, size: 42, iconSize: 19)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(folder.name)
                                        .font(.zSerif(18))
                                        .foregroundStyle(ZColor.ink)
                                    Text(docCountLabel(for: folder))
                                        .font(.z(12))
                                        .foregroundStyle(ZColor.textTertiary)
                                }

                                Spacer()

                                Circle()
                                    .strokeBorder(ZColor.divider, lineWidth: 1)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(ZColor.ink)
                                    )
                            }
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 6)
            .padding(.bottom, 30)
        }
    }

    private func docCountLabel(for folder: FolderDef) -> String {
        let count = state.docCount(for: folder)
        return "\(count) document\(count == 1 ? "" : "s")"
    }
}
