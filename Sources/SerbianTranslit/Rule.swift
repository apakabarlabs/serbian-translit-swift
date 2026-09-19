import Foundation

struct RuleData: Codable {
  let source: String
  let target: String
  let digraphs: [String: String]?
  let preChar: [String: String]?
  let singles: [String: String]?
  let extrasInWord: String?
  let nonNativeLetters: String?
  let neverRoman: [String]?

  enum CodingKeys: String, CodingKey {
    case source
    case target
    case digraphs
    case preChar = "pre_char"
    case singles
    case extrasInWord = "extras_in_word"
    case nonNativeLetters = "non_native_letters"
    case neverRoman = "never_roman"
  }
}

private let mixedCaseCutoff = 2

struct Rule {
  let letters: LetterMap
  let skip: SkipPolicy
  let preChar: [String: String]
  let wordSplitRe: NSRegularExpression

  init(data: RuleData) {
    var loweredDigraphs: [String: String] = [:]
    for (source, target) in data.digraphs ?? [:] {
      loweredDigraphs[source.lowercased()] = target
    }
    self.letters = LetterMap(digraphs: loweredDigraphs, singles: data.singles ?? [:])
    self.skip = SkipPolicy(
      nonNativeLetters: Set((data.nonNativeLetters ?? "").map { $0 }),
      neverRoman: Set((data.neverRoman ?? []).map { $0.uppercased() })
    )
    self.preChar = data.preChar ?? [:]
    let extras = data.extrasInWord ?? ""
    let escaped = NSRegularExpression.escapedPattern(for: extras)
    self.wordSplitRe = compiledRegex("(\\s+|[^\\w\(escaped)]+)")
  }

  func apply(_ text: String) -> String {
    let normalised = text.precomposedStringWithCanonicalMapping

    let protection = ProtectedRegions()
    let protected = protection.stashAll(normalised)

    let rendered = splitPreservingDelimiters(protected).map(convertPart).joined()
    return protection.restore(rendered)
  }

  private func convertPart(_ part: String) -> String {
    if part.contains(where: { $0.isLetter }) {
      return convertWord(part)
    }
    return part
  }

  private func convertWord(_ word: String) -> String {
    if skip.isForeign(word) || skip.isRomanNumeral(word) {
      return word
    }

    let normalised = normalisePreChar(word)

    let pattern = CasePattern.detect(normalised)
    if pattern == .mixed && normalised.count > mixedCaseCutoff {
      return normalised
    }

    return pattern.apply(to: letters.convert(normalised.lowercased()))
  }

  private func normalisePreChar(_ word: String) -> String {
    guard !preChar.isEmpty else { return word }
    return String(
      word.map { character -> Character in
        if let mapped = preChar[String(character)], let first = mapped.first {
          return first
        }
        return character
      })
  }

  private func splitPreservingDelimiters(_ text: String) -> [String] {
    let source = text as NSString
    var parts: [String] = []
    var lastEnd = 0
    let range = NSRange(location: 0, length: source.length)
    wordSplitRe.enumerateMatches(in: text, options: [], range: range) { match, _, _ in
      guard let match = match else { return }
      let start = match.range.location
      if start > lastEnd {
        parts.append(source.substring(with: NSRange(location: lastEnd, length: start - lastEnd)))
      }
      parts.append(source.substring(with: match.range))
      lastEnd = start + match.range.length
    }
    if lastEnd < source.length {
      parts.append(source.substring(from: lastEnd))
    }
    return parts.filter { !$0.isEmpty }
  }
}
