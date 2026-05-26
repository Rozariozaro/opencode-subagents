import Foundation

struct Recipe: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let source: String?
    let foodCode: String?
    let ingredients: String?
    let servingSize: String?
    let calories: Double?
    let protein: Double?
    let fat: Double?
    let carbs: Double?
    let fiber: Double?
    let sugar: Double?
    let saturatedFat: Double?
    let cholesterolMg: Double?
    let sodiumMg: Double?
    let energyKj: Double?
    let freesugarG: Double?
    let sfaMg: Double?
    let mufaMg: Double?
    let pufaMg: Double?
    let calciumMg: Double?
    let phosphorusMg: Double?
    let magnesiumMg: Double?
    let potassiumMg: Double?
    let ironMg: Double?
    let copperMg: Double?
    let seleniumUg: Double?
    let chromiumMg: Double?
    let manganeseMg: Double?
    let molybdenumMg: Double?
    let zincMg: Double?
    let vitaUg: Double?
    let viteMg: Double?
    let vitd2Ug: Double?
    let vitd3Ug: Double?
    let vitk1Ug: Double?
    let vitk2Ug: Double?
    let folateUg: Double?
    let vitb1Mg: Double?
    let vitb2Mg: Double?
    let vitb3Mg: Double?
    let vitb5Mg: Double?
    let vitb6Mg: Double?
    let vitb7Ug: Double?
    let vitb9Ug: Double?
    let vitcMg: Double?
    let carotenoidsUg: Double?
    let servingsUnit: String?

    enum CodingKeys: String, CodingKey {
        case id, name, source, ingredients, calories, protein, fat, carbs, fiber, sugar
        case foodCode = "food_code"
        case servingSize = "serving_size"
        case saturatedFat = "saturated_fat"
        case cholesterolMg = "cholesterol_mg"
        case sodiumMg = "sodium_mg"
        case energyKj = "energy_kj"
        case freesugarG = "freesugar_g"
        case sfaMg = "sfa_mg"
        case mufaMg = "mufa_mg"
        case pufaMg = "pufa_mg"
        case calciumMg = "calcium_mg"
        case phosphorusMg = "phosphorus_mg"
        case magnesiumMg = "magnesium_mg"
        case potassiumMg = "potassium_mg"
        case ironMg = "iron_mg"
        case copperMg = "copper_mg"
        case seleniumUg = "selenium_ug"
        case chromiumMg = "chromium_mg"
        case manganeseMg = "manganese_mg"
        case molybdenumMg = "molybdenum_mg"
        case zincMg = "zinc_mg"
        case vitaUg = "vita_ug"
        case viteMg = "vite_mg"
        case vitd2Ug = "vitd2_ug"
        case vitd3Ug = "vitd3_ug"
        case vitk1Ug = "vitk1_ug"
        case vitk2Ug = "vitk2_ug"
        case folateUg = "folate_ug"
        case vitb1Mg = "vitb1_mg"
        case vitb2Mg = "vitb2_mg"
        case vitb3Mg = "vitb3_mg"
        case vitb5Mg = "vitb5_mg"
        case vitb6Mg = "vitb6_mg"
        case vitb7Ug = "vitb7_ug"
        case vitb9Ug = "vitb9_ug"
        case vitcMg = "vitc_mg"
        case carotenoidsUg = "carotenoids_ug"
        case servingsUnit = "servings_unit"
    }
}
