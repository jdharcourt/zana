import SwiftUI

struct PrivacyStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "#EDE8DC"))
                    .frame(width: 70, height: 70)

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LinearGradient(colors: [ZColor.teal, ZColor.blue], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 44, height: 50)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    )
            }
            .padding(.top, 8)
            .padding(.bottom, 20)

            Text("We take your health data seriously.")
                .font(.zSerif(28))
                .foregroundStyle(ZColor.ink)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 0) {
                Text("Your Medical Records")
                    .font(.z(13, .bold))
                    .foregroundStyle(ZColor.ink)
                    .padding(.bottom, 6)

                Text("Your documents are stored securely and never shared without your consent.")
                    .font(.z(13.5))
                    .foregroundStyle(ZColor.textSecondary)
                    .lineSpacing(4)
                    .padding(.bottom, 16)

                OutlineButton(title: "Read our Privacy Policy") {}
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button { state.toggleAgreePrivacy() } label: {
                HStack(spacing: 10) {
                    ZCheckbox(checked: state.agreedPrivacy)
                    Text("Agree to our Privacy Policy")
                        .font(.z(13.5))
                        .foregroundStyle(ZColor.ink)
                    Spacer()
                }
                .padding(14)
                .background(Color(hex: "#E3DDD1"))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .padding(.bottom, 20)

            PrimaryButton(
                title: "Next →",
                background: state.agreedPrivacy ? ZColor.ink : ZColor.disabled,
                isDisabled: !state.agreedPrivacy
            ) { state.submitPrivacy() }
        }
    }
}
