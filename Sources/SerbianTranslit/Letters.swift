import Foundation

struct LetterMap {
    static let digraphWidth = 2
    static let singleWidth = 1
    private static let lookupWidths = [digraphWidth, singleWidth]

    let digraphs: [String: String]
    let singles: [String: String]

    func convert(_ lowered: String) -> String {
        let chars = Array(lowered)
        var result = ""
        var i = 0
        while i < chars.count {
            let (replacement, width) = matchAt(chars, i: i)
            result += replacement
            i += width
        }
        return result
    }

    private func matchAt(_ chars: [Character], i: Int) -> (String, Int) {
        for width in Self.lookupWidths {
            if i + width > chars.count { continue }
            let candidate = String(chars[i..<(i + width)])
            if let replacement = digraphs[candidate] {
                return (replacement, width)
            }
        }
        let ch = String(chars[i])
        return (singles[ch] ?? ch, Self.singleWidth)
    }
}
