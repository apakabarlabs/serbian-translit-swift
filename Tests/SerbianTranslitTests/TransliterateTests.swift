import Foundation
import SwiftEmbed
import Testing

@testable import SerbianTranslit

struct TransliterateTests {

  struct TestSection: Codable {
    let section: String
    let source: String
    let target: String
    let cases: [TestCase]
  }

  struct TestCase: Codable {
    let text: String
    let want: String
  }

  struct TestData: Codable {
    let tests: [TestSection]
  }

  struct LoadedTestCase: CustomTestStringConvertible {
    let section: String
    let source: String
    let target: String
    let text: String
    let want: String

    var testDescription: String {
      "[\(section)] \(source) → \(target): \(text)"
    }
  }

  static var testData: TestData {
    Embedded.getYAML(Bundle.module, path: "tests.yaml")
  }

  static var testCases: [LoadedTestCase] {
    testData.tests.flatMap { section in
      section.cases.map { testCase in
        LoadedTestCase(
          section: section.section,
          source: section.source,
          target: section.target,
          text: testCase.text,
          want: testCase.want
        )
      }
    }
  }

  private func convert(source: String, target: String, text: String) -> String {
    switch (source, target) {
    case ("srp-latn", "srp-cyrl"): return SRP.toCyr(text)
    case ("srp-cyrl", "srp-latn"): return SRP.toLat(text)
    case ("cnr-latn", "cnr-cyrl"): return CNR.toCyr(text)
    case ("cnr-cyrl", "cnr-latn"): return CNR.toLat(text)
    default: fatalError("no route for \(source) → \(target)")
    }
  }

  @Test(arguments: testCases)
  func transliterate(testCase: LoadedTestCase) {
    let result = convert(source: testCase.source, target: testCase.target, text: testCase.text)
    let route = "\(testCase.source) → \(testCase.target)"
    let comparison = "got '\(result)', want '\(testCase.want)'"
    #expect(
      result == testCase.want,
      "[\(testCase.section)] \(route) '\(testCase.text)': \(comparison)"
    )
  }

  @Test
  func emptyInputReturnsEmpty() {
    #expect(SRP.toCyr("") == "")
    #expect(SRP.toLat("") == "")
    #expect(CNR.toCyr("") == "")
    #expect(CNR.toLat("") == "")
  }
}
