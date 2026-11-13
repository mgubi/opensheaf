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

- Serif throughout; headings in the serif of the text, bold.
- A palette on a single hue (blue, 213°), every pair meeting WCAG AA: text
  `#212a36` on tinted paper `#f8fafc`; headings and bold run-in labels
  `#1c3554` (smaller headings `#2d4e76`); links `#265082`, always underlined
  (visited `#476385`); secondary text `#5e6a78`; list bullets `#4375b1` and
  the abstract's left rule `#5e88ba`; code on `#eef2f6` with a `#cfd8e2` rule;
  inline verbatim on a chip `#e9eef3`. Dark theme: text `#d4dbe2` on
  `#151b23`, headings `#b8cfea` / `#a3bcdc`, links `#96bbe9` (visited
  `#9fb5d1`), secondary `#929daa`, bullets `#79a4d8`, rule `#5480b6`, code on
  `#1e252f` with a `#343f4b` rule, chip `#212933`. Print: black on white. No
  other hues; code has no syntax colours.
- The base stylesheet's column, margins, spacing and font sizes (18px root).
- The theme control, one button (a half-lit circle) floating at the top right
  corner of the window, switches
  between light and dark; a visit opens in the default theme, which follows
  the system, and the choice is kept for the browsing session (the tab).
- The first paragraph of a page, in *italics* in the Markdown, becomes the
  abstract.

## Hero

- Home page: the opening `<picture>` block in `README.md` provides light and
  dark logo variants on GitHub. Its `img` source becomes the site hero at 65%
  of the column (`0.65par`), with `vspace` 4fn above and 5fn below.
- A first-line `<!-- site hero: path -->` comment can instead select a site
  hero that differs from an image on the following line.
- Other pages open with their `# Title`; no images above it.

## Brand assets (`resources/brand/`)

- Logo (mark left, lettering right), symbol (mark only), wordmark (lettering
  only), favicon, PNG and vector PDF of the logo. Their README gives the
  geometry.
- The logo and symbol use black ink; `opensheaf-logo-dark.svg` is the white
  variant and the wordmark uses `currentColor`. On the site, the black logo is
  inverted by `opensheaf.css` in the dark theme.
- Preserve proportions and clear space; do not recolour, outline, stretch or
  re-space the dots or the letters.

## Fonts

- Lettering: outlined from Geist Serif Regular (SIL OFL,
  `GeistSerif-LICENSE.txt`); no font file is loaded for it.
- Web pages: Source Serif Pro for text and headings, Source Code Pro for code,
  from `resources/fonts/source/` via the site stylesheet.
- TeXmacs documents and PDF: the fonts of the `notes` style.
- New fonts or images need their licence and credit in the brand README.
