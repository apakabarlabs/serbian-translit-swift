import Foundation

enum Roman {
    // Naive `[IVXLCDM]{2,}` fires on Serbian pronouns (`MI`, `LI`, `CIVIL`);
    // canonical form is the whole point.
    private static let canonical: NSRegularExpression = {
        // swiftlint:disable:next force_try
        try! NSRegularExpression(
            pattern: "^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$"
        )
    }()

    // A single letter (`I`, `V`, `X`) is a word in this context, not a numeral.
    private static let minLength = 2

    static func isNumeral(_ word: String) -> Bool {
        guard word.count >= minLength else { return false }
        let range = NSRange(word.startIndex..., in: word)
        return canonical.firstMatch(in: word, options: [], range: range) != nil
    }
}
