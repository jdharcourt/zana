import SwiftUI

struct ProfileDetailsStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Nice to meet you, \(state.firstName).")
                .font(.zSerif(28))
                .foregroundStyle(ZColor.ink)
                .padding(.vertical, 8)

            Text("Let's complete your profile with additional information.")
                .font(.z(14))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 22)

            ZLabeledField(label: "Birth date", placeholder: "Jan 6, 1996", text: $state.birthDate)
                .padding(.bottom, 14)

            HStack(spacing: 12) {
                ZLabeledField(label: "Height", placeholder: "170", text: $state.height, keyboardType: .numberPad)
                ZLabeledField(label: "Weight", placeholder: "65", text: $state.weight, keyboardType: .numberPad)
            }
            .padding(.bottom, 24)

            PrimaryButton(
                title: "Next →",
                background: state.birthDate.trimmed.isEmpty ? ZColor.disabled : ZColor.ink,
                isDisabled: state.birthDate.trimmed.isEmpty
            ) { state.submitDetails() }
        }
    }
}
