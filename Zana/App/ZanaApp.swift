import SwiftUI

@main
struct ZanaApp: App {
    @StateObject private var state = AppState(patientName: "Sophia")

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
        }
    }
}
