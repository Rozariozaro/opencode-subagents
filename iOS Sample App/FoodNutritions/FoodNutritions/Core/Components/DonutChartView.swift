import SwiftUI

/// Reusable donut/ring chart used in Diary hero, Food Detail, and Add Food modal.
struct DonutChartView: View {
    let progress: Double // 0.0 to 1.0
    let size: CGFloat
    let strokeWidth: CGFloat
    let trackColor: Color
    let fillColor: Color
    let centerContent: AnyView?

    init(
        progress: Double,
        size: CGFloat = 80,
        strokeWidth: CGFloat = 8,
        trackColor: Color = DS.surfaceContainerHigh,
        fillColor: Color = DS.primary,
        @ViewBuilder center: () -> some View = { EmptyView() }
    ) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.strokeWidth = strokeWidth
        self.trackColor = trackColor
        self.fillColor = fillColor
        self.centerContent = AnyView(center())
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, lineWidth: strokeWidth)

            // Fill
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    fillColor,
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)

            // Center content
            if let centerContent {
                centerContent
            }
        }
        .frame(width: size, height: size)
    }
}
