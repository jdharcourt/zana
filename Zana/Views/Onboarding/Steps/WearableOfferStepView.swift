import SwiftUI

struct WearableOfferStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            Text("Thank you, \(state.firstName)")
                .font(.zSerif(28))
                .foregroundStyle(ZColor.ink)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

            Text("Your profile is almost complete. Want to sync health data from a wearable, health app, or cycle tracker?")
                .font(.z(14))
                .foregroundStyle(ZColor.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 28)

            HStack(spacing: 14) {
                Text("Zana")
                    .font(.zSerif(26, italic: true))
                    .foregroundStyle(ZColor.disabled)

                Rectangle()
                    .fill(ZColor.disabled)
                    .frame(width: 20, height: 1)

                iconBadge(systemName: "clock", background: ZColor.ink)
                iconBadge(systemName: "plus", background: ZColor.teal)
                iconBadge(systemName: "heart.fill", background: ZColor.blue)
            }
            .padding(.bottom, 30)

            PrimaryButton(title: "I want to sync my data +") { state.goToWearableConnect() }
                .padding(.bottom, 16)

            Button("Skip for now") { state.finishOnboarding() }
                .font(.z(14))
                .foregroundStyle(ZColor.textTertiary)
        }
    }

    private func iconBadge(systemName: String, background: Color) -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(background)
            .frame(width: 42, height: 42)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
            )
    }
}
