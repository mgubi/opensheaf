# OpenSheaf

OpenSheaf is an open format for archives of scholarly documents and for
collections of them. Read the
[specification](opensheaf-specification-0.1.md) (version 0.1) and the
[FAQ](FAQ.md), which explains its main choices. The site is
[opensheaf.org](https://opensheaf.org) (also `sheaf.pub`).

**Status:** version 0.1, a draft. It is experimental and may change in
incompatible ways before version 1.0.

**Author:** [Massimiliano Gubinelli](https://mgubi.org/docs/main.html)
(Mathematical Institute, University of Oxford).

## Why

Scholarly documents now live in a few central places: preprint servers such
as arXiv, publishers' platforms, institutional repositories. They work, but
authors depend on them for something that could be much simpler, and what
they keep is often only a PDF.

OpenSheaf proposes a lean common format instead:

- **Archives kept by their authors.** Anyone (a person, a group, an
  institution) can keep an archive of their documents as plain files on a
  static website. No server software, no central service, no permission
  needed.
- **Sources, not only PDFs.** Each deposit keeps the sources of a document
  together with its PDF, so that the work can be read, checked and reused
  in the form in which it was written.
- **Fixed, verifiable versions.** Every version of every document is fixed by
  content hashes and never changes once deposited. Corrections are new
  versions, and anyone can check the whole history from the files alone.
- **Standards, not inventions.** Storage follows the Oxford Common File
  Layout (OCFL), used by research libraries for long-term preservation;
  description follows the DataCite metadata of DOIs. OpenSheaf only adds what
  these leave open.
- **Collections that compose.** A collection, such as the papers of a
  seminar, an editorial selection or a reading list, is itself a versioned
  object pinning its members by digest, also across archives. Selections of
  collections compose without copying, as local pieces glue into a sheaf.
- **Compatible with existing infrastructure.** Documents can also be on
  arXiv, get DOIs and be archived on Zenodo, and be found by Google Scholar;
  none of these is required.

## The name

A *sheaf* is a bundle of papers, or of stalks of wheat tied together. In
mathematics, a sheaf is the structure that attaches data to each part of a
space so that local pieces, which agree where they overlap, glue into a
whole. OpenSheaf works the same way: archives are kept and verified
separately, each by its owner, and collections glue them together without
copying, while every piece stays checkable on its own.

## Taking part

This repository is the place to discuss OpenSheaf and to propose changes:

- **Questions and problems:** open an
  [issue](https://github.com/mgubi/opensheaf/issues), for instance when
  something in the specification is unclear, contradictory or hard to
  implement.
- **Ideas and open-ended discussion:** use the
  [Discussions](https://github.com/mgubi/opensheaf/discussions).
- **Amendments:** propose changes to the text as pull requests on
  [opensheaf-specification-0.1.md](opensheaf-specification-0.1.md), with an
  explanation of the motivation; larger changes are best discussed in an
  issue first.
- **Implementations:** if you build an archive, a tool or a verifier for
  OpenSheaf, open an issue so that it can be added to the list below.

## Implementations

- **Archives**
  - [Papers of Massimiliano Gubinelli](https://mgubi.opensheaf.org)
    (repository [mgubi/papers](https://github.com/mgubi/papers)): the first
    OpenSheaf archive, following version 0.1, with TeXmacs sources, HTML
    versions and PDFs (profile `texmacs`).
- **Tools:** `tools/papers.py` in [mgubi/papers](https://github.com/mgubi/papers),
  which deposits documents as OCFL objects with DataCite and provenance
  metadata, maintains a collection, writes the discovery document and the
  index, and verifies an archive (also with the JSON Schemas and the
  `ocfl-py` validator).

## Files

- [`opensheaf-specification-0.1.md`](opensheaf-specification-0.1.md): the
  specification, in Markdown, its only source.
- [`FAQ.md`](FAQ.md): answers to common questions about the design.
- `README.md`: this text, also the home page of the site.
- `schemas/`: the JSON Schemas of the files defined by the specification
  (`opensheaf.json`, `provenance.json`, `members.json`), also published at
  `https://opensheaf.org/schemas/`.
- `index.tm`/`index.html`, `opensheaf-specification-0.1.tm`/`.html`,
  `faq.tm`/`faq.html`: the pages of the site, generated from the Markdown
  files (for TeXmacs and for the web); do not edit them.
- `notes-meta.ts`: the TeXmacs style package of the page; `resources/`: its
  stylesheets, scripts and fonts.
- `tools/build.py`: converts the Markdown files to TeXmacs
  (`tools/md2tm.py`) and exports them to HTML with TeXmacs. It needs the
  `notes` and `max-html` TeXmacs plugins, linked in `~/.TeXmacs/plugins`.
- `CNAME`: the GitHub Pages custom domain, `opensheaf.org`.

## Licence

The text of the specification and of the FAQ is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International licence](https://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA 4.0): it may be copied and adapted with attribution, and adapted
versions must be shared under the same licence. The JSON Schemas in
`schemas/` are dedicated to the public domain under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/), so that they can
be embedded in any software. The tools and style files are licensed under the GNU
General Public License, version 3 or later. The fonts in `resources/fonts/`
keep their own licence (SIL Open Font License).
