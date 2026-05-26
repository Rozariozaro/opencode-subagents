import SwiftUI

/// A shimmer loading effect for skeleton screens.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1.0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            DS.surfaceContainerLowest.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: geometry.size.width * phase)
                    .clipped()
                }
            )
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.6
                }
            }
    }
}

/// A skeleton placeholder row for loading states.
struct ShimmerRow: View {
    var body: some View {
        HStack(spacing: DS.spacingMD) {
            RoundedRectangle(cornerRadius: DS.radiusLG)
                .fill(DS.surfaceContainerHigh)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: DS.spacingSM) {
                RoundedRectangle(cornerRadius: DS.radiusSM)
                    .fill(DS.surfaceContainerHigh)
                    .frame(width: 120, height: 12)

                RoundedRectangle(cornerRadius: DS.radiusSM)
                    .fill(DS.surfaceContainer)
                    .frame(width: 80, height: 10)
            }

            Spacer()

            RoundedRectangle(cornerRadius: DS.radiusSM)
                .fill(DS.surfaceContainerHigh)
                .frame(width: 40, height: 14)
        }
        .padding(DS.spacingMD)
        .modifier(ShimmerModifier())
    }
}

/// Skeleton card for diary loading.
struct DiarySkeletonView: View {
    var body: some View {
        VStack(spacing: DS.spacingLG) {
            // Hero card skeleton
            VStack(spacing: DS.spacingMD) {
                HStack {
                    VStack(alignment: .leading, spacing: DS.spacingSM) {
                        RoundedRectangle(cornerRadius: DS.radiusSM)
                            .fill(DS.surfaceContainerHigh)
                            .frame(width: 100, height: 12)
                        RoundedRectangle(cornerRadius: DS.radiusSM)
                            .fill(DS.surfaceContainerHigh)
                            .frame(width: 140, height: 32)
                    }
                    Spacer()
                    Circle()
                        .fill(DS.surfaceContainerHigh)
                        .frame(width: 80, height: 80)
                }
                .padding(DS.spacingXL)
            }
            .background(DS.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: DS.radiusMD))
            .modifier(ShimmerModifier())

            // Macro cards skeleton
            HStack(spacing: DS.spacingMD) {
                skeletonMacroCard
                skeletonMacroCard
            }

            // Meal card skeletons
            ForEach(0..<3, id: \.self) { _ in
                VStack(spacing: 0) {
                    HStack(spacing: DS.spacingSM) {
                        Circle()
                            .fill(DS.surfaceContainerHigh)
                            .frame(width: 24, height: 24)
                        RoundedRectangle(cornerRadius: DS.radiusSM)
                            .fill(DS.surfaceContainerHigh)
                            .frame(width: 80, height: 14)
                        Spacer()
                    }
                    .padding(DS.spacingLG)

                    ShimmerRow()
                }
                .background(DS.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: DS.radiusMD))
            }
        }
        .padding(.horizontal, DS.spacingLG)
    }

    private var skeletonMacroCard: some View {
        VStack(alignment: .leading, spacing: DS.spacingSM) {
            RoundedRectangle(cornerRadius: DS.radiusSM)
                .fill(DS.surfaceContainerHigh)
                .frame(width: 60, height: 10)
            RoundedRectangle(cornerRadius: DS.radiusSM)
                .fill(DS.surfaceContainer)
                .frame(height: 6)
        }
        .dsCard(padding: DS.spacingMD, radius: DS.radiusMD)
        .modifier(ShimmerModifier())
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
