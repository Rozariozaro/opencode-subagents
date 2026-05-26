import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddFoodViewModel
    var diaryViewModel: DiaryViewModel

    init(food: FoodItem, userId: String, diaryViewModel: DiaryViewModel, preselectedMeal: MealType = .breakfast, selectedDate: Date = Date()) {
        self._viewModel = State(initialValue: AddFoodViewModel(food: food, userId: userId, selectedDate: selectedDate))
        self.diaryViewModel = diaryViewModel
        // Will set meal type after init
        self._initialMeal = State(initialValue: preselectedMeal)
    }

    @State private var initialMeal: MealType = .breakfast

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: DS.spacingXL) {
                    foodHero
                    macroVisualization
                    quantityStepper
                    mealSelector
                }
                .padding(.horizontal, DS.spacingLG)
                .padding(.top, DS.spacingLG)
                .padding(.bottom, 120) // space for sticky button
            }
            .background(DS.surfaceContainerLowest)

            // Sticky footer
            stickyFooter
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundStyle(DS.primary)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Add Food")
                    .font(.dsTitle)
                    .tracking(-0.3)
            }
        }
        .onAppear {
            viewModel.mealType = initialMeal
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }

    // MARK: - Food Identity Hero

    private var foodHero: some View {
        VStack(spacing: DS.spacingSM) {
            // Food icon placeholder
            let (bg, fg, icon) = foodIconConfig(viewModel.food)
            Image(systemName: icon)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(fg)
                .frame(width: 96, height: 96)
                .background(bg, in: RoundedRectangle(cornerRadius: DS.radius3XL))
                .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)

            Text(viewModel.food.name)
                .font(.headline(24, weight: .heavy))
                .tracking(-0.5)
                .foregroundStyle(DS.onSurface)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if let serving = viewModel.food.servingSize {
                Text(serving)
                    .font(.dsBody)
                    .foregroundStyle(DS.onSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DS.spacingLG)
        .padding(.bottom, DS.spacingSM)
    }

    // MARK: - Macro Visualization

    private var macroVisualization: some View {
        VStack(spacing: DS.spacingMD) {
            // Energy row
            energyRow

            // Macro 3-column grid
            HStack(spacing: DS.spacingMD) {
                macroCard(label: "PROTEIN", value: viewModel.scaledProtein, color: DS.primary)
                macroCard(label: "CARBS", value: viewModel.scaledCarbs, color: DS.secondary)
                macroCard(label: "FATS", value: viewModel.scaledFat, color: DS.tertiary)
            }
        }
    }

    private var energyRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ENERGY")
                    .font(.dsLabelSM)
                    .foregroundStyle(DS.onSurfaceVariant)
                    .tracking(1.5)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(viewModel.scaledCalories.calorieString)
                        .font(.headline(36, weight: .heavy))
                        .foregroundStyle(DS.primary)
                        .tracking(-0.5)
                    Text("kcal")
                        .font(.label(14, weight: .bold))
                        .foregroundStyle(DS.onSurfaceVariant)
                }
            }

            Spacer()

            // Mini donut
            DonutChartView(
                progress: min(viewModel.scaledCalories / AppConfig.defaultCalorieGoal, 1.0),
                size: 64,
                strokeWidth: 4,
                trackColor: DS.surfaceDim,
                fillColor: DS.primary
            )
        }
        .padding(DS.spacingXL)
        .background(DS.surfaceContainerLow, in: RoundedRectangle(cornerRadius: DS.radius2XL))
    }

    private func macroCard(label: String, value: Double, color: Color) -> some View {
        VStack(spacing: DS.spacingSM) {
            Text(label)
                .font(.dsLabelSM)
                .foregroundStyle(DS.onSurfaceVariant)
                .tracking(1)

            Text("\(value.calorieString)g")
                .font(.headline(20, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.spacingLG)
        .background(DS.surfaceContainerLow, in: RoundedRectangle(cornerRadius: DS.radius2XL))
    }

    // MARK: - Quantity Stepper

    private var quantityStepper: some View {
        VStack(alignment: .leading, spacing: DS.spacingMD) {
            HStack {
                Text("Quantity")
                    .font(.dsHeadline)
                    .foregroundStyle(DS.onSurface)
                Spacer()
                Text("\(Int(viewModel.quantity * (viewModel.food.servingWeight))) grams")
                    .font(.dsBodySM)
                    .foregroundStyle(DS.primary)
                    .fontWeight(.bold)
            }

            HStack {
                // Minus
                Button {
                    if viewModel.quantity > 0.5 {
                        withAnimation { viewModel.quantity -= 0.5 }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(DS.onSurface)
                        .frame(width: 48, height: 48)
                        .background(DS.surfaceContainerLowest, in: Circle())
                        .shadow(color: DS.adaptiveShadowMD, radius: 4, x: 0, y: 2)
                }
                .accessibilityLabel("Decrease quantity")

                Spacer()

                Text(viewModel.quantity.macroString)
                    .font(.headline(22, weight: .bold))
                    .foregroundStyle(DS.onSurface)
                    .frame(minWidth: 60)
                    .multilineTextAlignment(.center)

                Spacer()

                // Plus
                Button {
                    withAnimation { viewModel.quantity += 0.5 }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(DS.onSurface)
                        .frame(width: 48, height: 48)
                        .background(DS.surfaceContainerLowest, in: Circle())
                        .shadow(color: DS.adaptiveShadowMD, radius: 4, x: 0, y: 2)
                }
                .accessibilityLabel("Increase quantity")
            }
            .padding(.horizontal, DS.spacingSM)
            .padding(.vertical, DS.spacingSM)
            .background(DS.surfaceContainerHigh, in: Capsule())
        }
    }

    // MARK: - Meal Selector

    private var mealSelector: some View {
        VStack(alignment: .leading, spacing: DS.spacingMD) {
            Text("Select Meal")
                .font(.dsHeadline)
                .foregroundStyle(DS.onSurface)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DS.spacingSM) {
                    ForEach(MealType.allCases) { type in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.mealType = type
                            }
                        } label: {
                            Text(type.displayName)
                                .font(.body(14, weight: viewModel.mealType == type ? .bold : .semibold))
                                .foregroundStyle(
                                    viewModel.mealType == type ? DS.onPrimaryContainer : DS.onSurfaceVariant
                                )
                                .padding(.horizontal, DS.spacing2XL)
                                .padding(.vertical, 10)
                                .background(
                                    viewModel.mealType == type ? DS.primaryContainer : DS.surfaceContainerHigh,
                                    in: Capsule()
                                )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Sticky Footer

    private var stickyFooter: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(DS.surfaceVariant)
                .frame(height: 1)

            GradientButton(
                "Add to Diary",
                icon: "checkmark.circle.fill",
                isLoading: viewModel.isLogging
            ) {
                Task {
                    let foodName = viewModel.food.name
                    if let created = await viewModel.logFood() {
                        // Optimistic local insert
                        diaryViewModel.addLogLocally(created)
                        // Haptic success
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        // Dismiss and post toast notification
                        dismiss()
                        NotificationCenter.default.post(
                            name: .diaryNeedsRefresh,
                            object: nil,
                            userInfo: ["toastMessage": "\(foodName) added"]
                        )
                    } else {
                        // Haptic error
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    }
                }
            }
            .disabled(viewModel.isLogging || viewModel.quantity <= 0)
            .padding(DS.spacingLG)
        }
        .background(
            .ultraThinMaterial
        )
    }

    // MARK: - Helpers

    private func foodIconConfig(_ item: FoodItem) -> (Color, Color, String) {
        switch item.foodType {
        case .recipe:
            return (Color.orange.opacity(0.1), .orange, "fork.knife")
        case .packagedFood:
            return (Color.blue.opacity(0.1), .blue, "shippingbox")
        }
    }
}

// MARK: - FoodItem serving weight helper

extension FoodItem {
    /// Approximate serving weight in grams, parsed from servingSize or defaulting to 100g.
    var servingWeight: Double {
        guard let serving = servingSize else { return 100 }
        // Try to extract a number from the serving size string
        let numbers = serving.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Double($0) }
        return numbers.first ?? 100
    }
}
