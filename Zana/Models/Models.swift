import SwiftUI

enum AppStep: Equatable {
    case splash
    case carousel
    case signupEmail
    case verifyCode
    case profileName
    case profileDetails
    case privacy
    case conditions
    case screeningsCheck
    case wearableOffer
    case wearableConnect
    case home

    static let modalSteps: [AppStep] = [
        .signupEmail, .verifyCode, .profileName, .profileDetails,
        .privacy, .conditions, .screeningsCheck, .wearableOffer, .wearableConnect,
    ]

    static let progressSteps: [AppStep] = [
        .profileName, .profileDetails, .privacy, .conditions, .screeningsCheck,
    ]

    var isModal: Bool { AppStep.modalSteps.contains(self) }
    var progressIndex: Int? { AppStep.progressSteps.firstIndex(of: self) }
}

enum AppTab {
    case home, folders, screenings, account
}

enum UploadStep {
    case pick, uploading, details, done
}

enum FolderIcon {
    case general, bloodwork, cardiology, dermatology, mentalHealth, dental
}

struct FolderDef: Identifiable {
    let id: String
    let name: String
    let iconBg: Color
    let icon: FolderIcon
}

enum WearableIcon {
    case apple, fitbit, googleFit, garmin, flo
}

struct WearableDef: Identifiable {
    let id: String
    let label: String
    let iconBg: Color
    let icon: WearableIcon
}

enum CarouselIcon {
    case folder, clock, pin, star
}

struct CarouselSlide {
    let title: String
    let subtitle: String
    let cta: String
    let gradientIndex: Int
    let icon: CarouselIcon
}

struct ScreeningHistoryEntry: Identifiable {
    let id = UUID()
    let date: String
    let badge: String
    let badgeBg: Color
    let badgeColor: Color
    let title: String
    let detail: String
}

enum ScreeningGroup: String, CaseIterable {
    case overdue = "OVERDUE"
    case scheduled = "SCHEDULED"
    case upcoming = "UPCOMING"
}

struct ScreeningItemDef: Identifiable {
    let id: String
    let name: String
    let accent: Color
    let bg: Color
    let status: String
    let meta: String
    let btnFilled: Bool
    let btnLabel: String
    let group: ScreeningGroup
    let history: [ScreeningHistoryEntry]
}

struct UploadedDoc {
    let name: String
    let date: String
}

enum AppData {
    static let carouselSlides: [CarouselSlide] = [
        CarouselSlide(title: "All your results, in one place", subtitle: "Store all your medical documents safely. No more lost results.", cta: "Continue", gradientIndex: 0, icon: .folder),
        CarouselSlide(title: "Never miss a screening", subtitle: "Get reminders based on your age and health history.", cta: "Continue", gradientIndex: 1, icon: .clock),
        CarouselSlide(title: "Find the right clinic, fast", subtitle: "See nearby clinics for exactly the screening you need.", cta: "Continue", gradientIndex: 2, icon: .pin),
        CarouselSlide(title: "Welcome to Zana", subtitle: "One place for screenings, records, and reminders.", cta: "Start my journey", gradientIndex: 3, icon: .star),
    ]

    static let conditionDefs: [String] = [
        "Diabetes (Type 1 or 2)", "Hypertension", "Asthma", "High cholesterol",
        "Thyroid disorder", "Depression or anxiety", "Chronic kidney disease",
    ]

    static let screeningDefs: [String] = [
        "Blood pressure check", "Cholesterol panel", "Blood glucose / A1C", "Skin check",
    ]

    static let chipLabels: [String] = ["Up to date", "1-2 years ago", "3+ years ago", "Never / Not sure"]

    static let wearableDefs: [WearableDef] = [
        WearableDef(id: "apple", label: "Apple Health", iconBg: Color(hex: "#111111"), icon: .apple),
        WearableDef(id: "fitbit", label: "Fitbit", iconBg: Color(hex: "#00b0b9"), icon: .fitbit),
        WearableDef(id: "googlefit", label: "Google Fit", iconBg: Color(hex: "#2e7d5b"), icon: .googleFit),
        WearableDef(id: "garmin", label: "Garmin Connect", iconBg: Color(hex: "#0072ce"), icon: .garmin),
        WearableDef(id: "flo", label: "Flo (cycle tracking, optional)", iconBg: Color(hex: "#7B4FB8"), icon: .flo),
    ]

    static let folderDefs: [FolderDef] = [
        FolderDef(id: "general", name: "General", iconBg: Color(hex: "#E7E2D6"), icon: .general),
        FolderDef(id: "bloodwork", name: "Bloodwork", iconBg: Color(hex: "#DCEAE8"), icon: .bloodwork),
        FolderDef(id: "cardiology", name: "Cardiology", iconBg: Color(hex: "#E3E8F2"), icon: .cardiology),
        FolderDef(id: "dermatology", name: "Dermatology", iconBg: Color(hex: "#EAE3F0"), icon: .dermatology),
        FolderDef(id: "mentalhealth", name: "Mental Health", iconBg: Color(hex: "#E0E3F2"), icon: .mentalHealth),
        FolderDef(id: "dental", name: "Dental", iconBg: Color(hex: "#DCEAE6"), icon: .dental),
    ]

    static let screeningItemDefs: [String: ScreeningItemDef] = [
        "bp": ScreeningItemDef(
            id: "bp", name: "Blood pressure check",
            accent: ZColor.overdueAccent, bg: ZColor.overdueBg,
            status: "Overdue", meta: "Was due Dec 2024",
            btnFilled: true, btnLabel: "Find a clinic", group: .overdue,
            history: [
                ScreeningHistoryEntry(date: "Jan 2026", badge: "Slightly high", badgeBg: ZColor.warningBg, badgeColor: ZColor.warningText, title: "Blood pressure check", detail: "135/86 mmHg · Recheck advised"),
                ScreeningHistoryEntry(date: "Jan 2025", badge: "Normal", badgeBg: ZColor.successBg, badgeColor: ZColor.successText, title: "Blood pressure check", detail: "118/76 mmHg · Within healthy range"),
            ]
        ),
        "chol": ScreeningItemDef(
            id: "chol", name: "Cholesterol panel",
            accent: ZColor.scheduledAccent, bg: ZColor.scheduledBg,
            status: "Scheduled", meta: "Booked 14 Mar, 10:00",
            btnFilled: false, btnLabel: "Calendar", group: .scheduled,
            history: [
                ScreeningHistoryEntry(date: "Mar 2025", badge: "Slightly elevated", badgeBg: ZColor.warningBg, badgeColor: ZColor.warningText, title: "Cholesterol panel", detail: "LDL 3.4 mmol/L · Retest in 1 year"),
                ScreeningHistoryEntry(date: "Mar 2024", badge: "Normal", badgeBg: ZColor.successBg, badgeColor: ZColor.successText, title: "Cholesterol panel", detail: "Within range"),
            ]
        ),
        "skin": ScreeningItemDef(
            id: "skin", name: "Skin check",
            accent: ZColor.upcomingAccent, bg: ZColor.upcomingBg,
            status: "Upcoming", meta: "Due in 3 weeks",
            btnFilled: true, btnLabel: "Find a clinic", group: .upcoming,
            history: [
                ScreeningHistoryEntry(date: "Jan 2024", badge: "Clear", badgeBg: ZColor.successBg, badgeColor: ZColor.successText, title: "Skin check", detail: "No concerning moles found"),
            ]
        ),
    ]

    static let accountRows: [String] = [
        "Personal information", "Connected apps & wearables", "Notifications", "Privacy & data", "Help & support",
    ]
}
