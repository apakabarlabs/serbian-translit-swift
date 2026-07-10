import Foundation

struct SkipPolicy {
    let nonNativeLetters: Set<Character>
    let neverRoman: Set<String>

    func isForeign(_ word: String) -> Bool {
        guard !nonNativeLetters.isEmpty else { return false }
        return word.contains { nonNativeLetters.contains($0) }
    }

    func isRomanNumeral(_ word: String) -> Bool {
        Roman.isNumeral(word) && !neverRoman.contains(word.uppercased())
    }
}
