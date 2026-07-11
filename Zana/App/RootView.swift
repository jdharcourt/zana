import SwiftUI

struct RootView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            switch state.step {
            case .splash:
                SplashView()
            case .carousel:
                CarouselView()
            case .home:
                HomeAppView()
            default:
                if state.step.isModal {
                    ZColor.modalBg.ignoresSafeArea()
                    OnboardingModalView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: state.step)
    }
}

#Preview {
    RootView().environmentObject(AppState(patientName: "Sophia"))
}
