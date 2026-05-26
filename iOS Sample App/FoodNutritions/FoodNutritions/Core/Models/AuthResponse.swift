import Foundation

struct AuthResponse: Codable, Sendable {
    let token: String
    let record: UserRecord
}

struct UserRecord: Codable, Sendable {
    let id: String
    let email: String?
    let name: String?
}
