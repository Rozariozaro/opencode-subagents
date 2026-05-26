import Foundation

@MainActor
@Observable
final class AddFoodViewModel {
    let food: FoodItem
    let userId: String
    let selectedDate: Date
    var quantity: Double = 1.0
    var mealType: MealType = .breakfast

    private(set) var isLogging = false
    private(set) var errorMessage: String?
    private(set) var didLogSuccessfully = false
    var showError: Bool = false

    private let repository = FoodLogRepository()

    init(food: FoodItem, userId: String, selectedDate: Date = Date()) {
        self.food = food
        self.userId = userId
        self.selectedDate = selectedDate
    }

    // MARK: - Computed Macros (scaled by quantity)

    var scaledCalories: Double { food.calories * quantity }
    var scaledProtein: Double { food.protein * quantity }
    var scaledCarbs: Double { food.carbs * quantity }
    var scaledFat: Double { food.fat * quantity }
    var scaledFiber: Double { food.fiber * quantity }

    // MARK: - Log Food

    func logFood() async -> FoodLog? {
        isLogging = true
        errorMessage = nil

        let log = FoodLog(
            id: nil,
            user: userId,
            date: selectedDate.pocketBaseDateString,
            mealType: mealType.rawValue,
            foodType: food.foodType.rawValue,
            foodId: food.foodId,
            foodName: food.name,
            quantity: quantity,
            calories: scaledCalories,
            protein: scaledProtein,
            carbs: scaledCarbs,
            fat: scaledFat,
            fiber: scaledFiber
        )

        do {
            let created = try await repository.createLog(log)
            didLogSuccessfully = true
            isLogging = false
            return created
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isLogging = false
            return nil
        }
    }
}
