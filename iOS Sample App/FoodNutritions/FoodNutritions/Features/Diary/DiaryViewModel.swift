import Foundation

@MainActor
@Observable
final class DiaryViewModel {
    private(set) var logs: [FoodLog] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var errorMessage: String?

    var selectedDate = Date()
    let calorieGoal = AppConfig.defaultCalorieGoal

    private let repository = FoodLogRepository()
    private var userId: String = ""

    // MARK: - Pagination State

    private var currentPage = 1
    private(set) var canLoadMore = false

    // MARK: - Computed Properties

    var mealGroups: [MealType: [FoodLog]] {
        Dictionary(grouping: logs) { log in
            MealType(rawValue: log.mealType) ?? .snack
        }
    }

    var totalCalories: Double {
        logs.reduce(0) { $0 + $1.calories }
    }

    var totalProtein: Double {
        logs.reduce(0) { $0 + $1.protein }
    }

    var totalCarbs: Double {
        logs.reduce(0) { $0 + $1.carbs }
    }

    var totalFat: Double {
        logs.reduce(0) { $0 + $1.fat }
    }

    var remainingCalories: Double {
        calorieGoal - totalCalories
    }

    var calorieProgress: Double {
        guard calorieGoal > 0 else { return 0 }
        return min(totalCalories / calorieGoal, 1.0)
    }

    func caloriesForMeal(_ mealType: MealType) -> Double {
        (mealGroups[mealType] ?? []).reduce(0) { $0 + $1.calories }
    }

    // MARK: - Actions

    func setUserId(_ id: String) {
        userId = id
    }

    /// Loads the first page of logs, replacing the current list.
    func loadLogs() async {
        guard !userId.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        currentPage = 1

        do {
            let result = try await repository.fetchLogs(userId: userId, date: selectedDate, page: 1)
            logs = result.items
            currentPage = result.page
            canLoadMore = result.hasMore
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Loads the next page and appends to the existing list.
    func loadMoreLogs() async {
        guard canLoadMore, !isLoadingMore, !userId.isEmpty else { return }
        isLoadingMore = true

        do {
            let nextPage = currentPage + 1
            let result = try await repository.fetchLogs(userId: userId, date: selectedDate, page: nextPage)
            logs.append(contentsOf: result.items)
            currentPage = result.page
            canLoadMore = result.hasMore
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingMore = false
    }

    /// Optimistically adds a log to the local list (called after successful POST).
    func addLogLocally(_ log: FoodLog) {
        logs.append(log)
    }

    /// Optimistically removes a log from the local list (called after successful DELETE).
    func removeLogLocally(_ logId: String) {
        logs.removeAll { $0.id == logId }
    }
}
