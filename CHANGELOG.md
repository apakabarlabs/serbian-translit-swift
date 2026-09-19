# Changelog

## 0.4.2

### Tests

- The shared corpus now covers quoted punctuation inside protected URLs and
  single-letter Serbian words that resemble Roman numerals.

## 0.4.1

First release. Version numbered `0.4.1` to lock-step with
[serbian-translit-python](https://github.com/apakabarlabs/serbian-translit-python)
v0.4.1: the two share the same YAML rule table and test corpus, so
matching `major.minor` means matching behaviour.

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
