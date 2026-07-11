import SwiftUI

struct FolderDetailView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.openURL) private var openURL
    @State private var openingDocumentId: UUID?
    @State private var viewError: String?

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
                        ForEach(state.activeFolderDocs) { document in
                            Button {
                                openingDocumentId = document.id
                                viewError = nil
                                Task {
                                    do {
                                        openURL(try await state.documentURL(for: document))
                                    } catch {
                                        viewError = "The document could not be opened."
                                    }
                                    openingDocumentId = nil
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: ZColor.ink, size: 38, iconSize: 16, corner: 8)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(document.name)
                                            .font(.z(13.5, .semibold))
                                            .foregroundStyle(ZColor.ink)
                                        Text(document.date)
                                            .font(.z(11.5))
                                            .foregroundStyle(ZColor.textTertiary)
                                    }
                                    Spacer()
                                    if openingDocumentId == document.id {
                                        ProgressView().tint(ZColor.ink)
                                    } else {
                                        Image(systemName: "arrow.up.right.square")
                                            .foregroundStyle(ZColor.textTertiary)
                                    }
                                }
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }

                        if let viewError {
                            Text(viewError)
                                .font(.z(13))
                                .foregroundStyle(Color.red)
                        }
                    }
                    .padding(.horizontal, 22)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "folder")
                            .font(.system(size: 44))
                            .foregroundStyle(ZColor.disabled)
                        Text("No files yet")
                            .font(.z(22, .bold))
                            .foregroundStyle(ZColor.ink)
                        Text("Upload your first medical document.")
                            .font(.z(13.5))
                            .foregroundStyle(ZColor.textTertiary)
                    }
                    .padding(.vertical, 70)
                    .frame(maxWidth: .infinity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Upload file") { state.openUploadSheet() }
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
