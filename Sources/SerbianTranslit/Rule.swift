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
        let loweredDigraphs = (data.digraphs ?? [:]).reduce(into: [String: String]()) { acc, kv in
            acc[kv.key.lowercased()] = kv.value
        }
        self.letters = LetterMap(digraphs: loweredDigraphs, singles: data.singles ?? [:])
        self.skip = SkipPolicy(
            nonNativeLetters: Set((data.nonNativeLetters ?? "").map { $0 }),
            neverRoman: Set((data.neverRoman ?? []).map { $0.uppercased() })
        )
        self.preChar = data.preChar ?? [:]
        let extras = data.extrasInWord ?? ""
        let escaped = NSRegularExpression.escapedPattern(for: extras)
        // swiftlint:disable:next force_try
        self.wordSplitRe = try! NSRegularExpression(pattern: "(\\s+|[^\\w\(escaped)]+)")
    }

    func apply(_ text: String) -> String {
        // macOS clipboard hands out NFD; the base ASCII would leak through
        // the digraph lookup and drop its combining mark.
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

        // Ð/Đ and ð/đ collapse before we look at case, so the character
        // count of the word is stable for the case-pattern step.
        let normalised = normalisePreChar(word)

        let pattern = CasePattern.detect(normalised)
        // Brands/acronyms (`iPhone`, `mRNA`) lose their casing on lowercase
        // round-trip. Two-char MIXED (`lJ`, `nJ`) is the digraph edge case.
        if pattern == .mixed && normalised.count > mixedCaseCutoff {
            return normalised
        }

        return pattern.apply(to: letters.convert(normalised.lowercased()))
    }

    private func normalisePreChar(_ word: String) -> String {
        guard !preChar.isEmpty else { return word }
        return String(word.map { ch -> Character in
            if let mapped = preChar[String(ch)], let first = mapped.first {
                return first
            }
            return ch
        })
    }

    // Python's re.split with a capture group returns the delimiters between
    // matches; this reproduces that behaviour.
    private func splitPreservingDelimiters(_ text: String) -> [String] {
        let ns = text as NSString
        var parts: [String] = []
        var lastEnd = 0
        let range = NSRange(location: 0, length: ns.length)
        wordSplitRe.enumerateMatches(in: text, options: [], range: range) { match, _, _ in
            guard let match = match else { return }
            let start = match.range.location
            if start > lastEnd {
                parts.append(ns.substring(with: NSRange(location: lastEnd, length: start - lastEnd)))
            }
            parts.append(ns.substring(with: match.range))
            lastEnd = start + match.range.length
        }
        if lastEnd < ns.length {
            parts.append(ns.substring(from: lastEnd))
        }
        return parts.filter { !$0.isEmpty }
    }
}
