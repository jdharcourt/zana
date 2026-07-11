import SwiftUI

struct WearableConnectStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            Text("Tap to connect to...")
                .font(.zSerif(27))
                .foregroundStyle(ZColor.ink)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .padding(.bottom, 22)

            VStack(spacing: 12) {
                ForEach(AppData.wearableDefs) { wearable in
                    Button {
                        state.selectWearable(wearable.id)
                    } label: {
                        HStack(spacing: 14) {
                            IconTile(
                                systemName: ZIcon.name(for: wearable.icon),
                                background: wearable.iconBg,
                                foreground: .white,
                                size: 38,
                                iconSize: 16,
                                corner: 10
                            )
                            Text(wearable.label)
                                .font(.z(14.5))
                                .foregroundStyle(ZColor.ink)
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(state.wearableChoice == wearable.id ? ZColor.ink : Color(hex: "#e3dccd"), lineWidth: 1.5)
                        )
                    }
                }
            }
            .padding(.bottom, 24)

            PrimaryButton(title: "Continue to sync →") { state.finishOnboarding() }
        }
    }
}
