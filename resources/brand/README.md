# OpenSheaf identity proposal

The identity pairs **OpenSheaf** in **Geist Serif Regular** with the
sheaf-inspired diagonal dot mark, placed to the left of the lettering.
Two rectangular cards meet at an overlapping corner on a shared circle lattice.
Small circles (radius 5.7) mark each card's unshared area. Larger circles
(radius 8.2) mark the shared corner, with each point drawn only once.
There are 72 circles, including 12 in the overlap; the grid spacing is 20.

## Assets

- `opensheaf-logo.svg`: dot mark left, lettering right; viewBox
  `-8 -4 548 120`, aspect ratio **4.567:1**.
- `opensheaf-wordmark.svg`: lettering only; viewBox
  `0 14 432 88`, aspect ratio **4.909:1**.
- `opensheaf-symbol.svg`: dot mark only; viewBox `0 0 192 212`.
- `favicon.svg`: the same dot mark on a square viewBox, automatically switching
  between black and white according to the browser's colour preference.

All assets are self-contained vectors, with no font download or external
service required at runtime. The logo and symbol use black ink; the standalone wordmark uses
`currentColor`. Invert an external image for a dark background. Apply ink opacity in the surrounding page rather
than changing the SVG geometry. Preserve proportions and clear space.

The lettering is outlined from **Geist Serif Regular**, PostScript name
`GeistSerif-Regular`, version **1.003**, OS/2 weight class **400**. A subtle
0.35-unit inset per edge at a 100-unit type size lightens the strokes. Tracking
is -1.5 units; the outlines are scaled to 85%. Official source:
https://github.com/vercel/geist-font/blob/main/fonts/GeistSerif/ttf/GeistSerif-Regular.ttf

## Licence and use

The logo, the symbol, the wordmark and the favicon in this folder are
licensed under the
[Creative Commons Attribution 4.0 International licence](https://creativecommons.org/licenses/by/4.0/)
(CC BY 4.0, text in `LICENSES/CC-BY-4.0.txt` at the root of the
repository): the files may be copied and redistributed, with attribution to
the OpenSheaf project. The licence grants no rights to the name OpenSheaf or
to the logo as marks: their use is governed by
[`TRADEMARKS.md`](../../TRADEMARKS.md) (pointing to OpenSheaf with the
unmodified logo needs no permission; suggesting endorsement, or a modified
logo, does). The lettering is outlined from Geist Serif, whose licence
follows.

Copyright 2026 The Geist Project Authors (https://github.com/vercel/geist-font).
The SIL Open Font License is retained in `GeistSerif-LICENSE.txt`.

## Mathematical reference

Two local pieces agree on their intersection and form one coherent whole,
a visual reference to the compatibility and gluing in a sheaf. The cards are
rectangular dot grids offset diagonally; circle sizes have two distinct values.
This is a visual interpretation, rather than a literal mathematical diagram.

The wordmark and its placement are preserved. SVG roots have explicit numeric
width and height attributes for native image import. PNG and PDF copies of
the complete logo are provided for TeXmacs and other document tools.
