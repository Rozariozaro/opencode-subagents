import Foundation

enum FoodType: String, Codable, Sendable {
    case recipe
    case packagedFood = "packaged_food"

    var displayName: String {
        switch self {
        case .recipe: "Recipe"
        case .packagedFood: "Packaged"
        }
    }
}
