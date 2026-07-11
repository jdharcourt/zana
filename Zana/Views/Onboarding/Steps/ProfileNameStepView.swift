import SwiftUI

struct ProfileNameStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Perfect! Now let's set up your profile.")
                .font(.zSerif(28))
                .foregroundStyle(ZColor.ink)
                .lineSpacing(2)
                .padding(.vertical, 8)

            Text("What should we call you?")
                .font(.z(14))
                .foregroundStyle(ZColor.textSecondary)
                .padding(.bottom, 22)

            ZLabeledField(label: "First name", placeholder: "First name", text: $state.firstName)
                .padding(.bottom, 14)

            ZLabeledField(label: "Last name", placeholder: "Last name", text: $state.lastName)
                .padding(.bottom, 24)

            PrimaryButton(
                title: "Next →",
                background: state.firstName.trimmed.isEmpty ? ZColor.disabled : ZColor.ink,
                isDisabled: state.firstName.trimmed.isEmpty
            ) { state.submitName() }
        }
    }
}
