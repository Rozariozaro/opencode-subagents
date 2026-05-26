import Foundation

struct PocketBaseResponse<T: Codable>: Codable {
    let page: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
    let items: [T]
}
