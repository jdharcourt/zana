import SwiftUI

struct VerifyCodeStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Check your email")
                .font(.zSerif(30))
                .foregroundStyle(ZColor.ink)
                .padding(.vertical, 8)

            (
                Text("We just sent a temporary identification code to ")
                    .foregroundStyle(ZColor.textSecondary)
                + Text(state.email)
                    .foregroundStyle(ZColor.ink)
                    .fontWeight(.semibold)
            )
            .font(.z(14))
            .lineSpacing(4)
            .padding(.bottom, 24)

            ZLabeledField(label: "Identification code", text: $state.code, keyboardType: .numberPad)
                .padding(.bottom, 8)

            Text("I did not receive the code. See options →")
                .font(.z(12.5))
                .foregroundStyle(ZColor.textMuted)
                .padding(.bottom, 20)

            PrimaryButton(
                title: "Continue",
                background: state.code.trimmed.isEmpty ? ZColor.disabled : ZColor.ink,
                isDisabled: state.code.trimmed.isEmpty
            ) { state.submitCode() }
        }
    }
}
