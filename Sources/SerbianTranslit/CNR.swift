import Foundation

/// Deterministic Montenegrin (`cnr`) script conversion between Cyrillic and Latin.
public enum CNR {
  /// Converts Montenegrin Latin text to Cyrillic while preserving protected regions.
  ///
  /// In addition to Serbian letters, this converts `ś` and `ź` to the corresponding
  /// Cyrillic base letter followed by U+0301 COMBINING ACUTE ACCENT.
  /// Scheme URLs containing `://`, lowercase `www.` links, email addresses, hashtags,
  /// mentions, words containing `w`, `x`, `y`, or `q`, and mixed-case words longer than
  /// two characters are not transliterated. Canonical uppercase Roman-numeral tokens of
  /// at least two characters are also skipped, except `MI`, `LI`, `VI`, and `CI`. Text
  /// paired with `"…"`, `„…"`, `„…”`, `„…“`, `“…”`, or `«…»` is protected.
  ///
  /// - Parameter text: Montenegrin Latin text, optionally mixed with protected content.
  /// - Returns: The converted text in NFC normalization form.
  public static func toCyr(_ text: String) -> String {
    Table.cnrLatToCyr.apply(text)
  }

  /// Converts Montenegrin Cyrillic text to Latin while preserving protected regions.
  ///
  /// In addition to Serbian letters, this converts the acute-accent sequences for
  /// Montenegrin `ś` and `ź`.
  /// Scheme URLs containing `://`, lowercase `www.` links, email addresses, hashtags,
  /// mentions, and mixed-case words longer than two characters are not transliterated.
  /// Canonical uppercase Roman-numeral tokens of at least two characters are also skipped.
  /// Text paired with `"…"`, `„…"`, `„…”`, `„…“`, `“…”`, or `«…»` is protected.
  /// Protected text is still normalized to NFC.
  ///
  /// - Parameter text: Montenegrin Cyrillic text, optionally mixed with protected content.
  /// - Returns: The converted text in NFC normalization form.
  public static func toLat(_ text: String) -> String {
    Table.cnrCyrToLat.apply(text)
  }
}
