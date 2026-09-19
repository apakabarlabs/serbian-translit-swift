# ``SerbianTranslit``

Convert Serbian and Montenegrin text between Cyrillic and Latin scripts.

## Convert text

Use ``SRP`` for Serbian or ``CNR`` for Montenegrin. Conversion is deterministic and
normalizes input to NFC before processing it.

```swift
let cyrillic = SRP.toCyr("Njujork")
let latin = SRP.toLat("Њујорк")
let montenegrin = CNR.toCyr("śever")
```

The converter does not transliterate scheme URLs containing `://`, links beginning with
lowercase `www.`, email addresses, hashtags, mentions, Latin words containing `w`, `x`,
`y`, or `q`, or mixed-case words longer than two characters such as `iPhone`. It protects
text in paired straight quotes (`"…"`), Serbian low-opening quotes closed by `"`, `”`, or
`“` (`„…"`, `„…”`, `„…“`), curly quotes (`“…”`), and guillemets (`«…»`). Protection
prevents transliteration, but the entire input is still normalized to NFC.

Canonical uppercase Roman-numeral tokens of at least two characters are skipped. During
Latin-to-Cyrillic conversion, `MI`, `LI`, `VI`, and `CI` are deliberate exceptions
because they are Serbian words, so they are transliterated rather than treated as numerals.

Regular lowercase, title-case, and uppercase words retain their case pattern. The Latin
digraphs `lj`, `nj`, and `dž` convert as single Serbian letters. The ambiguous typewriter
sequence `dj` is not treated as `đ`: for example, `djak` becomes `дјак`. Montenegrin
conversion additionally supports `ś` and `ź` and their Cyrillic combining-accent forms.

## Topics

### Serbian

- ``SRP``
- ``SRP/toCyr(_:)``
- ``SRP/toLat(_:)``

### Montenegrin

- ``CNR``
- ``CNR/toCyr(_:)``
- ``CNR/toLat(_:)``
