# OpenSheaf identity

The identity pairs the lettering **OpenSheaf** with the sheaf-inspired dot
mark, placed to the left of it. Two rectangular cards meet at an overlapping
corner on a shared dot lattice of 9 columns and 10 rows: small dots mark each
card's unshared area, larger dots mark the shared corner, each point drawn
only once. There are 72 dots, 12 of them in the overlap.

## Assets

- `opensheaf-logo.svg`: dot mark left, lettering right; viewBox
  `2.36 1.879 186.752 43.337`, aspect ratio **4.309:1**.
- `opensheaf-logo-dark.svg`: the same in white, for dark backgrounds.
- `opensheaf-wordmark.svg`: lettering only; viewBox
  `53.764 6.864 135.348 36.036`, aspect ratio **3.756:1**.
- `opensheaf-symbol.svg`: dot mark only; viewBox `2.36 1.879 39.28 43.337`.
- `favicon.svg`: the dot mark on a square viewBox, automatically switching
  between black and white according to the browser's colour preference.
- `opensheaf-logo.png` (2192 px wide) and `opensheaf-logo.pdf` (vector):
  copies of the logo for TeXmacs and other document tools.
- `opensheaf-banner.jpg`: the logo over a photograph, 1920 × 1080, the
  header of the README on GitHub.

All the vector assets are self-contained, with no font download or external
service required at runtime. The logo and the symbol use black ink, the dark
logo white ink, and the standalone wordmark `currentColor`; each SVG keeps its
colour in one `fill` attribute. The shared viewBox origin keeps the parts in
register: the mark and the lettering overlay the logo exactly. Preserve
proportions and clear space (at least two dot pitches, about a fifth of the
logo's height, on every side).

## Credits

The lettering is outlined from **Cormorant Garamond** by Christian Thalmann
(Catharsis Fonts), from the Cormorant project:
https://github.com/CatharsisFonts/Cormorant. Copyright 2015 the Cormorant
Project Authors. The SIL Open Font License is retained in
`CormorantGaramond-LICENSE.txt`.

The photograph of the banner is from [Unsplash](https://unsplash.com), used
under the [Unsplash License](https://unsplash.com/license).
