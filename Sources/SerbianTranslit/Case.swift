import Foundation

enum CasePattern {
    case lower
    case upper
    case title
    case mixed

    static func detect(_ text: String) -> CasePattern {
        let hasLetter = text.contains { $0.isLetter }
        if hasLetter && text == text.lowercased() {
            return .lower
        }
        if hasLetter && text == text.uppercased() {
            return .upper
        }
        if text.count > 1 {
            let rest = String(text.dropFirst())
            let restHasLetter = rest.contains { $0.isLetter }
            if text.first!.isUppercase && restHasLetter && rest == rest.lowercased() {
                return .title
            }
        }
        return .mixed
    }

    func apply(to text: String) -> String {
        switch self {
        case .lower: return text.lowercased()
        case .upper: return text.uppercased()
        case .title:
            let first = String(text.first!).uppercased()
            return first + text.dropFirst().lowercased()
        case .mixed: return text
        }
    }
}
