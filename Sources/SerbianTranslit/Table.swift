import Foundation
import SwiftEmbed

struct RulesFile: Codable {
  let rules: [RuleData]
}

enum Table {
  private static let byPair: [String: Rule] = {
    let data: RulesFile = Embedded.getYAML(Bundle.module, path: "rules.yaml")
    var dict: [String: Rule] = [:]
    for entry in data.rules {
      let key = "\(entry.source)|\(entry.target)"
      dict[key] = Rule(data: entry)
    }
    return dict
  }()

  static let srpLatToCyr = requiredPair("srp-latn|srp-cyrl")
  static let srpCyrToLat = requiredPair("srp-cyrl|srp-latn")
  static let cnrLatToCyr = requiredPair("cnr-latn|cnr-cyrl")
  static let cnrCyrToLat = requiredPair("cnr-cyrl|cnr-latn")

  private static func requiredPair(_ key: String) -> Rule {
    guard let rule = byPair[key] else {
      preconditionFailure("Missing bundled transliteration rule: \(key)")
    }
    return rule
  }
}
