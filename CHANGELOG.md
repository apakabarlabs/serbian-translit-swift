# Changelog

## 0.1.0

First release. Swift port of serbian-translit-python v0.4.1; same YAML
rule table and test corpus, same behaviour.

### Added

- Serbian and Montenegrin script conversion in both directions:
  `SRP.toCyr` / `SRP.toLat` / `CNR.toCyr` / `CNR.toLat`.
- Case preservation for digraphs (`Nj` in title case, `NJ` in caps).
- Quoted regions and URL/email/hashtag/@-mention tokens preserved verbatim.
- Roman numerals stay Latin.
- Words with non-native letters (`w`, `x`, `y`, `q`) skipped as foreign.
- Đ variants (`Đ`, `đ`, `Ð`, `ð`) map to `Ђ`/`ђ`.
- NFD input normalised to NFC before transliteration.
- Requirements: Swift 6.0, iOS 15+, macOS 12+.
