import Foundation

struct AuthRepository {
    private let client = APIClient.shared

    struct LoginRequest: Encodable {
        let identity: String
        let password: String
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        try await client.postNoAuth(
            path: "/api/collections/users/auth-with-password",
            body: LoginRequest(identity: email, password: password)
        )
    }
}
