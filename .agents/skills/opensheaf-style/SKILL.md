---
name: opensheaf-style
description: The look and brand of the OpenSheaf site and documents. Use before changing page layout, the hero, typography, colours, the logo or other brand assets, or the build of the pages.
---

# OpenSheaf style

## How the pages are made

- Edit only the Markdown sources: `README.md` (home page and GitHub README),
  `opensheaf-specification-0.1.md`, `FAQ.md`.
- `tools/md2tm.py` converts them to TeXmacs; `tools/build.py` runs it and
  exports each `.tm` to `.html`. Never edit the `.tm` or `.html` files; commit
  them regenerated, together with their sources.
- The build needs the `notes` and `max-html` plugins of the author's website
  repository (`mgubi/mgubi.github.io`, `plugins/`), linked in
  `~/.TeXmacs/plugins` or given with `TEXMACS_PLUGINS`. Do not copy them into
  this repository.
- Layout belongs to TeXmacs: the converter (hero, spacing) and `notes-meta.ts`
  (the style). `resources/opensheaf.css` only mirrors that look on the web,
  because the HTML export carries no fonts or colours.

## The look

- Serif throughout; headings in the serif of the text, regular weight.
- Monochrome: charcoal `#292825` on warm off-white `#faf9f6`; dark theme
  muted ivory `#dedcd6` on `#1c1c1b`; print black on white. No colour
  accents: links, titles and code take the ink of the text.
- Reading column at most 800px, 16px root size, line height 1.55, compact
  paragraphs. The theme control sits after the content.
- The first paragraph of a page, in *italics* in the Markdown, becomes the
  abstract.

## Hero

- Home page: the first line of `README.md`,
  `<!-- site hero: resources/brand/opensheaf-logo.svg -->`, puts the logo at
  two fifths of the column (`0.4par`) with `vspace` 4fn above and 5fn below.
  GitHub hides the comment and shows the banner on the next line.
- Other pages open with their `# Title`; no images above it.

## Brand assets (`resources/brand/`)

- Logo (mark left, lettering right), symbol (mark only), wordmark (lettering
  only), favicon, PNG and vector PDF of the logo, banner. Their README gives
  the geometry.
- Black ink only (`opensheaf-logo-dark.svg` is white; the wordmark uses
  `currentColor`); one `fill` per SVG. On the dark theme the logo is
  inverted by `opensheaf.css`.
- Keep proportions and clear space (two dot pitches on every side); do not
  recolour, outline, stretch or re-space the dots or the letters.

## Fonts

- Lettering: outlined from Cormorant Garamond (SIL OFL,
  `CormorantGaramond-LICENSE.txt`); no font file is loaded for it.
- Web pages: Source Serif Pro for text and headings, Source Code Pro for code,
  from `resources/fonts/source/` via the site stylesheet.
- TeXmacs documents and PDF: the fonts of the `notes` style.
- New fonts or images need their licence and credit in the brand README.
