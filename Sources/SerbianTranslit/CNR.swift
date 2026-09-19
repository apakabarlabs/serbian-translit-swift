import Foundation

/// Montenegrin (`cnr`) script conversion, Cyrillic ↔ Latin.
public enum CNR {
  /// Montenegrin Latin → Cyrillic.
  public static func toCyr(_ text: String) -> String {
    Table.cnrLatToCyr.apply(text)
  }

  /// Montenegrin Cyrillic → Latin.
  public static func toLat(_ text: String) -> String {
    Table.cnrCyrToLat.apply(text)
  }
}
