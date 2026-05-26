import Foundation

extension Double {
    /// Rounds to specified decimal places and returns as string.
    func rounded(to places: Int = 0) -> String {
        String(format: "%.\(places)f", self)
    }

    /// Returns integer string (no decimals) for calorie display.
    var calorieString: String {
        String(format: "%.0f", self)
    }

    /// Returns one-decimal string for macro display (e.g. "12.5g").
    var macroString: String {
        String(format: "%.1f", self)
    }
}
