import SwiftUI

struct EmailStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Create an account")
                .font(.zSerif(30))
                .foregroundStyle(ZColor.ink)
                .padding(.vertical, 8)

            Text("Store your results, track conditions, and get screening reminders for your age and life stage.")
                .font(.z(14))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 24)

            ZLabeledField(label: "Email address", text: $state.email, keyboardType: .emailAddress)
                .padding(.bottom, 16)

            PrimaryButton(
                title: "Continue",
                background: state.email.trimmed.isEmpty ? ZColor.disabled : ZColor.ink,
                isDisabled: state.email.trimmed.isEmpty
            ) { state.submitEmail() }
            .padding(.bottom, 18)

            HStack(spacing: 10) {
                Rectangle().fill(ZColor.inputBorder).frame(height: 1)
                Text("Or").font(.z(12)).foregroundStyle(ZColor.textMuted)
                Rectangle().fill(ZColor.inputBorder).frame(height: 1)
            }
            .padding(.bottom, 18)

            Button { state.submitEmail() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "applelogo")
                    Text("Continue with Apple")
                }
                .font(.z(14.5, .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .background(ZColor.ink)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.bottom, 10)

            Button { state.submitEmail() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "g.circle.fill")
                    Text("Continue with Google")
                }
                .font(.z(14.5, .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .background(ZColor.ink)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}
