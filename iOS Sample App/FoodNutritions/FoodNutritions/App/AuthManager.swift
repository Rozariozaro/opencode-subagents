import Foundation

@MainActor
@Observable
final class AuthManager {
    private(set) var isAuthenticated = false
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var userId: String = ""
    private(set) var userEmail: String = ""

    private let authRepository = AuthRepository()

    func loginOnLaunch() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await authRepository.login(
                email: AppConfig.devEmail,
                password: AppConfig.devPassword
            )
            APIClient.shared.setAuthToken(response.token)
            userId = response.record.id
            userEmail = response.record.email ?? AppConfig.devEmail
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }

        isLoading = false
    }

    func logout() {
        APIClient.shared.setAuthToken("")
        userId = ""
        userEmail = ""
        isAuthenticated = false
    }
}
