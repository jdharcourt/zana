import SwiftUI

struct EmailStepView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(state.authMode == .signUp ? "Create an account" : "Sign in")
                .font(.z(28, .bold))
                .foregroundStyle(ZColor.ink)
                .padding(.vertical, 8)

            Text(state.authMode == .signUp
                 ? "Use your email and a password to keep your medical documents private."
                 : "Access your saved profile and documents.")
                .font(.z(14))
                .foregroundStyle(ZColor.textSecondary)
                .lineSpacing(4)
                .padding(.bottom, 20)

            HStack(spacing: 24) {
                authTab("Create account", mode: .signUp)
                authTab("Sign in", mode: .signIn)
            }
            .padding(.bottom, 20)

            ZLabeledField(label: "Email address", placeholder: "you@example.com", text: $state.email, keyboardType: .emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.bottom, 16)

            ZSecureField(label: "Password", text: $state.password)
                .padding(.bottom, 20)

            PrimaryButton(
                title: state.authMode == .signUp ? "Create account" : "Sign in",
                background: canSubmit ? ZColor.ink : ZColor.disabled,
                isDisabled: !canSubmit
            ) { state.submitEmail() }
        }
    }

    private var canSubmit: Bool {
        !state.email.trimmed.isEmpty && state.password.count >= 8 && !state.isAuthLoading
    }

    private func authTab(_ title: String, mode: AuthMode) -> some View {
        Button { state.setAuthMode(mode) } label: {
            Text(title)
                .font(.z(14, .semibold))
                .foregroundStyle(state.authMode == mode ? ZColor.ink : ZColor.textMuted)
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(state.authMode == mode ? ZColor.ink : Color.clear)
                        .frame(height: 2)
                }
        }
    }
}
