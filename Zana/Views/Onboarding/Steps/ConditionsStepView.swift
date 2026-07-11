import SwiftUI

struct ConditionsStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Do you have any of these health conditions?")
                .font(.zSerif(27))
                .foregroundStyle(ZColor.ink)
                .lineSpacing(2)
                .padding(.vertical, 8)

            Text("This helps Zana personalise your screening timeline and recommendations.")
                .font(.z(13.5))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 6)

            Text("Your data is stored securely and never shared without your consent.")
                .font(.z(13.5))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 18)

            Text("Select any conditions you have")
                .font(.z(13, .bold))
                .foregroundStyle(ZColor.ink)
                .padding(.bottom, 10)

            VStack(spacing: 0) {
                ForEach(AppData.conditionDefs, id: \.self) { condition in
                    Button {
                        state.toggleCondition(condition)
                    } label: {
                        HStack(spacing: 10) {
                            ZCheckbox(checked: state.conditions.contains(condition))
                            Text(condition)
                                .font(.z(14.5))
                                .foregroundStyle(ZColor.ink)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 2)
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(ZColor.divider).frame(height: 1)
                    }
                }
            }
            .padding(.bottom, 16)

            PrimaryButton(title: "Next →") { state.submitConditions() }
        }
    }
}
