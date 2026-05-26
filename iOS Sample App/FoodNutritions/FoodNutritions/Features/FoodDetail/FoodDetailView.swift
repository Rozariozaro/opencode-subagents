import SwiftUI

struct FoodDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let food: FoodItem
    let userId: String
    var diaryViewModel: DiaryViewModel

    @State private var showingAddFood = false
    @State private var quantity: Double = 1.0
    @State private var showAllNutrients = false

    private var scaledCalories: Double { food.calories * quantity }
    private var scaledProtein: Double { food.protein * quantity }
    private var scaledCarbs: Double { food.carbs * quantity }
    private var scaledFat: Double { food.fat * quantity }

    private var dailyPercent: Double {
        guard AppConfig.defaultCalorieGoal > 0 else { return 0 }
        return (scaledCalories / AppConfig.defaultCalorieGoal) * 100
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: DS.spacingXL) {
                    headerSection
                    heroDonutSection
                    macroBentoSection
                    imageSpotlight
                    micronutrientsSection
                    nutritionInsightCard
                    ingredientsSection
                }
                .padding(.horizontal, DS.spacingLG)
                .padding(.top, DS.spacingSM)
                .padding(.bottom, 180) // Space for bottom action area
            }
            .background(DS.surface)

            // Bottom action area
            bottomActionArea
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Food Details")
                    .font(.dsTitle)
                    .tracking(-0.3)
            }
        }
        .sheet(isPresented: $showingAddFood) {
            NavigationStack {
                AddFoodView(
                    food: food,
                    userId: userId,
                    diaryViewModel: diaryViewModel,
                    selectedDate: diaryViewModel.selectedDate
                )
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Header & Branding

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(food.name)
                .font(.headline(24, weight: .heavy))
                .tracking(-0.5)
                .foregroundStyle(DS.onSurface)

            HStack(spacing: 4) {
                if let brand = food.brand, !brand.isEmpty {
                    Text(brand)
                        .font(.dsBody)
                        .foregroundStyle(DS.onSurfaceVariant)
                }
                if let brand = food.brand, !brand.isEmpty, food.servingSize != nil {
                    Text("\u{2022}")
                        .foregroundStyle(DS.onSurfaceVariant)
                }
                if let serving = food.servingSize {
                    Text("\(serving) serving")
                        .font(.dsBody)
                        .foregroundStyle(DS.onSurfaceVariant)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Hero Donut

    private var heroDonutSection: some View {
        ZStack {
            // Background accent blob
            Circle()
                .fill(DS.primary.opacity(0.05))
                .frame(width: 160, height: 160)
                .blur(radius: 60)
                .offset(x: 60, y: -40)

            VStack(spacing: DS.spacingMD) {
                DonutChartView(
                    progress: min(dailyPercent / 100, 1.0),
                    size: 144,
                    strokeWidth: 14,
                    trackColor: DS.surfaceDim,
                    fillColor: DS.primaryContainer
                ) {
                    VStack(spacing: 2) {
                        Text(scaledCalories.calorieString)
                            .font(.headline(28, weight: .heavy))
                            .foregroundStyle(DS.onSurface)
                            .tracking(-0.5)
                        Text("KCAL")
                            .font(.dsLabelSM)
                            .foregroundStyle(DS.onSurfaceVariant)
                            .tracking(2)
                    }
                }

                // Daily goal indicator
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.caption2)
                        .foregroundStyle(DS.primary)
                    Text("\(Int(dailyPercent))% of Daily Goal")
                        .font(.body(12, weight: .semibold))
                        .foregroundStyle(DS.primary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DS.spacingLG)
        .background(DS.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
        .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(scaledCalories.calorieString) calories, \(Int(dailyPercent)) percent of daily goal")
    }

    // MARK: - Macro Bento (3-column)

    private var macroBentoSection: some View {
        HStack(spacing: DS.spacingMD) {
            macroCard(
                label: "PROTEIN",
                value: scaledProtein,
                target: 150, // TODO: user profile
                color: DS.primary,
                barColor: DS.primaryContainer
            )
            macroCard(
                label: "CARBS",
                value: scaledCarbs,
                target: 250,
                color: DS.secondary,
                barColor: DS.secondaryContainer
            )
            macroCard(
                label: "FAT",
                value: scaledFat,
                target: 65,
                color: DS.tertiary,
                barColor: DS.tertiaryContainer
            )
        }
    }

    private func macroCard(label: String, value: Double, target: Double, color: Color, barColor: Color) -> some View {
        VStack(spacing: DS.spacingSM) {
            Text(label)
                .font(.label(9, weight: .bold))
                .foregroundStyle(DS.onSurfaceVariant)
                .tracking(2)

            Text("\(value.calorieString)g")
                .font(.headline(18, weight: .bold))
                .foregroundStyle(color)

            MacroProgressBar(
                progress: target > 0 ? min(value / target, 1.0) : 0,
                fillColor: barColor,
                trackColor: DS.surfaceDim,
                height: 4
            )
        }
        .frame(maxWidth: .infinity)
        .padding(DS.spacingMD)
        .background(DS.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
        .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: DS.radius2XL)
                .stroke(DS.outlineVariant.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Image Spotlight

    private var imageSpotlight: some View {
        Group {
            let (bg, fg, icon) = foodIconConfig(food)
            ZStack(alignment: .bottomLeading) {
                // Placeholder image area with gradient
                LinearGradient(
                    colors: [bg.opacity(0.3), bg],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 128)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(fg.opacity(0.6))
                }

                // Caption overlay
                LinearGradient(
                    colors: [.black.opacity(0.4), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 60)

                Text(nutritionCaption)
                    .font(.body(12, weight: .medium))
                    .italic()
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(DS.spacingLG)
            }
            .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
        }
    }

    private var nutritionCaption: String {
        if food.protein > 20 { return "High in Protein" }
        if food.fiber > 5 { return "Good Source of Fiber" }
        if food.fat < 3 { return "Low Fat" }
        return "Balanced Nutrition"
    }

    // MARK: - Micronutrients

    private var micronutrientsSection: some View {
        let micros = buildMicronutrientList()
        let displayMicros = showAllNutrients ? micros : Array(micros.prefix(5))

        return Group {
            if !micros.isEmpty {
                VStack(alignment: .leading, spacing: DS.spacingMD) {
                    // Header
                    HStack {
                        Text("Micronutrients")
                            .font(.headline(18, weight: .bold))
                            .foregroundStyle(DS.onSurface)
                        Spacer()
                        if micros.count > 5 {
                            Button {
                                withAnimation { showAllNutrients.toggle() }
                            } label: {
                                Text(showAllNutrients ? "Show Less" : "View All")
                                    .font(.body(14, weight: .semibold))
                                    .foregroundStyle(DS.primary)
                            }
                        }
                    }

                    // Nutrient rows container
                    VStack(spacing: 4) {
                        ForEach(displayMicros, id: \.label) { micro in
                            nutrientRow(micro)
                        }
                    }
                    .padding(6)
                    .background(DS.surfaceContainerLow, in: RoundedRectangle(cornerRadius: DS.radius2XL))
                }
            }
        }
    }

    private func nutrientRow(_ micro: MicroEntry) -> some View {
        HStack(spacing: DS.spacingMD) {
            // Icon
            Image(systemName: micro.icon)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(micro.color)
                .frame(width: 28, height: 28)
                .background(micro.color.opacity(0.15), in: Circle())

            Text(micro.label)
                .font(.body(14, weight: .medium))
                .foregroundStyle(DS.onSurface)

            Spacer()

            Text(micro.value)
                .font(.body(14, weight: .semibold))
                .foregroundStyle(DS.onSurface)
        }
        .padding(.horizontal, DS.spacingLG)
        .padding(.vertical, 10)
        .background(DS.surfaceContainerLowest, in: RoundedRectangle(cornerRadius: DS.radius2XL))
    }

    // MARK: - Nutrition Insight Card

    private var nutritionInsightCard: some View {
        HStack(alignment: .top, spacing: DS.spacingLG) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(DS.primaryContainer)

            VStack(alignment: .leading, spacing: 4) {
                Text("Nutrition Insight")
                    .font(.body(14, weight: .bold))
                    .foregroundStyle(DS.onPrimaryContainer)

                Text(generateInsight())
                    .font(.body(12))
                    .foregroundStyle(DS.onSurfaceVariant)
                    .lineSpacing(4)
            }
        }
        .padding(DS.spacingXL)
        .background(DS.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: DS.radius2XL))
    }

    private func generateInsight() -> String {
        let cal = food.calories
        let prot = food.protein
        let protPercent = cal > 0 ? (prot * 4 / cal * 100) : 0

        if protPercent > 30 {
            return "This food is an excellent source of protein, with \(Int(protPercent))% of calories from protein. Great for muscle recovery and satiety."
        } else if food.fiber > 5 {
            return "A good source of dietary fiber at \(food.fiber.macroString)g per serving. Fiber supports digestive health and helps maintain steady blood sugar."
        } else if food.fat < 3 {
            return "This is a low-fat option with only \(food.fat.macroString)g of fat per serving. Ideal for those watching their fat intake."
        } else {
            return "This food provides \(cal.calorieString) calories per serving with a balanced mix of macronutrients."
        }
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        Group {
            if case .recipe(let recipe) = food, let ingredients = recipe.ingredients, !ingredients.isEmpty {
                VStack(alignment: .leading, spacing: DS.spacingMD) {
                    Text("Ingredients")
                        .font(.headline(18, weight: .bold))
                        .foregroundStyle(DS.onSurface)

                    Text(ingredients)
                        .font(.dsBody)
                        .foregroundStyle(DS.onSurfaceVariant)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .dsCard(padding: DS.spacingXL, radius: DS.radius2XL)
            }
        }
    }

    // MARK: - Bottom Action Area

    private var bottomActionArea: some View {
        VStack(spacing: DS.spacingMD) {
            // Serving adjuster
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SERVING SIZE")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.onSurfaceVariant)
                        .tracking(1)

                    Text("\(Int(food.servingWeight * quantity)) grams (\(quantity.macroString) serving)")
                        .font(.body(14, weight: .semibold))
                        .foregroundStyle(DS.onSurface)
                }

                Spacer()

                // Stepper
                HStack(spacing: DS.spacingMD) {
                    Button {
                        if quantity > 0.5 { withAnimation { quantity -= 0.5 } }
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(DS.onSurface)
                            .frame(width: 32, height: 32)
                            .background(DS.surfaceContainerLowest, in: Circle())
                            .shadow(color: DS.adaptiveShadowMD, radius: 2, x: 0, y: 1)
                    }

                    Text(quantity.macroString)
                        .font(.headline(18, weight: .bold))
                        .foregroundStyle(DS.onSurface)
                        .frame(minWidth: 30)

                    Button {
                        withAnimation { quantity += 0.5 }
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(DS.onSurface)
                            .frame(width: 32, height: 32)
                            .background(DS.surfaceContainerLowest, in: Circle())
                            .shadow(color: DS.adaptiveShadowMD, radius: 2, x: 0, y: 1)
                    }
                }
            }
            .padding(.horizontal, DS.spacingLG)
            .padding(.vertical, DS.spacingSM)
            .background(DS.surfaceContainerHigh, in: RoundedRectangle(cornerRadius: DS.radius2XL))

            // Add to diary button
            GradientButton(
                "Add to Diary",
                icon: "plus.circle.fill"
            ) {
                showingAddFood = true
            }
        }
        .padding(DS.spacingLG)
        .background(
            .ultraThinMaterial
        )
    }

    // MARK: - Micronutrient Builder

    private struct MicroEntry {
        let label: String
        let value: String
        let icon: String
        let color: Color
    }

    private func buildMicronutrientList() -> [MicroEntry] {
        var list: [MicroEntry] = []

        func add(_ label: String, _ val: Double?, unit: String, icon: String, color: Color) {
            if let v = val, v > 0 {
                list.append(MicroEntry(
                    label: label,
                    value: "\(v.macroString) \(unit)",
                    icon: icon,
                    color: color
                ))
            }
        }

        // Basic micros available on both Recipe and PackagedFood
        add("Sodium", food.sodiumMg, unit: "mg", icon: "drop.triangle", color: .orange)
        add("Calcium", food.calciumMg, unit: "mg", icon: "sun.max.fill", color: .yellow)
        add("Iron", food.ironMg, unit: "mg", icon: "bolt.fill", color: .red)
        add("Sugar", food.sugar, unit: "g", icon: "cube.fill", color: .pink)
        add("Cholesterol", food.cholesterolMg, unit: "mg", icon: "heart.fill", color: .red)

        // Extended micros from Recipe
        if case .recipe(let r) = food {
            add("Saturated Fat", r.saturatedFat, unit: "g", icon: "drop.fill", color: .orange)
            add("Potassium", r.potassiumMg, unit: "mg", icon: "drop.fill", color: .blue)
            add("Magnesium", r.magnesiumMg, unit: "mg", icon: "sparkles", color: .purple)
            add("Phosphorus", r.phosphorusMg, unit: "mg", icon: "atom", color: .indigo)
            add("Zinc", r.zincMg, unit: "mg", icon: "shield.fill", color: .gray)
            add("Copper", r.copperMg, unit: "mg", icon: "circle.hexagongrid", color: .brown)
            add("Manganese", r.manganeseMg, unit: "mg", icon: "leaf.fill", color: .green)
            add("Selenium", r.seleniumUg, unit: "\u{00B5}g", icon: "shield.checkered", color: .teal)
            add("Vitamin A", r.vitaUg, unit: "\u{00B5}g", icon: "eye.fill", color: .orange)
            add("Vitamin C", r.vitcMg, unit: "mg", icon: "sun.min.fill", color: .yellow)
            add("Vitamin E", r.viteMg, unit: "mg", icon: "leaf.circle.fill", color: .green)
            add("Vitamin B1", r.vitb1Mg, unit: "mg", icon: "bolt.circle.fill", color: .blue)
            add("Vitamin B2", r.vitb2Mg, unit: "mg", icon: "bolt.circle.fill", color: .cyan)
            add("Vitamin B3", r.vitb3Mg, unit: "mg", icon: "bolt.circle.fill", color: .indigo)
            add("Vitamin B5", r.vitb5Mg, unit: "mg", icon: "bolt.circle.fill", color: .purple)
            add("Vitamin B6", r.vitb6Mg, unit: "mg", icon: "bolt.circle.fill", color: .mint)
            add("Vitamin B7", r.vitb7Ug, unit: "\u{00B5}g", icon: "bolt.circle.fill", color: .pink)
            add("Vitamin B9", r.vitb9Ug, unit: "\u{00B5}g", icon: "bolt.circle.fill", color: .orange)
            add("Folate", r.folateUg, unit: "\u{00B5}g", icon: "leaf.fill", color: .green)
            add("Vitamin D2", r.vitd2Ug, unit: "\u{00B5}g", icon: "sun.max.fill", color: .yellow)
            add("Vitamin D3", r.vitd3Ug, unit: "\u{00B5}g", icon: "sun.max.fill", color: .orange)
            add("Vitamin K1", r.vitk1Ug, unit: "\u{00B5}g", icon: "drop.circle.fill", color: .green)
            add("Vitamin K2", r.vitk2Ug, unit: "\u{00B5}g", icon: "drop.circle.fill", color: .teal)
            add("Carotenoids", r.carotenoidsUg, unit: "\u{00B5}g", icon: "sun.haze.fill", color: .orange)
            add("Free Sugar", r.freesugarG, unit: "g", icon: "cube.fill", color: .pink)
            add("Energy", r.energyKj, unit: "kJ", icon: "flame.fill", color: .red)
        }

        return list
    }

    // MARK: - Helpers

    private func foodIconConfig(_ item: FoodItem) -> (Color, Color, String) {
        switch item.foodType {
        case .recipe:
            return (Color.orange.opacity(0.15), .orange, "fork.knife")
        case .packagedFood:
            return (Color.blue.opacity(0.15), .blue, "shippingbox")
        }
    }
}
