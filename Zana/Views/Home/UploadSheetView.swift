import SwiftUI
import UniformTypeIdentifiers

struct UploadSheetView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { if !state.isUploading { state.closeUpload() } }

                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        ZCloseButton { state.closeUpload() }
                            .disabled(state.isUploading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 4)

                    ScrollView {
                        stepContent
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .padding(.bottom, 24)
                    }
                }
                .frame(height: proxy.size.height * 0.64)
                .background(ZColor.modalBg)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: state.uploadStep)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch state.uploadStep {
        case .pick: UploadPickStep()
        case .uploading: UploadUploadingStep()
        case .details: UploadDetailsStep()
        case .done: UploadDoneStep()
        case nil: EmptyView()
        }
    }
}

private struct UploadPickStep: View {
    @EnvironmentObject var state: AppState
    @State private var isImporterPresented = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 32))
                .foregroundStyle(ZColor.ink)

            Text("Upload a medical document")
                .font(.z(22, .bold))
                .foregroundStyle(ZColor.ink)

            Text("PDF, JPEG, or PNG · 10 MB maximum")
                .font(.z(13.5))
                .foregroundStyle(ZColor.textTertiary)

            if let error = state.uploadError {
                Text(error)
                    .font(.z(13))
                    .foregroundStyle(Color.red)
            }

            PrimaryButton(title: "Choose file") { isImporterPresented = true }
        }
        .frame(minHeight: 260)
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.pdf, .jpeg, .png],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                state.selectFile(url)
            case .failure:
                state.uploadError = "The file picker could not be opened."
            }
        }
    }
}

private struct UploadUploadingStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(ZColor.ink)
            Text("Uploading \(state.uploadFileName)")
                .font(.z(14, .semibold))
                .foregroundStyle(ZColor.ink)
                .multilineTextAlignment(.center)
            Text("Keep Zana open until the upload finishes.")
                .font(.z(13))
                .foregroundStyle(ZColor.textTertiary)
        }
        .frame(minHeight: 240)
        .frame(maxWidth: .infinity)
    }
}

private struct UploadDetailsStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Document details")
                .font(.z(22, .bold))
                .foregroundStyle(ZColor.ink)

            ZLabeledField(label: "File name", text: $state.uploadFileName)
            ZLabeledField(label: "Date", placeholder: "Jan 6, 2026", text: $state.uploadFileDate)

            VStack(alignment: .leading, spacing: 8) {
                Text("Folder")
                    .font(.z(12, .semibold))
                    .foregroundStyle(ZColor.textTertiary)

                Menu {
                    ForEach(AppData.folderDefs) { folder in
                        Button(folder.name) { state.uploadFolder = folder.id }
                    }
                } label: {
                    HStack {
                        Text(AppData.folderDefs.first { $0.id == state.uploadFolder }?.name ?? "General")
                            .font(.z(14))
                            .foregroundStyle(ZColor.ink)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundStyle(ZColor.textTertiary)
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(ZColor.inputBorder, lineWidth: 1)
                    )
                }
            }

            if let error = state.uploadError {
                Text(error)
                    .font(.z(13))
                    .foregroundStyle(Color.red)
            }

            PrimaryButton(
                title: "Upload document",
                background: state.uploadFileName.trimmed.isEmpty ? ZColor.disabled : ZColor.ink,
                isDisabled: state.uploadFileName.trimmed.isEmpty
            ) { state.uploadDocument() }
        }
    }
}

private struct UploadDoneStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 28))
                .foregroundStyle(ZColor.successText)

            Text("Document uploaded")
                .font(.z(22, .bold))
                .foregroundStyle(ZColor.ink)

            HStack(spacing: 12) {
                IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: ZColor.ink, size: 36, iconSize: 15, corner: 8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(state.uploadFileName)
                        .font(.z(13.5, .semibold))
                        .foregroundStyle(ZColor.ink)
                    Text(AppData.folderDefs.first { $0.id == state.uploadFolder }?.name ?? "General")
                        .font(.z(11))
                        .foregroundStyle(ZColor.textTertiary)
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            PrimaryButton(title: "Done") { state.finishUpload() }
        }
    }
}
