import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SearchViewModel()
    @State private var selectedFood: FoodItem?
    @State private var showingAddFood = false
    @State private var showingFoodDetail = false
    @State private var activeFilter: SearchFilter = .all

    var diaryViewModel: DiaryViewModel
    let userId: String
    var preselectedMeal: MealType = .breakfast

    enum SearchFilter: String, CaseIterable {
        case all = "All"
        case recipes = "Recipes"
        case packaged = "Packaged"
    }

    var body: some View {
        VStack(spacing: 0) {
            searchSection
            filterChips
            contentArea
        }
        .background(DS.surface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Search")
                    .font(.dsTitle)
                    .tracking(-0.3)
            }
        }
        .sheet(isPresented: $showingAddFood) {
            if let food = selectedFood {
                AddFoodView(
                    food: food,
                    userId: userId,
                    diaryViewModel: diaryViewModel,
                    preselectedMeal: preselectedMeal,
                    selectedDate: diaryViewModel.selectedDate
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationDestination(isPresented: $showingFoodDetail) {
            if let food = selectedFood {
                FoodDetailView(
                    food: food,
                    userId: userId,
                    diaryViewModel: diaryViewModel
                )
            }
        }
    }

    // MARK: - Search Bar

    private var searchSection: some View {
        VStack(spacing: DS.spacingMD) {
            HStack(spacing: DS.spacingMD) {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .font(.body.weight(.medium))
                    .foregroundStyle(DS.primary)

                // Text field
                TextField("e.g. naan + chicken curry", text: $viewModel.query)
                    .font(.dsBody)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()

                // Clear / barcode buttons
                if !viewModel.query.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(DS.zinc400)
                    }
                }

                // Barcode scanner button
                Button {
                    // TODO: barcode scanning
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.body.weight(.medium))
                        .foregroundStyle(DS.primary)
                        .frame(width: 32, height: 32)
                        .background(DS.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: DS.radiusLG))
                }
            }
            .padding(.horizontal, DS.spacingLG)
            .padding(.vertical, DS.spacingMD)
            .background(DS.surfaceContainerLowest)
            .clipShape(Capsule())
            .shadow(color: DS.adaptiveShadowSM, radius: 4, x: 0, y: 2)
            .overlay(
                Capsule()
                    .stroke(DS.surfaceContainer, lineWidth: 1)
            )
        }
        .padding(.horizontal, DS.spacingLG)
        .padding(.top, DS.spacingSM)
        .padding(.bottom, DS.spacingMD)
    }

    // MARK: - Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.spacingSM) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            activeFilter = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.label(12, weight: .bold))
                            .foregroundStyle(activeFilter == filter ? DS.onPrimary : DS.zinc600)
                            .padding(.horizontal, DS.spacingXL)
                            .padding(.vertical, DS.spacingSM)
                            .background(
                                activeFilter == filter ? DS.primary : DS.surfaceContainerLowest,
                                in: Capsule()
                            )
                            .overlay(
                                Capsule()
                                    .stroke(
                                        activeFilter == filter ? Color.clear : DS.surfaceContainer,
                                        lineWidth: 1
                                    )
                            )
                            .shadow(
                                color: activeFilter == filter ? DS.primary.opacity(0.2) : .clear,
                                radius: 4, x: 0, y: 2
                            )
                    }
                }
            }
            .padding(.horizontal, DS.spacingLG)
        }
        .padding(.bottom, DS.spacingMD)
    }

    // MARK: - Content

    private var contentArea: some View {
        Group {
            if viewModel.isSearching {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(DS.primary)
                    Text("Searching...")
                        .font(.dsBodySM)
                        .foregroundStyle(DS.zinc400)
                        .padding(.top, DS.spacingSM)
                    Spacer()
                }
            } else if let error = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundStyle(DS.tertiary)
                    Text(error)
                        .font(.dsBodySM)
                        .foregroundStyle(DS.zinc500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DS.spacing3XL)
                    Spacer()
                }
            } else if !viewModel.query.isEmpty && viewModel.query.count >= 2 {
                if filteredResults.isEmpty {
                    emptyState
                } else {
                    resultsList
                }
            } else {
                recentSection
            }
        }
    }

    private var filteredResults: [FoodItem] {
        switch activeFilter {
        case .all:
            return viewModel.results
        case .recipes:
            return viewModel.results.filter { $0.foodType == .recipe }
        case .packaged:
            return viewModel.results.filter { $0.foodType == .packagedFood }
        }
    }

    private var emptyState: some View {
        VStack(spacing: DS.spacingLG) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(DS.zinc400)
            Text("No results found")
                .font(.dsHeadline)
                .foregroundStyle(DS.onSurface)
            Text("Try a different search term")
                .font(.dsBodySM)
                .foregroundStyle(DS.zinc400)
            Spacer()
        }
    }

    // MARK: - Results List

    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Section header
                HStack {
                    Text("RESULTS")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.zinc400)
                        .tracking(2)
                    Spacer()
                }
                .padding(.horizontal, DS.spacingLG)
                .padding(.bottom, DS.spacingSM)

                // Results card
                VStack(spacing: 0) {
                    ForEach(Array(filteredResults.enumerated()), id: \.element.id) { index, item in
                        resultRow(item, isFirst: index == 0)

                        if index < filteredResults.count - 1 {
                            Rectangle()
                                .fill(DS.surfaceContainerLow)
                                .frame(height: 1)
                                .padding(.horizontal, DS.spacingMD)
                        }

                        // Pagination trigger
                        if item.id == filteredResults.last?.id && viewModel.canLoadMore {
                            ProgressView()
                                .tint(DS.primary)
                                .padding()
                                .onAppear {
                                    Task { await viewModel.loadMore() }
                                }
                        }
                    }
                }
                .background(DS.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: DS.radius2XL))
                .shadow(color: DS.adaptiveShadowSM, radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: DS.radius2XL)
                        .stroke(DS.surfaceContainer, lineWidth: 1)
                )
                .padding(.horizontal, DS.spacingLG)
            }
            .padding(.top, DS.spacingSM)
        }
    }

    private func resultRow(_ item: FoodItem, isFirst: Bool) -> some View {
        Button {
            selectedFood = item
            showingFoodDetail = true
        } label: {
            HStack(spacing: DS.spacingMD) {
                // Food icon placeholder
                foodIconView(item)

                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.body(13, weight: .bold))
                        .foregroundStyle(DS.onSurface)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        if let serving = item.servingSize {
                            Text(serving.uppercased())
                                .font(.label(9, weight: .bold))
                                .foregroundStyle(DS.zinc400)
                        }

                        // Highlight macro
                        let highlight = highlightMacro(for: item)
                        Circle()
                            .fill(highlight.color)
                            .frame(width: 4, height: 4)
                        Text(highlight.text.uppercased())
                            .font(.label(9, weight: .bold))
                            .foregroundStyle(DS.zinc400)
                    }
                }

                Spacer()

                // Calories + add button
                VStack(alignment: .trailing, spacing: 2) {
                    Text(item.calories.calorieString)
                        .font(.body(13, weight: .heavy))
                        .foregroundStyle(DS.onSurface)
                    Text("KCAL")
                        .font(.label(9, weight: .bold))
                        .foregroundStyle(DS.zinc400)
                }

                // Add button
                Button {
                    selectedFood = item
                    showingAddFood = true
                } label: {
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isFirst ? DS.onPrimary : DS.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            isFirst ? DS.primary : DS.primary.opacity(0.1),
                            in: Circle()
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    isFirst ? Color.clear : DS.primary.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: isFirst ? DS.primary.opacity(0.2) : .clear,
                            radius: 4, x: 0, y: 2
                        )
                }
                .accessibilityLabel("Add \(item.name) to diary")
            }
            .padding(10)
        }
        .buttonStyle(.plain)
    }

    private func foodIconView(_ item: FoodItem) -> some View {
        let (bg, fg, icon) = foodIconConfig(item)
        return Image(systemName: icon)
            .font(.body.weight(.medium))
            .foregroundStyle(fg)
            .frame(width: 40, height: 40)
            .background(bg, in: RoundedRectangle(cornerRadius: DS.radiusLG))
            .overlay(
                RoundedRectangle(cornerRadius: DS.radiusLG)
                    .stroke(DS.surfaceContainer, lineWidth: 1)
            )
            .shadow(color: DS.adaptiveShadowSM, radius: 2, x: 0, y: 1)
    }

    private func foodIconConfig(_ item: FoodItem) -> (Color, Color, String) {
        switch item.foodType {
        case .recipe:
            return (Color.orange.opacity(0.1), .orange, "fork.knife")
        case .packagedFood:
            return (Color.blue.opacity(0.1), .blue, "shippingbox")
        }
    }

    private struct MacroHighlight {
        let text: String
        let color: Color
    }

    private func highlightMacro(for item: FoodItem) -> MacroHighlight {
        let p = item.protein
        let c = item.carbs
        let f = item.fat
        if p >= c && p >= f {
            return MacroHighlight(text: "\(p.calorieString)g Protein", color: DS.primary)
        } else if c >= p && c >= f {
            return MacroHighlight(text: "\(c.calorieString)g Carbs", color: DS.secondary)
        } else {
            return MacroHighlight(text: "\(f.calorieString)g Fat", color: DS.tertiary)
        }
    }

    // MARK: - Recent Section

    private var recentSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.spacingLG) {
                // Recent header
                HStack {
                    Text("RECENT")
                        .font(.dsLabelSM)
                        .foregroundStyle(DS.zinc400)
                        .tracking(2)
                    Spacer()
                }
                .padding(.horizontal, DS.spacingLG)

                // Placeholder for recent items
                VStack(spacing: DS.spacingLG) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 36))
                        .foregroundStyle(DS.zinc400)
                    Text("Your recent foods will appear here")
                        .font(.dsBodySM)
                        .foregroundStyle(DS.zinc400)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, DS.spacing3XL)
            }
            .padding(.top, DS.spacingSM)
        }
    }
}
