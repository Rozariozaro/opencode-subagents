import Foundation

/// Unified wrapper for search results that can be either a Recipe or a PackagedFood.
enum FoodItem: Identifiable, Sendable {
    case recipe(Recipe)
    case packagedFood(PackagedFood)

    var id: String {
        switch self {
        case .recipe(let r): r.id
        case .packagedFood(let p): p.id
        }
    }

    var name: String {
        switch self {
        case .recipe(let r): r.name
        case .packagedFood(let p): p.name
        }
    }

    var calories: Double {
        switch self {
        case .recipe(let r): r.calories ?? 0
        case .packagedFood(let p): p.calories ?? 0
        }
    }

    var protein: Double {
        switch self {
        case .recipe(let r): r.protein ?? 0
        case .packagedFood(let p): p.protein ?? 0
        }
    }

    var carbs: Double {
        switch self {
        case .recipe(let r): r.carbs ?? 0
        case .packagedFood(let p): p.carbs ?? 0
        }
    }

    var fat: Double {
        switch self {
        case .recipe(let r): r.fat ?? 0
        case .packagedFood(let p): p.fat ?? 0
        }
    }

    var fiber: Double {
        switch self {
        case .recipe(let r): r.fiber ?? 0
        case .packagedFood(let p): p.fiber ?? 0
        }
    }

    var foodType: FoodType {
        switch self {
        case .recipe: .recipe
        case .packagedFood: .packagedFood
        }
    }

    var foodId: String { id }

    var servingSize: String? {
        switch self {
        case .recipe(let r): r.servingSize
        case .packagedFood: nil
        }
    }

    var brand: String? {
        switch self {
        case .recipe: nil
        case .packagedFood(let p): p.brand
        }
    }

    // MARK: - Micronutrients (only available for recipes)

    var sodiumMg: Double? {
        switch self {
        case .recipe(let r): r.sodiumMg
        case .packagedFood(let p): p.sodiumMg
        }
    }

    var calciumMg: Double? {
        switch self {
        case .recipe(let r): r.calciumMg
        case .packagedFood(let p): p.calciumMg
        }
    }

    var ironMg: Double? {
        switch self {
        case .recipe(let r): r.ironMg
        case .packagedFood(let p): p.ironMg
        }
    }

    var sugar: Double? {
        switch self {
        case .recipe(let r): r.sugar
        case .packagedFood: nil
        }
    }

    var cholesterolMg: Double? {
        switch self {
        case .recipe(let r): r.cholesterolMg
        case .packagedFood: nil
        }
    }
}
