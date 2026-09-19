import Foundation

func compiledRegex(
  _ pattern: String,
  options: NSRegularExpression.Options = []
) -> NSRegularExpression {
  do {
    return try NSRegularExpression(pattern: pattern, options: options)
  } catch {
    preconditionFailure("Invalid bundled regular expression: \(error)")
  }
}
