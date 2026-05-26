import Foundation

@MainActor
@Observable
final class SearchViewModel {
    var query: String = "" {
        didSet { debounceSearch() }
    }
    private(set) var results: [FoodItem] = []
    private(set) var isSearching = false
    private(set) var isLoadingMore = false
    private(set) var errorMessage: String?

    /// Whether there are more results available from either source.
    var canLoadMore: Bool { canLoadMoreRecipes || canLoadMorePackaged }

    private let recipeRepository = RecipeRepository()
    private let packagedFoodRepository = PackagedFoodRepository()
    private var searchTask: Task<Void, Never>?

    // MARK: - Pagination State

    private var currentQuery: String = ""
    private var recipePage = 1
    private var packagedPage = 1
    private var canLoadMoreRecipes = false
    private var canLoadMorePackaged = false

    // MARK: - Search with Debounce

    private func debounceSearch() {
        searchTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2 else {
            results = []
            isSearching = false
            resetPagination()
            return
        }

        searchTask = Task { [weak self] in
            // 300ms debounce
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await self?.performSearch(trimmed)
        }
    }

    private func performSearch(_ query: String) async {
        isSearching = true
        errorMessage = nil
        resetPagination()
        currentQuery = query

        do {
            async let recipesResult = recipeRepository.search(query: query, page: 1)
            async let packagedResult = packagedFoodRepository.search(query: query, page: 1)

            let (recipesPaginated, packagedPaginated) = try await (recipesResult, packagedResult)

            guard !Task.isCancelled else { return }

            recipePage = recipesPaginated.page
            canLoadMoreRecipes = recipesPaginated.hasMore
            packagedPage = packagedPaginated.page
            canLoadMorePackaged = packagedPaginated.hasMore

            let recipeItems = recipesPaginated.items.map { FoodItem.recipe($0) }
            let packagedItems = packagedPaginated.items.map { FoodItem.packagedFood($0) }

            results = recipeItems + packagedItems
        } catch {
            if !Task.isCancelled {
                errorMessage = error.localizedDescription
                results = []
            }
        }

        isSearching = false
    }

    // MARK: - Load More

    /// Fetches the next page of results from both sources (if available) and appends them.
    func loadMore() async {
        guard canLoadMore, !isLoadingMore, !currentQuery.isEmpty else { return }
        isLoadingMore = true

        do {
            var newRecipeItems: [FoodItem] = []
            var newPackagedItems: [FoodItem] = []

            if canLoadMoreRecipes {
                let nextPage = recipePage + 1
                let result = try await recipeRepository.search(query: currentQuery, page: nextPage)
                recipePage = result.page
                canLoadMoreRecipes = result.hasMore
                newRecipeItems = result.items.map { FoodItem.recipe($0) }
            }

            if canLoadMorePackaged {
                let nextPage = packagedPage + 1
                let result = try await packagedFoodRepository.search(query: currentQuery, page: nextPage)
                packagedPage = result.page
                canLoadMorePackaged = result.hasMore
                newPackagedItems = result.items.map { FoodItem.packagedFood($0) }
            }

            results.append(contentsOf: newRecipeItems + newPackagedItems)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingMore = false
    }

    // MARK: - Clear

    func clearSearch() {
        query = ""
        results = []
        searchTask?.cancel()
        resetPagination()
    }

    private func resetPagination() {
        currentQuery = ""
        recipePage = 1
        packagedPage = 1
        canLoadMoreRecipes = false
        canLoadMorePackaged = false
    }
}
