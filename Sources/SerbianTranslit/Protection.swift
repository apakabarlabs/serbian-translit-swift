import Foundation

final class ProtectedRegions {
  private static let quotedRe: NSRegularExpression = {
    // swiftlint:disable:next force_try
    try! NSRegularExpression(
      pattern: "„[^„”“]*?[”“\"]|«[^«»]*?»|“[^“”]*?”|\"[^\"]*?\"",
      options: [.dotMatchesLineSeparators]
    )
  }()

  private static let tokenRe: NSRegularExpression = {
    let stop = "\\s<>"
    let pattern =
      "[a-zA-Z][a-zA-Z0-9+.\\-]*://[^\(stop)]+"
      + "|www\\.[^\(stop)]+"
      + "|[^\(stop)@]+@[^\(stop)@]+\\.[^\(stop)@]+"
      + "|#[^\(stop)#@]+"
      + "|@[^\(stop)#@]+"
    // swiftlint:disable:next force_try
    return try! NSRegularExpression(pattern: pattern)
  }()

  private var slots: [(key: String, original: String)] = []
  private var counter = 0
  private let prefix: String

  init() {
    self.prefix = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
  }

  func stashAll(_ text: String) -> String {
    let step1 = Self.replaceAll(text, regex: Self.tokenRe, replacer: stash)
    return Self.replaceAll(step1, regex: Self.quotedRe, replacer: stash)
  }

  func restore(_ text: String) -> String {
    var result = text
    for slot in slots {
      result = result.replacingOccurrences(of: slot.key, with: slot.original)
    }
    return result
  }

  private func stash(_ match: String) -> String {
    let key = "\u{0000}Q_\(prefix)_\(counter)\u{0000}"
    slots.append((key: key, original: match))
    counter += 1
    return key
  }

  private static func replaceAll(
    _ text: String,
    regex: NSRegularExpression,
    replacer: (String) -> String
  ) -> String {
    let source = text as NSString
    var result = ""
    var lastEnd = 0
    let range = NSRange(location: 0, length: source.length)
    regex.enumerateMatches(in: text, options: [], range: range) { match, _, _ in
      guard let match = match else { return }
      let start = match.range.location
      if start > lastEnd {
        result += source.substring(with: NSRange(location: lastEnd, length: start - lastEnd))
      }
      let matched = source.substring(with: match.range)
      result += replacer(matched)
      lastEnd = start + match.range.length
    }
    if lastEnd < source.length {
      result += source.substring(from: lastEnd)
    }
    return result
  }
}
