import SwiftUI

/// The post-onboarding app shell: four tabs plus every overlay that can appear above them
/// (folder detail, upload flow, screening detail, AI summary), stacked in the same order
/// the prototype uses for its z-index layers.
struct HomeAppView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            ZColor.appBg.ignoresSafeArea()

            VStack(spacing: 0) {
                tabContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                TabBar()
            }

            if state.openFolderId != nil {
                FolderDetailView()
                    .transition(.move(edge: .trailing))
            }

            if state.uploadStep != nil {
                UploadSheetView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if state.screeningDetailId != nil {
                ScreeningDetailView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if state.aiSummaryOpen {
                AiSummaryView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .statusBarStyle(.darkContent)
        .animation(.easeInOut(duration: 0.22), value: state.openFolderId)
        .animation(.easeInOut(duration: 0.2), value: state.uploadStep)
        .animation(.easeInOut(duration: 0.2), value: state.screeningDetailId)
        .animation(.easeInOut(duration: 0.2), value: state.aiSummaryOpen)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch state.activeTab {
        case .home: HomeTabView()
        case .folders: FoldersTabView()
        case .screenings: ScreeningsTabView()
        case .account: AccountTabView()
        }
    }
}

/// Standard header used at the top of each tab ("Sophia · 30 yo" + menu button).
struct TabHeader: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(state.firstName)
                    .font(.zSerif(30))
                    .foregroundStyle(ZColor.ink)
                Text(state.ageLabel)
                    .font(.z(13))
                    .foregroundStyle(ZColor.textTertiary)
            }
            Spacer()
            Circle()
                .fill(Color.white)
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(ZColor.ink)
                )
        }
    }
}

private struct TabBar: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        HStack {
            tabButton(.home, systemName: "house", label: "Home")
            tabButton(.folders, systemName: "folder", label: "Folders")

            Button { state.openUploadSheet() } label: {
                Circle()
                    .fill(ZColor.fabGradient)
                    .frame(width: 52, height: 52)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: ZColor.blue.opacity(0.35), radius: 10, y: 6)
                    .offset(y: -18)
            }
            .frame(maxWidth: .infinity)

            tabButton(.screenings, systemName: "checklist", label: "Screenings")
            tabButton(.account, systemName: "person.crop.circle", label: "Account")
        }
        .padding(.horizontal, 18)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }

    private func tabButton(_ tab: AppTab, systemName: String, label: String) -> some View {
        Button { state.goToTab(tab) } label: {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 17))
                Text(label)
                    .font(.z(10))
            }
            .foregroundStyle(ZColor.ink)
            .opacity(state.activeTab == tab ? 1 : 0.45)
        }
        .frame(maxWidth: .infinity)
    }
}
