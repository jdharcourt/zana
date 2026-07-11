import SwiftUI

struct CarouselView: View {
    @EnvironmentObject var state: AppState

    var slide: CarouselSlide { AppData.carouselSlides[state.carouselIndex] }

    var body: some View {
        ZStack {
            ZColor.carouselGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(ZColor.carouselSlideGradient(slide.gradientIndex))
                        .frame(width: 220, height: 220)
                        .shadow(color: .black.opacity(0.12), radius: 25, y: 10)

                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .padding(18)
                        .frame(width: 220, height: 220)

                    Circle()
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 1.5)
                        .padding(44)
                        .frame(width: 220, height: 220)

                    Image(systemName: ZIcon.name(for: slide.icon))
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .offset(x: 70, y: 70)
                }
                .frame(width: 220, height: 220)

                Spacer()

                VStack(spacing: 0) {
                    Text(slide.title)
                        .font(.zSerif(32))
                        .foregroundStyle(ZColor.ink)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)

                    Text(slide.subtitle)
                        .font(.z(14.5))
                        .foregroundStyle(ZColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.bottom, 24)

                    Button {
                        state.carouselContinue()
                    } label: {
                        HStack(spacing: 8) {
                            Text(slide.cta)
                            Image(systemName: "arrow.right")
                        }
                        .font(.z(15.5, .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .background(ZColor.ink)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.bottom, 14)

                    HStack(spacing: 6) {
                        ForEach(0..<AppData.carouselSlides.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(i == state.carouselIndex ? ZColor.ink : ZColor.divider)
                                .frame(width: i == state.carouselIndex ? 20 : 6, height: 5)
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 36)
                .padding(.bottom, 28)
                .background(ZColor.modalBg)
                .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
            }
        }
        .statusBarStyle(.darkContent)
        .animation(.easeInOut(duration: 0.2), value: state.carouselIndex)
    }
}

/// Rounds only the specified corners — used for the bottom-sheet-style panels
/// throughout the prototype (`border-radius: 32px 32px 0 0`, etc.).
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
