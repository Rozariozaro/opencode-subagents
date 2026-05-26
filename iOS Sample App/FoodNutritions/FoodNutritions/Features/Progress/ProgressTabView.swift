import SwiftUI

/// Progress tab placeholder — "Coming Soon" until backend data is available.
struct ProgressTabView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: DS.spacingLG) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 48))
                    .foregroundStyle(DS.primary)

                Text("Progress")
                    .font(.headline(24, weight: .bold))
                    .foregroundStyle(DS.onSurface)

                Text("Track your nutrition trends over time.\nComing soon.")
                    .font(.body(14))
                    .foregroundStyle(DS.zinc500)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DS.surface)
        }
    }
}
