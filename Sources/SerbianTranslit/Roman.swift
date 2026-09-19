import Foundation

enum Roman {
  private static let canonical: NSRegularExpression = {
    // swiftlint:disable:next force_try
    try! NSRegularExpression(
      pattern: "^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$"
    )
  }()

  private static let minLength = 2

  static func isNumeral(_ word: String) -> Bool {
    guard word.count >= minLength else { return false }
    let range = NSRange(word.startIndex..., in: word)
    return canonical.firstMatch(in: word, options: [], range: range) != nil
  }
}
