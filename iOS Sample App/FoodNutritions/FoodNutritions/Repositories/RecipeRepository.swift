import Foundation

struct RecipeRepository {
    private let client = APIClient.shared
    private static let perPage = 30

    /// Original non-paginated search (returns first page only). Kept for backward compatibility.
    func search(query: String) async throws -> [Recipe] {
        let result = try await search(query: query, page: 1)
        return result.items
    }

    /// Paginated search — returns items + pagination metadata.
    func search(query: String, page: Int) async throws -> PaginatedResult<Recipe> {
        let safeQuery = Self.sanitize(query)
        let filter = "(name~'\(safeQuery)')"
        let response: PocketBaseResponse<Recipe> = try await client.get(
            path: "/api/collections/recipes/records",
            queryItems: [
                URLQueryItem(name: "filter", value: filter),
                URLQueryItem(name: "fields", value: "id,name,calories,protein,fat,carbs,fiber,serving_size,source,food_code,ingredients,sugar,saturated_fat,cholesterol_mg,sodium_mg,calcium_mg,iron_mg"),
                URLQueryItem(name: "perPage", value: "\(Self.perPage)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
        return PaginatedResult(
            items: response.items,
            page: response.page,
            totalPages: response.totalPages,
            totalItems: response.totalItems
        )
    }

    // MARK: - Filter Sanitization

    private static func sanitize(_ value: String) -> String {
        value.replacingOccurrences(of: "'", with: "\\'")
    }
}
