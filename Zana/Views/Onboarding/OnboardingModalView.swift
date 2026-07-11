import SwiftUI

/// The dark-scrim bottom sheet that hosts every onboarding step after the carousel:
/// signup, verification, profile, privacy, conditions, screenings check, and wearable sync.
struct OnboardingModalView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 70)

                VStack(spacing: 0) {
                    header
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            stepContent
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 6)
                        .padding(.bottom, 20)
                    }
                }
                .background(ZColor.modalBg)
                .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .statusBarStyle(.darkContent)
    }

    private var header: some View {
        HStack {
            if let idx = state.step.progressIndex {
                ProgressDots(total: AppStep.progressSteps.count, filledUpTo: idx)
            } else {
                Spacer()
            }
            ZCloseButton { state.closeModal() }
                .padding(.leading, 12)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch state.step {
        case .signupEmail: EmailStepView()
        case .verifyCode: VerifyCodeStepView()
        case .profileName: ProfileNameStepView()
        case .profileDetails: ProfileDetailsStepView()
        case .privacy: PrivacyStepView()
        case .conditions: ConditionsStepView()
        case .screeningsCheck: ScreeningsCheckStepView()
        case .wearableOffer: WearableOfferStepView()
        case .wearableConnect: WearableConnectStepView()
        default: EmptyView()
        }
    }
}
