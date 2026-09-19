import Foundation

/// Deterministic Serbian (`srp`) script conversion between Cyrillic and Latin.
public enum SRP {
  /// Converts Serbian Latin text to Cyrillic while preserving protected regions.
  ///
  /// Digraphs and regular lowercase, title-case, and uppercase words are converted as
  /// units. Scheme URLs containing `://`, lowercase `www.` links, email addresses,
  /// hashtags, mentions, words containing `w`, `x`, `y`, or `q`, and mixed-case words
  /// longer than two characters are not transliterated. Canonical uppercase Roman-numeral
  /// tokens of at least two characters are also skipped, except `MI`, `LI`, `VI`, and
  /// `CI`, which are treated as Serbian words. Text paired with `"…"`, `„…"`, `„…”`,
  /// `„…“`, `“…”`, or `«…»` is protected.
  /// Protected text is still normalized to NFC with the rest of the input.
  ///
  /// - Parameter text: Serbian Latin text, optionally mixed with protected content.
  /// - Returns: The converted text in NFC normalization form.
  public static func toCyr(_ text: String) -> String {
    Table.srpLatToCyr.apply(text)
  }

  /// Converts Serbian Cyrillic text to Latin while preserving protected regions.
  ///
  /// Scheme URLs containing `://`, lowercase `www.` links, email addresses, hashtags,
  /// mentions, and mixed-case words longer than two characters are not transliterated.
  /// Canonical uppercase Roman-numeral tokens of at least two characters are also skipped.
  /// Text paired with `"…"`, `„…"`, `„…”`, `„…“`, `“…”`, or `«…»` is protected.
  /// Protected text is still normalized to NFC.
  ///
  /// - Parameter text: Serbian Cyrillic text, optionally mixed with protected content.
  /// - Returns: The converted text in NFC normalization form.
  public static func toLat(_ text: String) -> String {
    Table.srpCyrToLat.apply(text)
  }
}
