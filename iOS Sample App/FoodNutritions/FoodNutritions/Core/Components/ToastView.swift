import SwiftUI

/// A brief confirmation banner that slides in from the top and auto-dismisses.
struct ToastView: View {
    let message: String
    let icon: String
    let tint: Color

    init(_ message: String, icon: String = "checkmark.circle.fill", tint: Color = DS.primary) {
        self.message = message
        self.icon = icon
        self.tint = tint
    }

    var body: some View {
        HStack(spacing: DS.spacingSM) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(tint)

            Text(message)
                .font(.label(14, weight: .bold))
                .foregroundStyle(DS.onSurface)
        }
        .padding(.horizontal, DS.spacingXL)
        .padding(.vertical, DS.spacingMD)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(tint.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: DS.adaptiveShadowMD, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Toast Modifier

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let icon: String
    let tint: Color
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    ToastView(message, icon: icon, tint: tint)
                        .padding(.top, DS.spacing3XL + 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(999)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    isPresented = false
                                }
                            }
                        }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        icon: String = "checkmark.circle.fill",
        tint: Color = DS.primary,
        duration: TimeInterval = 2.0
    ) -> some View {
        modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            icon: icon,
            tint: tint,
            duration: duration
        ))
    }
}
