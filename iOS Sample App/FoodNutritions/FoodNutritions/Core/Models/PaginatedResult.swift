import Foundation

/// Lightweight result wrapper exposing items and pagination state from a `PocketBaseResponse`.
/// Repositories return this so that ViewModels can decide whether to show a "Load More" control.
struct PaginatedResult<T: Sendable> {
    let items: [T]
    let page: Int
    let totalPages: Int
    let totalItems: Int

    var hasMore: Bool { page < totalPages }
}
