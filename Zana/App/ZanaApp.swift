import SwiftUI

@main
struct ZanaApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .task { await state.bootstrap() }
        }
    }
}
