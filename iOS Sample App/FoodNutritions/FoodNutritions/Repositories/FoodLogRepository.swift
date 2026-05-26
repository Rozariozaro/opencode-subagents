import Foundation

struct FoodLogRepository {
    private let client = APIClient.shared
    private static let perPage = 100

    /// Fetch all logs for a user+date (first page, up to 100). Kept for backward compatibility.
    func fetchLogs(userId: String, date: Date) async throws -> [FoodLog] {
        let result = try await fetchLogs(userId: userId, date: date, page: 1)
        return result.items
    }

    /// Paginated fetch — returns logs + pagination metadata.
    func fetchLogs(userId: String, date: Date, page: Int) async throws -> PaginatedResult<FoodLog> {
        let safeUserId = Self.sanitize(userId)
        // PocketBase stores dates as full datetime ("2026-03-29 00:00:00.000Z"),
        // so exact match on "2026-03-29" fails. Use a day range instead.
        let startOfDay = Self.sanitize(date.pocketBaseDateTimeString)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        let endOfDay = Self.sanitize(nextDay.pocketBaseDateTimeString)
        let filter = "(user='\(safeUserId)' && date>='\(startOfDay)' && date<'\(endOfDay)')"
        let response: PocketBaseResponse<FoodLog> = try await client.get(
            path: "/api/collections/food_logs/records",
            queryItems: [
                URLQueryItem(name: "filter", value: filter),
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

    func createLog(_ log: FoodLog) async throws -> FoodLog {
        try await client.post(
            path: "/api/collections/food_logs/records",
            body: log
        )
    }

    func updateLog(_ log: FoodLog) async throws -> FoodLog {
        guard let id = log.id else {
            throw APIError.invalidURL // no id means we can't target a record
        }
        return try await client.patch(
            path: "/api/collections/food_logs/records/\(id)",
            body: log
        )
    }

    func deleteLog(id: String) async throws {
        try await client.delete(
            path: "/api/collections/food_logs/records/\(id)"
        )
    }

    // MARK: - Filter Sanitization

    /// Escapes single quotes in user-supplied strings to prevent PocketBase filter injection.
    private static func sanitize(_ value: String) -> String {
        value.replacingOccurrences(of: "'", with: "\\'")
    }
}
