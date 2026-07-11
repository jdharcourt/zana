import SwiftUI

struct SplashView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            ZColor.splashGradient.ignoresSafeArea()

            Text("Zana")
                .font(.zSerif(56, italic: true))
                .foregroundStyle(.white)

            VStack {
                Spacer()
                Button {
                    state.goToCarousel()
                } label: {
                    HStack(spacing: 8) {
                        Text("Start Now")
                        Image(systemName: "arrow.right")
                    }
                    .font(.z(16, .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                }
                .foregroundStyle(.white)
                .background(ZColor.ink)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 56)
            }
        }
        .statusBarStyle(.lightContent)
    }
}
