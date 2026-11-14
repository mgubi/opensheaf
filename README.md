<picture>
  <source media="(prefers-color-scheme: dark)" srcset="resources/brand/opensheaf-logo-dark.svg">
  <img alt="OpenSheaf" src="resources/brand/opensheaf-logo.svg" width="440">
</picture>

*OpenSheaf is an open format for archives of scholarly documents and for
collections of them. Read the
[specification](opensheaf-specification-0.1.md) (version 0.1) and the
[FAQ](FAQ.md), which explains its main choices. The site is
[opensheaf.org](https://opensheaf.org) (also `sheaf.pub`).*

> [!WARNING]
> **Draft.** OpenSheaf 0.1 is a draft specification. Until version 1.0, any
> revision may change the format in incompatible ways. Archives and collections made now
> may have to be rebuilt or migrated, and the tools follow the latest draft.
> Do not rely on it yet for anything you cannot redo.

**Source:** the specification and this site are kept in the GitHub repository
[opensheaf/opensheaf.github.io](https://github.com/opensheaf/opensheaf.github.io), which is also the place
to discuss them (see below). The whole ecosystem (the specification, the
tools, the templates and the test data) lives in the GitHub organisation
[opensheaf](https://github.com/opensheaf).

## Why

Scholarly documents now live in a few central places: preprint servers such
as arXiv, publishers' platforms, institutional repositories. Each package is
centralised, opaque and non-composable with the others, and sometimes
preserves only part of the life cycle of a scientific document, for example
only the PDF or only a specific version.

OpenSheaf proposes a lean common format instead:

- **Archives kept by their authors.** Anyone (a person, a group, an
  institution) can keep an archive of their documents as plain files on a
  static website. No server software, no central service, no permission
  needed.
- **Sources, not only PDFs.** Each deposit keeps the sources of a document
  together with its PDF, so that the work can be read, checked and reused
  in the form in which it was written; when the sources are lost, the
  deposit says so, and they can be added later.
- **Fixed, verifiable versions.** Every version of every document is fixed by
  content hashes and never changes once deposited. Corrections are new
  versions, and anyone can check the whole history from the files alone.
- **Standards, not inventions.** Storage follows the Oxford Common File
  Layout (OCFL), used by research libraries for long-term preservation;
  description follows the DataCite metadata of DOIs. OpenSheaf only adds what
  these leave open.
- **Collections that compose.** Catalogues keep documents whole,
  every version, impartially; selections (a journal, a digest, a review
  journal, a reading list) vet particular versions, and change only by an act
  of their curator. Both are versioned objects pinning their members by
  digest, also across archives, and compose without copying, as local pieces glue into a
  sheaf. The [use cases](USE-CASES.md) show how authors, archives and
  selections use them.
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
  [issue](https://github.com/opensheaf/opensheaf.github.io/issues), for instance when
  something in the specification is unclear, contradictory or hard to
  implement.
- **Ideas and open-ended discussion:** use the
  [Discussions](https://github.com/opensheaf/opensheaf.github.io/discussions).
- **Amendments:** propose changes to the text as pull requests on
  [opensheaf-specification-0.1.md](opensheaf-specification-0.1.md), with an
  explanation of the motivation; larger changes are best discussed in an
  issue first.
- **Implementations:** if you build an archive, a tool or a verifier for
  OpenSheaf, open an issue so that it can be added to the list below.

## Implementations

The repositories of the [opensheaf](https://github.com/opensheaf) organisation
on GitHub, and archives made with them.

- **Archives**
  - [Papers of Massimiliano Gubinelli](https://mgubi.org/papers/)
    (repository [mgubi/papers](https://github.com/mgubi/papers)): the first
    OpenSheaf archive, following version 0.1, with TeXmacs sources, HTML
    versions and PDFs (profile `texmacs`).
- **Tools:** [opensheaf-py](https://github.com/opensheaf/opensheaf-py)
  (Python, the `osheaf` command, written as a
  [literate program](https://opensheaf.org/opensheaf-py/) that explains it
  along the specification): deposits documents as OCFL objects with
  DataCite and OpenSheaf metadata (any source with its PDF, or TeXmacs
  sources typeset by the archive), keeps document versions and their
  history, notices and withdrawals, keeps catalogues and selections
  across archives, mirrors objects and keeps accepted copies of vetted
  versions, writes the discovery document and a website with landing pages,
  deposits on Zenodo, imports from arXiv, and verifies an archive (also with
  the JSON Schemas and the `ocfl-py` validator).
- **Templates:** [archive-template](https://github.com/opensheaf/archive-template),
  a ready repository for your own archive of papers, and
  [collection-template](https://github.com/opensheaf/collection-template), for
  a curated collection of papers from any archive (a reading list, written as
  a selection, or a catalogue); both are published with
  GitHub Pages ("Use this template", then `osheaf init`), and both are testing
  grounds that run every workflow of the tools on every push.
- **Test data:** [example-papers](https://github.com/opensheaf/example-papers),
  papers to deposit (invented ones, TeXmacs papers and slides, real openly
  licensed preprints from arXiv and slides from Zenodo) with their metadata.

## Files

- [`opensheaf-specification-0.1.md`](opensheaf-specification-0.1.md): the
  specification, in Markdown, its only source.
- [`FAQ.md`](FAQ.md): answers to common questions about the design.
- [`USE-CASES.md`](USE-CASES.md): how the specification adapts to authors,
  archives and selections (non-normative).
- [`README.md`](https://github.com/opensheaf/opensheaf.github.io/blob/main/README.md): this text, also the home page of the site.
- [`schemas/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/schemas): the JSON Schemas of the files defined by the
  specification, also published at `https://opensheaf.org/schemas/`:
  [`opensheaf-archive-0.1.schema.json`](https://opensheaf.org/schemas/opensheaf-archive-0.1.schema.json)
  for `opensheaf.json`,
  [`opensheaf-object-0.1.schema.json`](https://opensheaf.org/schemas/opensheaf-object-0.1.schema.json)
  for `object.json` and
  [`opensheaf-collection-0.1.schema.json`](https://opensheaf.org/schemas/opensheaf-collection-0.1.schema.json)
  for `members.json`.
- [`index.tm`](https://github.com/opensheaf/opensheaf.github.io/blob/main/index.tm)/[`index.html`](https://github.com/opensheaf/opensheaf.github.io/blob/main/index.html),
  [`opensheaf-specification-0.1.tm`](https://github.com/opensheaf/opensheaf.github.io/blob/main/opensheaf-specification-0.1.tm)/[`.html`](https://github.com/opensheaf/opensheaf.github.io/blob/main/opensheaf-specification-0.1.html),
  [`faq.tm`](https://github.com/opensheaf/opensheaf.github.io/blob/main/faq.tm)/[`faq.html`](https://github.com/opensheaf/opensheaf.github.io/blob/main/faq.html),
  [`use-cases.tm`](https://github.com/opensheaf/opensheaf.github.io/blob/main/use-cases.tm)/[`use-cases.html`](https://github.com/opensheaf/opensheaf.github.io/blob/main/use-cases.html): the pages of the site,
  generated from the Markdown files (for TeXmacs and for the web); do not
  edit them.
- [`notes-meta.ts`](https://github.com/opensheaf/opensheaf.github.io/blob/main/notes-meta.ts): the TeXmacs style package of the
  page; [`resources/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/resources): its stylesheets, scripts and fonts.
- [`resources/brand/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/resources/brand): the logo (dot mark and
  lettering), the symbol, the wordmark and the favicon, as self-contained SVG
  files (with PNG and PDF copies of the logo); see its
  [README](https://github.com/opensheaf/opensheaf.github.io/blob/main/resources/brand/README.md). The lettering is outlined from
  Geist Serif (SIL Open Font License).
- [`tools/build.py`](https://github.com/opensheaf/opensheaf.github.io/blob/main/tools/build.py): converts the Markdown files to
  TeXmacs ([`tools/md2tm.py`](https://github.com/opensheaf/opensheaf.github.io/blob/main/tools/md2tm.py)) and exports them to HTML
  with TeXmacs. It needs the `notes` and `max-html` TeXmacs plugins, linked
  in `~/.TeXmacs/plugins`.
- [`.agents/skills/opensheaf-style/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/.agents/skills/opensheaf-style):
  the conventions of the site's style and build, for people and agents.
- [`CNAME`](https://github.com/opensheaf/opensheaf.github.io/blob/main/CNAME): the GitHub Pages custom domain, `opensheaf.org`.
- [`LICENSE`](https://github.com/opensheaf/opensheaf.github.io/blob/main/LICENSE) and
  [`LICENSES/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/LICENSES): which licence
  covers what, and the texts of the licences.
- [`TRADEMARKS.md`](https://github.com/opensheaf/opensheaf.github.io/blob/main/TRADEMARKS.md): the use of the
  name and the logo.

## Licence

The text of the specification, of the FAQ and of the use cases is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International licence](https://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA 4.0): it may be copied and adapted with attribution, and adapted
versions must be shared under the same licence. The JSON Schemas in
[`schemas/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/schemas) are dedicated to the public domain under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/), so that they can
be embedded in any software. The tools and style files are licensed under the GNU
General Public License, version 3 or later. The fonts in [`resources/fonts/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/resources/fonts)
keep their own licence (SIL Open Font License). The logo and the symbol in
[`resources/brand/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/resources/brand) are licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); the use of the name
OpenSheaf and of the logo as marks is governed by
[`TRADEMARKS.md`](https://github.com/opensheaf/opensheaf.github.io/blob/main/TRADEMARKS.md): describing
or pointing to OpenSheaf needs no permission, suggesting endorsement does. The file
[`LICENSE`](https://github.com/opensheaf/opensheaf.github.io/blob/main/LICENSE) says which licence covers
what; the texts are in
[`LICENSES/`](https://github.com/opensheaf/opensheaf.github.io/tree/main/LICENSES).

**Editor:** [Massimiliano Gubinelli](https://mgubi.org/docs/main.html)
(Mathematical Institute, University of Oxford).
