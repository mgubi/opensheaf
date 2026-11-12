# OpenSheaf

OpenSheaf is an open format for archives of scholarly documents and for
collections of them: a lean alternative to arXiv and to the usual publication
infrastructure. An archive is a git repository of plain files, served as a
static website: documents are stored with their sources in the Oxford Common
File Layout (OCFL), described with DataCite metadata, matched one to one with
Zenodo deposits, and fixed by content hashes. Collections are versioned
objects too, and compose across archives without copying.

The specification is at <https://opensheaf.org> (also `sheaf.pub`).

**Status:** version 0.1, a draft. It is experimental and may change in
incompatible ways before version 1.0.

**First archive:** <https://mgubi.opensheaf.org>
(repository [mgubi/papers](https://github.com/mgubi/papers)).

## Files

- `index.tm`: the specification, a TeXmacs document (edit it in TeXmacs);
  `index.html` is its HTML export, the page served at opensheaf.org.
- `notes-meta.ts`: the TeXmacs style package of the page.
- `resources/`: stylesheets, scripts and fonts of the page.
- `tools/build.py`: exports `index.tm` to `index.html` with TeXmacs. It needs
  the `notes` and `max-html` TeXmacs plugins, linked in `~/.TeXmacs/plugins`.
- `CNAME`: the GitHub Pages custom domain, `opensheaf.org`.

## Licence

The text of the specification is licensed under the
[Creative Commons Attribution 4.0 International licence](https://creativecommons.org/licenses/by/4.0/)
(CC BY 4.0). The tools and style files are licensed under the GNU General
Public License, version 3 or later. The fonts in `resources/fonts/` keep their
own licence (SIL Open Font License).
