import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    // Navigation
    @Published var step: AppStep = .splash
    @Published var carouselIndex: Int = 0
    @Published var activeTab: AppTab = .home

    // Signup
    @Published var email: String = ""
    @Published var code: String = ""
    @Published var firstName: String
    @Published var lastName: String = ""
    @Published var birthDate: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""

    // Onboarding answers
    @Published var conditions: Set<String> = []
    @Published var screeningAnswers: [String: String] = [:]
    @Published var agreedPrivacy: Bool = false
    @Published var wearableChoice: String?

    // Folders
    @Published var openFolderId: String?

    // Upload flow
    @Published var uploadStep: UploadStep?
    @Published var uploadFileName: String = "Bloodwork Panel Report"
    @Published var uploadFileDate: String = "Mar 12, 2026"
    @Published var uploadFolder: String = "general"
    @Published var uploadProgress: Double = 0

    // Overlays
    @Published var aiSummaryOpen: Bool = false
    @Published var screeningDetailId: String?

    init(patientName: String = "", startAtHome: Bool = false) {
        self.firstName = patientName
        self.step = startAtHome ? .home : .splash
    }

    // MARK: - Derived

    var ageLabel: String { birthDate.isEmpty ? "30 yo" : "" }

    var hasUploadedDoc: Bool {
        guard let openFolderId, openFolderId == uploadFolder, uploadStep == nil else { return false }
        return !uploadFileName.isEmpty
    }

    var activeFolder: FolderDef? {
        AppData.folderDefs.first { $0.id == openFolderId }
    }

    var activeFolderDocs: [UploadedDoc] {
        hasUploadedDoc ? [UploadedDoc(name: uploadFileName, date: uploadFileDate)] : []
    }

    func docCount(for folder: FolderDef) -> Int {
        (folder.id == uploadFolder && openFolderId == folder.id) ? 1 : 0
    }

    var screeningsByGroup: [(ScreeningGroup, [ScreeningItemDef])] {
        ScreeningGroup.allCases.map { group in
            (group, AppData.screeningItemDefs.values.filter { $0.group == group }.sorted { $0.name < $1.name })
        }
    }

    var activeScreeningDetail: ScreeningItemDef? {
        guard let screeningDetailId else { return nil }
        return AppData.screeningItemDefs[screeningDetailId]
    }

    var recordsCount: Int { hasUploadedDoc ? 1 : 0 }

    // MARK: - Onboarding navigation

    func goToCarousel() { step = .carousel }

    func carouselContinue() {
        if carouselIndex >= 3 {
            step = .signupEmail
        } else {
            carouselIndex += 1
        }
    }

    func submitEmail() { guard !email.trimmed.isEmpty else { return }; step = .verifyCode }
    func submitCode() { guard !code.trimmed.isEmpty else { return }; step = .profileName }
    func submitName() { guard !firstName.trimmed.isEmpty else { return }; step = .profileDetails }
    func submitDetails() { guard !birthDate.trimmed.isEmpty else { return }; step = .privacy }
    func toggleAgreePrivacy() { agreedPrivacy.toggle() }
    func submitPrivacy() { guard agreedPrivacy else { return }; step = .conditions }
    func submitConditions() { step = .screeningsCheck }
    func submitScreeningsCheck() { step = .wearableOffer }
    func goToWearableConnect() { step = .wearableConnect }
    func finishOnboarding() { step = .home }
    func closeModal() { step = .home }

    func toggleCondition(_ name: String) {
        if conditions.contains(name) { conditions.remove(name) } else { conditions.insert(name) }
    }

    func setScreeningAnswer(_ question: String, _ answer: String) {
        screeningAnswers[question] = answer
    }

    func selectWearable(_ id: String) { wearableChoice = id }

    // MARK: - Tabs

    func goToTab(_ tab: AppTab) { activeTab = tab }

    // MARK: - Folders

    func openFolder(_ id: String) { openFolderId = id }
    func closeFolderDetail() { openFolderId = nil }

    // MARK: - Upload

    func openUploadSheet() { uploadStep = .pick }
    func closeUpload() { uploadStep = nil; uploadProgress = 0 }

    func simulateUpload() {
        uploadStep = .uploading
        uploadProgress = 0
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.22, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self else { timer.invalidate(); return }
                count += 1
                self.uploadProgress = min(100, self.uploadProgress + 20)
                if count >= 5 {
                    timer.invalidate()
                    self.uploadStep = .details
                }
            }
        }
    }

    func confirmUploadDetails() { uploadStep = .done }
    func finishUpload() {
        openFolderId = uploadFolder
        uploadStep = nil
        uploadProgress = 0
    }

    var uploadProgressLabel: String {
        "\(Int(uploadProgress * 1.2))KB of 120KB"
    }

    // MARK: - Overlays

    func openAiSummary() { aiSummaryOpen = true }
    func closeAiSummary() { aiSummaryOpen = false }

    func openScreeningDetail(_ id: String) { screeningDetailId = id }
    func closeScreeningDetail() { screeningDetailId = nil }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
