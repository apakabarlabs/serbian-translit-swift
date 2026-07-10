import Foundation

/// Serbian (`srp`) script conversion, Cyrillic ↔ Latin.
public enum SRP {
    /// Serbian Latin → Cyrillic.
    public static func toCyr(_ text: String) -> String {
        Table.srpLatToCyr.apply(text)
    }

    /// Serbian Cyrillic → Latin.
    public static func toLat(_ text: String) -> String {
        Table.srpCyrToLat.apply(text)
    }
}
