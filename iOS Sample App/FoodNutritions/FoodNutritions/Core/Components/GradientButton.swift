import SwiftUI

/// Primary CTA button with gradient from `primary` to `primaryContainer` at 135deg.
/// Matches the design system's "Signature Texture" pattern.
struct GradientButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DS.spacingSM) {
                if isLoading {
                    ProgressView()
                        .tint(DS.onPrimary)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                    }
                    Text(title)
                        .font(.headline(18, weight: .heavy))
                }
            }
            .foregroundStyle(DS.onPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(DS.primaryGradient, in: Capsule())
            .shadow(color: DS.primary.opacity(0.25), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .accessibilityLabel(title)
    }
}
