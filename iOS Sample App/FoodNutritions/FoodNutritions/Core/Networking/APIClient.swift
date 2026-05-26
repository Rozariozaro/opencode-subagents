import Foundation

final class APIClient: Sendable {
    static let shared = APIClient()

    private let baseURL: String
    private let session: URLSession
    private let _token = TokenStorage()

    private init() {
        self.baseURL = AppConfig.baseURL
        self.session = URLSession.shared
    }

    // MARK: - Auth Token

    func setAuthToken(_ token: String) {
        _token.set(token)
    }

    // MARK: - GET

    func get<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        let request = try buildRequest(path: path, method: "GET", queryItems: queryItems)
        return try await execute(request)
    }

    // MARK: - POST

    func post<T: Decodable, U: Encodable>(
        path: String,
        body: U
    ) async throws -> T {
        var request = try buildRequest(path: path, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request)
    }

    /// POST without auth header (used for login).
    func postNoAuth<T: Decodable, U: Encodable>(
        path: String,
        body: U
    ) async throws -> T {
        var request = try buildRequest(path: path, method: "POST", authenticated: false)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request)
    }

    // MARK: - PATCH

    func patch<T: Decodable, U: Encodable>(
        path: String,
        body: U
    ) async throws -> T {
        var request = try buildRequest(path: path, method: "PATCH")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request)
    }

    // MARK: - DELETE

    /// DELETE request. PocketBase returns 204 No Content on success,
    /// so this method returns Void instead of decoding a response body.
    func delete(path: String) async throws {
        let request = try buildRequest(path: path, method: "DELETE")
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(
                NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            )
        }

        #if DEBUG
        debugLog(request: request, statusCode: httpResponse.statusCode, data: data)
        #endif

        guard (200...299).contains(httpResponse.statusCode) else {
            throw mapHTTPError(statusCode: httpResponse.statusCode, data: data)
        }
    }

    // MARK: - Private

    private func buildRequest(
        path: String,
        method: String,
        queryItems: [URLQueryItem] = [],
        authenticated: Bool = true
    ) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 15

        if authenticated, let token = _token.get() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(
                NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            )
        }

        #if DEBUG
        debugLog(request: request, statusCode: httpResponse.statusCode, data: data)
        #endif

        guard (200...299).contains(httpResponse.statusCode) else {
            throw mapHTTPError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Error Mapping

    private func mapHTTPError(statusCode: Int, data: Data) -> APIError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        default:
            let message = String(data: data, encoding: .utf8)
            return .httpError(statusCode: statusCode, message: message)
        }
    }

    // MARK: - Debug Logging

    private func debugLog(request: URLRequest, statusCode: Int, data: Data) {
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        let bodyPreview: String
        if let body = data.prefix(500) as Data?,
           let text = String(data: body, encoding: .utf8) {
            bodyPreview = text
        } else {
            bodyPreview = "<\(data.count) bytes>"
        }
        print("[API] \(method) \(url) → \(statusCode) | \(bodyPreview)")
    }
}

// MARK: - Thread-safe token storage

private final class TokenStorage: @unchecked Sendable {
    private var token: String?
    private let lock = NSLock()

    func set(_ value: String) {
        lock.lock()
        defer { lock.unlock() }
        token = value
    }

    func get() -> String? {
        lock.lock()
        defer { lock.unlock() }
        return token
    }
}
