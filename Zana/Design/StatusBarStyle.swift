import SwiftUI
import UIKit

/// SwiftUI has no direct API for per-screen status bar style; this hosts a zero-size
/// UIViewController whose `preferredStatusBarStyle` drives the real status bar,
/// letting each screen opt into light (splash) or dark (everywhere else) content.
private struct StatusBarStyleHost: UIViewControllerRepresentable {
    let style: UIStatusBarStyle

    func makeUIViewController(context: Context) -> StatusBarViewController {
        StatusBarViewController(style: style)
    }

    func updateUIViewController(_ controller: StatusBarViewController, context: Context) {
        controller.style = style
    }

    final class StatusBarViewController: UIViewController {
        var style: UIStatusBarStyle {
            didSet { setNeedsStatusBarAppearanceUpdate() }
        }

        init(style: UIStatusBarStyle) {
            self.style = style
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError() }

        override var preferredStatusBarStyle: UIStatusBarStyle { style }
    }
}

extension View {
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        background(StatusBarStyleHost(style: style).frame(width: 0, height: 0))
    }
}
