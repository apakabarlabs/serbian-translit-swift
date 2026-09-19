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
    var index = 0
    while index < chars.count {
      let (replacement, width) = matchAt(chars, index: index)
      result += replacement
      index += width
    }
    return result
  }

  private func matchAt(_ chars: [Character], index: Int) -> (String, Int) {
    for width in Self.lookupWidths {
      if index + width > chars.count { continue }
      let candidate = String(chars[index..<(index + width)])
      if let replacement = digraphs[candidate] {
        return (replacement, width)
      }
    }
    let character = String(chars[index])
    return (singles[character] ?? character, Self.singleWidth)
  }
}
