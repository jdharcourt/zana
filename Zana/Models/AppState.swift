import Combine
import Foundation
import Supabase
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var step: AppStep = .splash
    @Published var carouselIndex = 0
    @Published var activeTab: AppTab = .home
    @Published var authMode: AuthMode = .signUp
    @Published var email = ""
    @Published var password = ""
    @Published var firstName: String
    @Published var lastName = ""
    @Published var birthDate = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var conditions: Set<String> = []
    @Published var screeningAnswers: [String: String] = [:]
    @Published var agreedPrivacy = false
    @Published var wearableChoice: String?
    @Published var openFolderId: String?
    @Published var documents: [UploadedDoc] = []
    @Published var uploadStep: UploadStep?
    @Published var uploadFileName = ""
    @Published var uploadFileDate = ""
    @Published var uploadFolder = "general"
    @Published var uploadError: String?
    @Published var isUploading = false
    @Published var isAuthLoading = false
    @Published var authError: String?
    @Published var screeningDetailId: String?

    private var uploadData: Data?
    private var uploadMimeType = ""

    init(patientName: String = "", startAtHome: Bool = false) {
        firstName = patientName
        step = startAtHome ? .home : .splash
    }

    var ageLabel: String { birthDate.isEmpty ? "30 yo" : birthDate }

    var hasUploadedDoc: Bool { !activeFolderDocs.isEmpty }

    var activeFolder: FolderDef? {
        AppData.folderDefs.first { $0.id == openFolderId }
    }

    var activeFolderDocs: [UploadedDoc] {
        documents.filter { $0.folderId == openFolderId }
    }

    func docCount(for folder: FolderDef) -> Int {
        documents.filter { $0.folderId == folder.id }.count
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

    var recordsCount: Int { documents.count }

    func bootstrap() async {
        guard let session = try? await supabase.auth.session else { return }
        email = session.user.email ?? ""
        do {
            try await loadProfile(userId: session.user.id)
            try await loadDocuments()
            step = firstName.isEmpty ? .profileName : .home
        } catch {
            authError = "Your account could not be loaded. Please try again."
        }
    }

    func goToCarousel() { step = .carousel }

    func carouselContinue() {
        if carouselIndex >= 3 {
            step = .signupEmail
        } else {
            carouselIndex += 1
        }
    }

    func submitEmail() {
        let value = email.trimmed.lowercased()
        guard value.count <= 254,
              value.range(of: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#, options: [.regularExpression, .caseInsensitive]) != nil
        else {
            authError = "Enter a valid email address."
            return
        }

        guard (8...72).contains(password.count) else {
            authError = "Use a password between 8 and 72 characters."
            return
        }

        email = value
        isAuthLoading = true
        authError = nil
        Task {
            defer { isAuthLoading = false }
            do {
                if authMode == .signIn {
                    let response = try await supabase.auth.signIn(email: value, password: password)
                    try await loadProfile(userId: response.user.id)
                    try await loadDocuments()
                    password = ""
                    step = firstName.isEmpty ? .profileName : .home
                    return
                }

                let response = try await supabase.auth.signUp(email: value, password: password)
                try await loadProfile(userId: response.user.id)
                try await loadDocuments()
                password = ""
                step = .profileName
            } catch {
                authError = authMode == .signIn
                    ? "The email or password is incorrect."
                    : "The account could not be created. Try signing in if you already have one."
            }
        }
    }

    func setAuthMode(_ mode: AuthMode) {
        authMode = mode
        authError = nil
    }
    func submitName() { guard !firstName.trimmed.isEmpty else { return }; step = .profileDetails }
    func submitDetails() { guard !birthDate.trimmed.isEmpty else { return }; step = .privacy }
    func toggleAgreePrivacy() { agreedPrivacy.toggle() }
    func submitPrivacy() { guard agreedPrivacy else { return }; step = .conditions }
    func submitConditions() { step = .screeningsCheck }
    func submitScreeningsCheck() { step = .wearableOffer }
    func goToWearableConnect() { step = .wearableConnect }

    func finishOnboarding() {
        guard firstName.trimmed.count <= 80,
              lastName.trimmed.count <= 80,
              birthDate.trimmed.count <= 40,
              height.trimmed.count <= 16,
              weight.trimmed.count <= 16
        else {
            authError = "One or more profile fields are too long."
            return
        }

        isAuthLoading = true
        authError = nil
        Task {
            defer { isAuthLoading = false }
            do {
                let user = try await supabase.auth.session.user
                try await supabase
                    .from("profiles")
                    .upsert(ProfileUpsert(
                        id: user.id,
                        firstName: firstName.trimmed,
                        lastName: lastName.trimmed,
                        birthDate: birthDate.trimmed,
                        height: height.trimmed,
                        weight: weight.trimmed,
                        conditions: conditions.sorted(),
                        screeningAnswers: screeningAnswers,
                        agreedPrivacy: agreedPrivacy,
                        wearableChoice: wearableChoice
                    ))
                    .execute()
                step = .home
            } catch {
                authError = "Your profile could not be saved. Please try again."
            }
        }
    }

    func closeModal() { step = .carousel }

    func toggleCondition(_ name: String) {
        if conditions.contains(name) { conditions.remove(name) } else { conditions.insert(name) }
    }

    func setScreeningAnswer(_ question: String, _ answer: String) {
        screeningAnswers[question] = answer
    }

    func selectWearable(_ id: String) { wearableChoice = id }
    func goToTab(_ tab: AppTab) { activeTab = tab }
    func openFolder(_ id: String) { openFolderId = id }
    func closeFolderDetail() { openFolderId = nil }

    func openUploadSheet() {
        uploadFolder = openFolderId ?? "general"
        uploadStep = .pick
        uploadError = nil
    }

    func closeUpload() {
        uploadStep = nil
        uploadData = nil
        uploadMimeType = ""
        uploadError = nil
    }

    func selectFile(_ url: URL) {
        uploadError = nil
        let hasAccess = url.startAccessingSecurityScopedResource()
        defer { if hasAccess { url.stopAccessingSecurityScopedResource() } }

        do {
            let values = try url.resourceValues(forKeys: [.fileSizeKey])
            guard (values.fileSize ?? 0) <= 10_485_760 else {
                uploadError = "Choose a file smaller than 10 MB."
                return
            }

            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            guard !data.isEmpty, data.count <= 10_485_760 else {
                uploadError = "Choose a file between 1 byte and 10 MB."
                return
            }

            if data.starts(with: [0x25, 0x50, 0x44, 0x46, 0x2D]) {
                uploadMimeType = "application/pdf"
            } else if data.starts(with: [0xFF, 0xD8, 0xFF]) {
                uploadMimeType = "image/jpeg"
            } else if data.starts(with: [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]) {
                uploadMimeType = "image/png"
            } else {
                uploadError = "Choose a PDF, JPEG, or PNG file."
                return
            }

            uploadData = data
            uploadFileName = String(url.deletingPathExtension().lastPathComponent.trimmed.prefix(160))
            uploadFileDate = Date.now.formatted(date: .abbreviated, time: .omitted)
            uploadStep = .details
        } catch {
            uploadError = "The selected file could not be read."
        }
    }

    func uploadDocument() {
        guard let uploadData else {
            uploadError = "Select a file first."
            return
        }

        let name = uploadFileName.trimmed
        guard !name.isEmpty, name.count <= 160, uploadFileDate.trimmed.count <= 40 else {
            uploadError = "Enter a document name of 160 characters or fewer."
            return
        }

        isUploading = true
        uploadError = nil
        uploadStep = .uploading
        Task {
            defer { isUploading = false }
            do {
                let user = try await supabase.auth.session.user
                let fileExtension = uploadMimeType == "application/pdf" ? "pdf" : uploadMimeType == "image/png" ? "png" : "jpg"
                let path = "\(user.id.uuidString)/\(UUID().uuidString).\(fileExtension)"
                try await supabase.storage
                    .from("medical-documents")
                    .upload(
                        path,
                        data: uploadData,
                        options: FileOptions(contentType: uploadMimeType, upsert: false)
                    )

                do {
                    try await supabase
                        .from("medical_documents")
                        .insert(MedicalDocumentInsert(
                            userId: user.id,
                            folderId: uploadFolder,
                            displayName: name,
                            storagePath: path,
                            mimeType: uploadMimeType,
                            sizeBytes: uploadData.count,
                            documentDate: uploadFileDate.trimmed
                        ))
                        .execute()
                } catch {
                    _ = try? await supabase.storage.from("medical-documents").remove(paths: [path])
                    throw error
                }

                try await loadDocuments()
                uploadStep = .done
            } catch {
                uploadStep = .details
                uploadError = "The document could not be uploaded. Please try again."
            }
        }
    }

    func finishUpload() {
        openFolderId = uploadFolder
        closeUpload()
    }

    func documentURL(for document: UploadedDoc) async throws -> URL {
        try await supabase.storage
            .from("medical-documents")
            .createSignedURL(path: document.storagePath, expiresIn: 300)
    }

    func signOut() {
        Task {
            try? await supabase.auth.signOut()
            email = ""
            password = ""
            authMode = .signUp
            firstName = ""
            lastName = ""
            birthDate = ""
            height = ""
            weight = ""
            conditions = []
            screeningAnswers = [:]
            agreedPrivacy = false
            wearableChoice = nil
            documents = []
            openFolderId = nil
            activeTab = .home
            carouselIndex = 0
            step = .splash
        }
    }

    func openScreeningDetail(_ id: String) { screeningDetailId = id }
    func closeScreeningDetail() { screeningDetailId = nil }

    private func loadProfile(userId: UUID) async throws {
        let profile: ProfileRecord = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value

        firstName = profile.firstName
        lastName = profile.lastName
        birthDate = profile.birthDate
        height = profile.height
        weight = profile.weight
        conditions = Set(profile.conditions)
        screeningAnswers = profile.screeningAnswers
        agreedPrivacy = profile.agreedPrivacy
        wearableChoice = profile.wearableChoice
    }

    private func loadDocuments() async throws {
        documents = try await supabase
            .from("medical_documents")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
