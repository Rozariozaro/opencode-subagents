import SwiftUI

/// Horizontal progress bar with tonal track/fill colors.
/// Used in Diary macro cards and Food Detail macro bento.
struct MacroProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let fillColor: Color
    let trackColor: Color
    let height: CGFloat

    init(
        progress: Double,
        fillColor: Color = DS.primary,
        trackColor: Color = DS.surfaceDim,
        height: CGFloat = 6
    ) {
        self.progress = min(max(progress, 0), 1)
        self.fillColor = fillColor
        self.trackColor = trackColor
        self.height = height
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(trackColor)
                    .frame(height: height)

                // Fill
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(fillColor)
                    .frame(width: geo.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.4), value: progress)
            }
        }
        .frame(height: height)
    }
}
