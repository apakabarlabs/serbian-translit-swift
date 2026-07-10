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

    // swiftlint:disable force_unwrapping
    static let srpLatToCyr = byPair["srp-latn|srp-cyrl"]!
    static let srpCyrToLat = byPair["srp-cyrl|srp-latn"]!
    static let cnrLatToCyr = byPair["cnr-latn|cnr-cyrl"]!
    static let cnrCyrToLat = byPair["cnr-cyrl|cnr-latn"]!
    // swiftlint:enable force_unwrapping
}
