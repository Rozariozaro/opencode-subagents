import SwiftUI

struct DiaryView: View {
    @Environment(AuthManager.self) private var authManager
    @Bindable var viewModel: DiaryViewModel
    @State private var showingSearch = false
    @State private var selectedMealForAdd: MealType = .breakfast
    @State private var showDatePicker = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var animateDonut = false
    @State private var animateMacros = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if viewModel.isLoading && viewModel.logs.isEmpty {
                        ScrollView {
                            DiarySkeletonView()
                                .padding(.top, DS.spacingSM)
                        }
                        .background(DS.surface)
                    } else {
                        diaryContent
                    }
                }

                // FAB
                fab
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(isToday ? "Today" : viewModel.selectedDate.shortDisplayString)
                        .font(.dsTitle)
                        .tracking(-0.3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDatePicker = true
                    } label: {
                        Image(systemName: "calendar")
                            .font(.body.weight(.medium))
                            .foregroundStyle(DS.primary)
                    }
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .task {
                viewModel.setUserId(authManager.userId)
                await viewModel.loadLogs()
                triggerAnimations()
            }
            .sheet(isPresented: $showingSearch) {
                NavigationStack {
                    SearchView(
                        diaryViewModel: viewModel,
                        userId: authManager.userId,
                        preselectedMeal: selectedMealForAdd
                    )
                }
            }
            .sheet(isPresented: $showDatePicker) {
                datePickerSheet
            }
            .toast(isPresented: $showToast, message: toastMessage)
            .onReceive(NotificationCenter.default.publisher(for: .appDidBecomeActive)) { _ in
                Task { await viewModel.loadLogs() }
            }
            .onReceive(NotificationCenter.default.publisher(for: .diaryNeedsRefresh)) { notification in
                if let message = notification.userInfo?["toastMessage"] as? String {
                    toastMessage = message
                    showToast = true
                }
                Task { await viewModel.loadLogs() }
            }
        }
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(viewModel.selectedDate)
    }

    // MARK: - Main Content

    private var diaryContent: some View {
        ScrollView {
            VStack(spacing: DS.spacingLG) {
                dateNavBar
                dailySummaryCard
                macroQuickView
                mealCards
            }
            .padding(.horizontal, DS.spacingLG)
            .padding(.top, DS.spacingSM)
            .padding(.bottom, 80)
        }
        .background(DS.surface)
        .refreshable {
            await viewModel.loadLogs()
            triggerAnimations()
        }
    }

    // MARK: - Date Navigation

    private var dateNavBar: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.selectedDate) ?? viewModel.selectedDate
                    resetAnimations()
                    Task {
                        await viewModel.loadLogs()
                        triggerAnimations()
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(DS.primary)
                    .frame(width: 36, height: 36)
                    .background(DS.primary.opacity(0.1), in: Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text(viewModel.selectedDate.shortDisplayString)
                    .font(.dsLabelMD)
                    .foregroundStyle(DS.onSurface)
                if isToday {
                    Text("TODAY")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.primary)
                        .tracking(1.5)
                }
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.selectedDate) ?? viewModel.selectedDate
                    resetAnimations()
                    Task {
                        await viewModel.loadLogs()
                        triggerAnimations()
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isToday ? DS.zinc400 : DS.primary)
                    .frame(width: 36, height: 36)
                    .background((isToday ? DS.zinc400 : DS.primary).opacity(0.1), in: Circle())
            }
            .disabled(isToday)
        }
    }

    // MARK: - Daily Summary (Hero Card)

    private var dailySummaryCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("REMAINING")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.zinc400)
                        .tracking(1.5)

                    Text(viewModel.remainingCalories.calorieString)
                        .font(.headline(42, weight: .heavy))
                        .foregroundStyle(DS.primary)
                        .tracking(-1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .contentTransition(.numericText(value: viewModel.remainingCalories))
                }

                Spacer()

                DonutChartView(
                    progress: animateDonut ? viewModel.calorieProgress : 0,
                    size: 80,
                    strokeWidth: 8,
                    trackColor: DS.surfaceContainerHigh,
                    fillColor: DS.primary
                ) {
                    Text("\(Int(viewModel.calorieProgress * 100))%")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.zinc400)
                }
            }

            Rectangle()
                .fill(DS.surfaceContainerLow)
                .frame(height: 1)
                .padding(.top, DS.spacing2XL)
                .padding(.bottom, DS.spacingXL)

            HStack {
                summaryColumn(label: "Goal", value: viewModel.calorieGoal.calorieString, style: .primary)
                Spacer()
                summaryColumn(label: "Food", value: viewModel.totalCalories.calorieString, style: .secondary)
                Spacer()
                summaryColumn(label: "Exercise", value: "0", style: .tertiary)
            }
        }
        .dsCard(padding: DS.spacingXL, radius: DS.radiusMD)
    }

    private enum SummaryStyle { case primary, secondary, tertiary }

    private func summaryColumn(label: String, value: String, style: SummaryStyle) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline(16, weight: .bold))
                .foregroundStyle({
                    switch style {
                    case .primary: DS.onSurface
                    case .secondary: DS.secondary
                    case .tertiary: DS.tertiary
                    }
                }() as Color)

            Text(label)
                .font(.dsLabelSM)
                .foregroundStyle(DS.zinc400)
                .tracking(0.5)
        }
    }

    // MARK: - Macro Quick View (2-column)

    private var macroQuickView: some View {
        HStack(spacing: DS.spacingMD) {
            macroCard(
                label: "PROTEIN",
                current: viewModel.totalProtein,
                goal: 150,
                color: DS.primary,
                delay: 0.1
            )
            macroCard(
                label: "CARBS",
                current: viewModel.totalCarbs,
                goal: 250,
                color: DS.secondary,
                delay: 0.2
            )
        }
    }

    private func macroCard(label: String, current: Double, goal: Double, color: Color, delay: Double) -> some View {
        VStack(alignment: .leading, spacing: DS.spacingSM) {
            HStack {
                Text(label)
                    .font(.dsLabelSM)
                    .foregroundStyle(DS.zinc400)
                    .tracking(1)
                Spacer()
                Text("\(current.calorieString)/\(goal.calorieString)g")
                    .font(.dsLabelSM)
                    .foregroundStyle(DS.onSurface)
            }
            MacroProgressBar(
                progress: animateMacros ? (goal > 0 ? min(current / goal, 1.0) : 0) : 0,
                fillColor: color,
                trackColor: DS.surfaceDim,
                height: 6
            )
        }
        .dsCard(padding: DS.spacingMD, radius: DS.radiusMD)
    }

    // MARK: - Meal Cards

    private var mealCards: some View {
        VStack(spacing: DS.spacingMD) {
            ForEach(MealType.allCases) { mealType in
                mealCard(mealType)
            }
        }
    }

    private func mealCard(_ mealType: MealType) -> some View {
        let items = viewModel.mealGroups[mealType] ?? []
        let cals = viewModel.caloriesForMeal(mealType)
        let hasItems = !items.isEmpty

        return VStack(spacing: 0) {
            // Header
            HStack(spacing: DS.spacingSM) {
                Image(systemName: mealType.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(hasItems ? DS.primary : DS.zinc400)

                Text(mealType.displayName)
                    .font(.dsHeadline)
                    .foregroundStyle(DS.onSurface)

                if cals > 0 {
                    Text("\u{2022}")
                        .foregroundStyle(DS.zinc400)
                    Text("\(cals.calorieString) cal")
                        .font(.dsBodySM)
                        .foregroundStyle(hasItems ? DS.zinc500 : DS.zinc400)
                }

                Spacer()
            }
            .padding(.horizontal, DS.spacingXL)
            .padding(.top, DS.spacingLG)
            .padding(.bottom, DS.spacingMD)

            if hasItems {
                Rectangle()
                    .fill(DS.surfaceContainer.opacity(0.5))
                    .frame(height: 1)

                VStack(spacing: DS.spacingLG) {
                    ForEach(items) { log in
                        foodItemRow(log)
                    }
                }
                .padding(.horizontal, DS.spacingXL)
                .padding(.vertical, DS.spacingMD)
            } else {
                // Empty state for meal
                emptyMealState(mealType)
            }

            Rectangle()
                .fill(DS.surfaceContainer.opacity(0.5))
                .frame(height: 1)

            // Add food button
            Button {
                selectedMealForAdd = mealType
                showingSearch = true
            } label: {
                HStack(spacing: DS.spacingSM) {
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                    Text("Add \(mealType.displayName)")
                        .font(.dsBodySM)
                        .fontWeight(.bold)
                }
                .foregroundStyle(DS.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(DS.primary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.radiusMD)
                        .stroke(DS.primary.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: DS.radiusMD))
            }
            .padding(.horizontal, DS.spacingLG)
            .padding(.vertical, DS.spacingMD)
            .background(DS.surfaceContainerLowest)
        }
        .background(DS.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DS.radiusMD))
        .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: DS.radiusMD)
                .stroke(DS.surfaceContainer, lineWidth: 1)
        )
    }

    // MARK: - Empty Meal State

    private func emptyMealState(_ mealType: MealType) -> some View {
        VStack(spacing: DS.spacingSM) {
            Image(systemName: mealType.icon)
                .font(.title3)
                .foregroundStyle(DS.zinc400.opacity(0.5))
            Text("No foods logged")
                .font(.dsCaption)
                .foregroundStyle(DS.zinc400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.spacingXL)
    }

    private func foodItemRow(_ log: FoodLog) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(log.foodName)
                    .font(.body(14, weight: .semibold))
                    .foregroundStyle(DS.onSurface)
                    .lineLimit(1)

                Text("\(log.quantity.macroString) serving \u{2022} P: \(log.protein.calorieString)g C: \(log.carbs.calorieString)g F: \(log.fat.calorieString)g")
                    .font(.dsCaption)
                    .foregroundStyle(DS.zinc400)
                    .lineLimit(1)
            }

            Spacer()

            Text("\(log.calories.calorieString)")
                .font(.body(14, weight: .bold))
                .foregroundStyle(DS.onSurface)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task {
                    guard let logId = log.id else { return }
                    let foodName = log.foodName
                    // Optimistic delete
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.removeLogLocally(logId)
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    do {
                        try await FoodLogRepository().deleteLog(id: logId)
                    } catch {
                        // Rollback — reload from server
                        await viewModel.loadLogs()
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        toastMessage = "Failed to delete \(foodName)"
                        showToast = true
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            selectedMealForAdd = smartMealType
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingSearch = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundStyle(DS.onPrimary)
                .frame(width: 56, height: 56)
                .background(DS.primary, in: Circle())
                .shadow(color: DS.primary.opacity(0.3), radius: 12, x: 0, y: 6)
                .overlay(
                    Circle()
                        .stroke(DS.onPrimary, lineWidth: 4)
                )
        }
        .padding(.trailing, DS.spacingLG + 4)
        .padding(.bottom, DS.spacing2XL)
        .accessibilityLabel("Add food")
    }

    // MARK: - Smart Meal Type

    /// Auto-selects the most relevant meal type based on time of day.
    private var smartMealType: MealType {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<10:  return .breakfast
        case 10..<14: return .lunch
        case 14..<17: return .snack
        case 17..<22: return .dinner
        default:       return .snack
        }
    }

    // MARK: - Date Picker Sheet

    private var datePickerSheet: some View {
        NavigationStack {
            DatePicker(
                "Select Date",
                selection: $viewModel.selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(DS.primary)
            .padding()
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showDatePicker = false
                        resetAnimations()
                        Task {
                            await viewModel.loadLogs()
                            triggerAnimations()
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Animation Helpers

    private func triggerAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
            animateDonut = true
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.25)) {
            animateMacros = true
        }
    }

    private func resetAnimations() {
        animateDonut = false
        animateMacros = false
    }
}
