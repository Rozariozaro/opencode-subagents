import Foundation

extension Date {
    private static let pocketBaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let pocketBaseDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00.000Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let shortDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    /// Formats date as "YYYY-MM-DD" for PocketBase filter queries.
    var pocketBaseDateString: String {
        Self.pocketBaseDateFormatter.string(from: self)
    }

    /// Formats date as "YYYY-MM-DD 00:00:00.000Z" to match PocketBase stored datetime values.
    var pocketBaseDateTimeString: String {
        Self.pocketBaseDateTimeFormatter.string(from: self)
    }

    /// Formats date for display, e.g. "Mon, Mar 29".
    var shortDisplayString: String {
        Self.shortDisplayFormatter.string(from: self)
    }
}
