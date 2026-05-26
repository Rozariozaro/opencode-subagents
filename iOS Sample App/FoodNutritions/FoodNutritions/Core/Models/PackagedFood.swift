import Foundation

struct PackagedFood: Codable, Identifiable, Sendable {
    let id: String
    let type: String?
    let codeOrBarcode: String?
    let name: String
    let brand: String?
    let calories: Double?
    let carbs: Double?
    let protein: Double?
    let fat: Double?
    let fiber: Double?
    let calciumMg: Double?
    let ironMg: Double?
    let sodiumMg: Double?
    let source: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, brand, calories, carbs, protein, fat, fiber, source
        case codeOrBarcode = "code_or_barcode"
        case calciumMg = "calcium_mg"
        case ironMg = "iron_mg"
        case sodiumMg = "sodium_mg"
    }
}
