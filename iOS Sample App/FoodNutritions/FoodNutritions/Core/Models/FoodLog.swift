import Foundation

struct FoodLog: Codable, Identifiable, Sendable {
    var id: String?
    let user: String
    let date: String
    let mealType: String
    let foodType: String
    let foodId: String
    let foodName: String
    let quantity: Double
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double

    enum CodingKeys: String, CodingKey {
        case id, user, date, quantity, calories, protein, carbs, fat, fiber
        case mealType = "meal_type"
        case foodType = "food_type"
        case foodId = "food_id"
        case foodName = "food_name"
    }
}
