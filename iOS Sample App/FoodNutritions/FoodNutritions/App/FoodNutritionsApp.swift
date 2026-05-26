import SwiftUI

@main
struct FoodNutritionsApp: App {
    @State private var authManager = AuthManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .task {
                    await authManager.loginOnLaunch()
                }
                // Dark mode now supported via adaptive DS tokens
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .active:
                        // Post notification so diary can refresh when returning to foreground
                        NotificationCenter.default.post(name: .appDidBecomeActive, object: nil)
                    case .background:
                        // Cancel any in-flight search tasks to free resources
                        NotificationCenter.default.post(name: .appDidEnterBackground, object: nil)
                    default:
                        break
                    }
                }
        }
    }
}

// MARK: - App Lifecycle Notifications

extension Notification.Name {
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")
    static let appDidEnterBackground = Notification.Name("appDidEnterBackground")
    static let diaryNeedsRefresh = Notification.Name("diaryNeedsRefresh")
}

struct ContentView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else if authManager.isLoading {
                loadingView
            } else {
                errorView
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: DS.spacingLG) {
            ProgressView()
                .tint(DS.primary)
                .scaleEffect(1.2)

            Text("Signing in...")
                .font(.dsBody)
                .foregroundStyle(DS.zinc500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.surface)
    }

    private var errorView: some View {
        VStack(spacing: DS.spacingXL) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(DS.tertiary)

            VStack(spacing: DS.spacingSM) {
                Text("Unable to Sign In")
                    .font(.headline(20, weight: .bold))
                    .foregroundStyle(DS.onSurface)

                if let error = authManager.errorMessage {
                    Text(error)
                        .font(.dsBodySM)
                        .foregroundStyle(DS.zinc500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DS.spacing3XL)
                }
            }

            GradientButton("Retry", icon: "arrow.clockwise") {
                Task { await authManager.loginOnLaunch() }
            }
            .padding(.horizontal, DS.spacing3XL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.surface)
    }
}
