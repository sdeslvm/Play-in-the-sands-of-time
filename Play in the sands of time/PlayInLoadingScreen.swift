import SwiftUI

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Modern Loading Screen

struct PlayInLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#1A2980"),
                        Color(hex: "#26D0CE"),
                        Color(hex: "#F2F2F2")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()
                    // Modern spinning loader
                    PlayInModernSpinner(progress: progress)
                        .frame(width: geo.size.width * 0.18, height: geo.size.width * 0.18)
                        .padding(.bottom, 12)

                    Text("Loading \(progressPercentage)%")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#1A2980"))
                        .shadow(color: Color(hex: "#26D0CE").opacity(0.25), radius: 2, y: 1)

                    PlayInProgressBar(value: progress)
                        .frame(width: geo.size.width * 0.52, height: 12)
                        .padding(.top, 8)

                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

// MARK: - Modern Spinner

struct PlayInModernSpinner: View {
    let progress: Double
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#26D0CE"),
                            Color(hex: "#1A2980"),
                            Color(hex: "#F2F2F2")
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 8
                )
                .opacity(0.25)

            Circle()
                .trim(from: 0, to: CGFloat(max(progress, 0.05)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#26D0CE"),
                            Color(hex: "#1A2980"),
                            Color(hex: "#26D0CE")
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1.2).repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear { isAnimating = true }
        }
    }
}

// MARK: - Background

struct PlayInBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#1A2980"),
                Color(hex: "#26D0CE"),
                Color(hex: "#F2F2F2")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var body: some View {
        makeBackground()
    }
}

// MARK: - Progress Bar

struct PlayInProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(Color(hex: "#F2F2F2").opacity(0.3))
                    .frame(height: geometry.size.height)

                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#26D0CE"),
                                Color(hex: "#1A2980")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
                    .animation(.easeOut(duration: 0.4), value: value)
            }
        }
    }
}

// MARK: - Preview

#Preview("Modern Loading") {
    PlayInLoadingOverlay(progress: 0.42)
}

#Preview("Modern Loading Landscape") {
    PlayInLoadingOverlay(progress: 0.42)
        .previewInterfaceOrientation(.landscapeRight)
}

// MARK: - HEX Color Extension

extension Color {
    init(hex hexValue: String) {
        let sanitizedHex = hexValue.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)

        self.init(
            .sRGB,
            red: Double((colorValue >> 16) & 0xFF) / 255.0,
            green: Double((colorValue >> 8) & 0xFF) / 255.0,
            blue: Double(colorValue & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}
