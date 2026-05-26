import SwiftUI

struct MainTabView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var diaryViewModel = DiaryViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DiaryView(viewModel: diaryViewModel)
                .tag(0)
                .tabItem {
                    Label("Diary", systemImage: selectedTab == 0 ? "calendar" : "calendar")
                }

            NavigationStack {
                SearchView(
                    diaryViewModel: diaryViewModel,
                    userId: authManager.userId
                )
            }
            .tag(1)
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                ProgressTabView()
            }
            .tag(2)
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationStack {
                ProfileView()
            }
            .tag(3)
            .tabItem {
                Label("Profile", systemImage: selectedTab == 3 ? "person.fill" : "person")
            }
        }
        .tint(DS.primary)
        .onChange(of: selectedTab) { _, _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        .onAppear {
            configureTabBarAppearance()
        }
    }

    // MARK: - Glassmorphic Tab Bar

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.adaptive(light: 0xFFFFFF, dark: 0x060E20).withAlphaComponent(0.8)
        appearance.shadowColor = UIColor.adaptive(light: 0x000000, dark: 0x000000).withAlphaComponent(0.05)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
