import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case forbidden
    case notFound
    case httpError(statusCode: Int, message: String?)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .unauthorized:
            "Authentication required. Please sign in again."
        case .forbidden:
            "You do not have permission to access this resource."
        case .notFound:
            "The requested resource was not found."
        case .httpError(let code, let message):
            "Server error (\(code)): \(message ?? "Unknown error")"
        case .decodingError(let error):
            "Failed to process server response: \(error.localizedDescription)"
        case .networkError(let error):
            "Network error: \(error.localizedDescription)"
        }
    }
}
