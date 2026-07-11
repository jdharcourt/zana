import SwiftUI

struct UploadSheetView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        GeometryReader { proxy in
            let topInset: CGFloat = state.uploadStep == .pick ? proxy.size.height * 0.38 : proxy.size.height * 0.24

            ZStack(alignment: .bottom) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { state.closeUpload() }

                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        ZCloseButton { state.closeUpload() }
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
                .frame(height: proxy.size.height - topInset)
                .background(ZColor.modalBg)
                .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: state.uploadStep)
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

    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(hex: "#e3ddd1"))
                .frame(width: 60, height: 60)
                .overlay(Image(systemName: "folder").font(.system(size: 24)).foregroundStyle(Color(hex: "#3a3a3a")))

            Text("Upload a result")
                .font(.zSerif(24))
                .foregroundStyle(ZColor.ink)

            Text("Add your document now. You can file it into a folder after.")
                .font(.z(13.5))
                .foregroundStyle(ZColor.textTertiary)
                .multilineTextAlignment(.center)
            Spacer()

            PrimaryButton(title: "Upload files +") { state.simulateUpload() }
        }
        .frame(minHeight: 260)
    }
}

private struct UploadUploadingStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("FILES NAME")
                .font(.z(11.5, .bold))
                .tracking(0.6)
                .foregroundStyle(ZColor.textTertiary)

            HStack(spacing: 12) {
                IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: Color(hex: "#3a3a3a"), size: 36, iconSize: 15, corner: 8)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bloodwork Panel Report")
                        .font(.z(13.5, .semibold))
                        .foregroundStyle(ZColor.ink)
                    Text("\(state.uploadProgressLabel) · Uploading")
                        .font(.z(11))
                        .foregroundStyle(ZColor.textTertiary)
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule().fill(ZColor.trackFill)
                            Capsule()
                                .fill(ZColor.uploadProgressGradient)
                                .frame(width: proxy.size.width * state.uploadProgress / 100)
                        }
                    }
                    .frame(height: 4)
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

private struct UploadDetailsStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZLabeledField(label: "Files name", text: $state.uploadFileName)
            ZLabeledField(label: "Date", placeholder: "Jan 6, 2026", text: $state.uploadFileDate)

            VStack(alignment: .leading, spacing: 8) {
                Text("CATEGORY / FOLDER")
                    .font(.z(11.5, .bold))
                    .tracking(0.6)
                    .foregroundStyle(ZColor.textTertiary)

                Menu {
                    ForEach(AppData.folderDefs) { folder in
                        Button(folder.name) { state.uploadFolder = folder.id }
                    }
                } label: {
                    HStack {
                        Text(AppData.folderDefs.first { $0.id == state.uploadFolder }?.name ?? "")
                            .font(.z(14))
                            .foregroundStyle(ZColor.ink)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundStyle(ZColor.textTertiary)
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(ZColor.inputBorder, lineWidth: 1)
                    )
                }
            }

            PrimaryButton(title: "Next →") { state.confirmUploadDetails() }
        }
    }
}

private struct UploadDoneStep: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(ZColor.successText)
                    Text("Document Uploaded")
                }
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
            }
            .font(.z(13, .semibold))
            .foregroundStyle(ZColor.successText)
            .padding(12)
            .background(ZColor.successBg)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text("FILES NAME")
                .font(.z(11.5, .bold))
                .tracking(0.6)
                .foregroundStyle(ZColor.textTertiary)

            HStack(spacing: 12) {
                IconTile(systemName: "doc.fill", background: ZColor.appBg, foreground: Color(hex: "#3a3a3a"), size: 36, iconSize: 15, corner: 8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(state.uploadFileName)
                        .font(.z(13.5, .semibold))
                        .foregroundStyle(ZColor.ink)
                    Text(AppData.folderDefs.first { $0.id == state.uploadFolder }?.name ?? "")
                        .font(.z(11))
                        .foregroundStyle(ZColor.textTertiary)
                }
                Spacer()
                Button { state.openAiSummary() } label: {
                    Circle()
                        .fill(ZColor.aiGradient)
                        .frame(width: 32, height: 32)
                        .overlay(Image(systemName: "sparkles").font(.system(size: 13)).foregroundStyle(.white))
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            PrimaryButton(title: "Done") { state.finishUpload() }
        }
    }
}
