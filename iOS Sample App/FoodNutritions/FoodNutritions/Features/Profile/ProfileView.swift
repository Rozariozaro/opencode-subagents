import SwiftUI

struct ProfileView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var showSignOutConfirmation = false

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DS.spacingXL) {
                    profileHero
                    quickStatsGrid
                    settingsList
                    signOutButton
                    versionFooter
                }
                .padding(.horizontal, DS.spacingLG)
                .padding(.top, DS.spacingSM)
                .padding(.bottom, DS.spacing3XL)
            }
            .background(DS.surface)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.dsTitle)
                        .tracking(-0.3)
                }
            }
            .alert("Sign Out", isPresented: $showSignOutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authManager.logout()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }

    // MARK: - Profile Hero

    private var profileHero: some View {
        VStack(spacing: DS.spacingMD) {
            // Avatar with edit badge
            ZStack(alignment: .bottomTrailing) {
                // Avatar placeholder
                Image(systemName: "person.fill")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(DS.zinc400)
                    .frame(width: 128, height: 128)
                    .background(DS.surfaceContainerHigh)
                    .clipShape(RoundedRectangle(cornerRadius: DS.radiusXL))
                    .shadow(color: DS.adaptiveShadowMD, radius: 8, x: 0, y: 8)

                // Edit badge
                Image(systemName: "pencil")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DS.onPrimary)
                    .frame(width: 36, height: 36)
                    .background(DS.primary, in: Circle())
                    .shadow(color: DS.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                    .overlay(
                        Circle()
                            .stroke(DS.onPrimary, lineWidth: 4)
                    )
                    .offset(x: 4, y: 4)
            }

            // Name and membership
            VStack(spacing: 4) {
                Text(userName)
                    .font(.headline(24, weight: .heavy))
                    .tracking(-0.5)
                    .foregroundStyle(DS.onSurface)

                Text("MEMBER SINCE \(memberSince)")
                    .font(.dsLabelSM)
                    .foregroundStyle(DS.zinc400)
                    .tracking(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DS.spacingLG)
    }

    private var userName: String {
        let email = authManager.userEmail
        if let atIndex = email.firstIndex(of: "@") {
            return String(email[email.startIndex..<atIndex]).capitalized
        }
        return "User"
    }

    private var memberSince: String {
        // Derive from account creation; for now use static
        "2024"
    }

    // MARK: - Quick Stats Grid

    private var quickStatsGrid: some View {
        HStack(spacing: DS.spacingMD) {
            statCard(
                icon: "flame.fill",
                iconColor: DS.primary,
                value: "14 Days",
                label: "STREAK"
            )
            statCard(
                icon: "scalemass.fill",
                iconColor: DS.tertiary,
                value: "--",
                label: "PROGRESS"
            )
        }
    }

    private func statCard(icon: String, iconColor: Color, value: String, label: String) -> some View {
        VStack(spacing: DS.spacingMD) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)

            Text(value)
                .font(.headline(24, weight: .heavy))
                .foregroundStyle(DS.onSurface)

            Text(label)
                .font(.dsLabelSM)
                .foregroundStyle(DS.zinc400)
                .tracking(2)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.spacing2XL)
        .background(DS.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
        .shadow(color: DS.adaptiveShadowSM, radius: 8, x: 0, y: 8)
    }

    // MARK: - Settings List

    private var settingsList: some View {
        VStack(alignment: .leading, spacing: DS.spacingSM) {
            // Section header
            Text("SETTINGS")
                .font(.dsLabelSM)
                .foregroundStyle(DS.zinc400)
                .tracking(2)
                .padding(.horizontal, 8)

            VStack(spacing: DS.spacingSM) {
                settingsRow(
                    icon: "person.fill",
                    iconBg: DS.primary.opacity(0.1),
                    iconColor: DS.primary,
                    label: "Account"
                )
                settingsRow(
                    icon: "bell.fill",
                    iconBg: DS.secondary.opacity(0.1),
                    iconColor: DS.secondary,
                    label: "Notifications"
                )
                settingsRow(
                    icon: "ruler.fill",
                    iconBg: DS.tertiary.opacity(0.1),
                    iconColor: DS.tertiary,
                    label: "Units",
                    secondaryValue: "Metric"
                )
                settingsRow(
                    icon: "questionmark.circle.fill",
                    iconBg: DS.surfaceContainerLow,
                    iconColor: DS.zinc600,
                    label: "Help"
                )
            }
        }
    }

    private func settingsRow(
        icon: String,
        iconBg: Color,
        iconColor: Color,
        label: String,
        secondaryValue: String? = nil
    ) -> some View {
        Button {
            // TODO: navigate to settings detail
        } label: {
            HStack(spacing: DS.spacingMD) {
                Image(systemName: icon)
                    .font(.body.weight(.medium))
                    .foregroundStyle(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconBg, in: Circle())

                Text(label)
                    .font(.body(16, weight: .semibold))
                    .foregroundStyle(DS.onSurface)

                Spacer()

                if let value = secondaryValue {
                    Text(value)
                        .font(.dsBody)
                        .foregroundStyle(DS.zinc400)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DS.outlineVariant)
            }
            .padding(DS.spacingLG)
            .background(DS.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
            .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sign Out

    private var signOutButton: some View {
        Button {
            showSignOutConfirmation = true
        } label: {
            HStack(spacing: DS.spacingSM) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.body.weight(.medium))
                    .foregroundStyle(DS.error)

                Text("Sign Out")
                    .font(.headline(16, weight: .bold))
                    .foregroundStyle(DS.error)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DS.spacingLG)
            .padding(.horizontal, DS.spacing2XL)
            .background(DS.errorContainer.opacity(0.2), in: RoundedRectangle(cornerRadius: DS.radius2XL))
            .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Sign Out")
    }

    // MARK: - Version Footer

    private var versionFooter: some View {
        VStack(spacing: 4) {
            Text("FoodNutritions v\(appVersion) (\(buildNumber))")
                .font(.dsCaption)
                .foregroundStyle(DS.zinc400)
            Text("Powered by PocketBase")
                .font(.dsCaption)
                .foregroundStyle(DS.zinc400)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DS.spacingSM)
    }
}
