---
name: opensheaf-spec
description: The concepts of the OpenSheaf specification (archives, objects, document and object versions, catalogues and selections, pins, mirrors, accepted copies, withdrawal, extensions) and how to change the specification, its schemas, the FAQ and the use cases. Use before editing any of them, or answering questions about the format.
---

# The OpenSheaf specification

The source is `opensheaf-specification-0.1.md` (one line per paragraph).
This is a map of it; the text is authoritative. Section numbers below are
those of the text.

## What it is

A format for archives of scholarly documents, as plain files served as a
static website, and for collections of them across archives. It defines
only what its two standards leave open:

- **OCFL 1.1** for storage: objects, versions, inventories, SHA-512 digests;
- **DataCite 4.7** for description (`datacite.json`, in the form of the
  DataCite REST API attributes);
- OpenSheaf itself: discovery, collections, provenance (`object.json`),
  withdrawal, profiles and extensions.

## Concepts

- **Archive** (sections 5, 6): one owner's objects, with one storage root
  and one discovery document `opensheaf.json` at its base URL. Named by an
  **archive identifier** (a `tag:` URI, section 6.2) that does not change
  when the archive moves. An archive is not an object and has no versions;
  it is custody and naming, and the single writer of its objects.
- **Discovery document** `opensheaf.json` (6.1): a mutable map, never a
  witness: format, archive identifier, name, storage root, layout
  (`0002-flat-direct-storage-layout`), `objects` (each with `id`, `kind`,
  `head`, `inventorySha512`, `status`, and `mirrorOf` for mirrors),
  `profiles`; SHOULD `mainCollection`, `contact`, `extensions`; MAY
  `mirrors`, `tombstones`, `keys`, `feed`. Everything it says is checked
  against the storage root.
- **Object** (3, 7): an OCFL object, of kind `document` or `collection`.
  Its identifier is a short chosen name (6.3: `^[a-z0-9]+(-[a-z0-9]+)*$`,
  at most 64 characters), never reused. Globally, an object is the pair
  (archive identifier, object identifier).
- **Object version** (`v1`, `v2`, ...): an OCFL version; changes at every
  change of the object. Every version folder holds its inventory and
  checksum (7.1). The inventory records who deposited a version and when.
- **Document version** (7.3): the version of the work, numbered by the
  archive from 1 without gaps; changes exactly when the document's own
  files change. External labels (arXiv `v3`) go in `external`.
- **Description-only version** (7.3): an object version that keeps the files
  of an existing document version and changes only the description, the
  state or the notices (a DOI, a stage, a notice, a withdrawal).
- **History** (7.3): the order of the document versions in the work; by
  number, unless `history` in `object.json` lists object versions (needed
  when a version is deposited out of order). **Current version**: the last
  entry of the history of the head; dates never order versions.
- **Notices** (7.3, 9): statements about a version (an erratum), added by
  description-only versions, never removed.
- **Note** (9): a short `text`, or a file (`path`, `mediaType`), or both;
  used for change notes, notices, withdrawals, `sourcesMissing`.
- **Collection** (7.4, 10): an object whose versions hold `members.json`.
  Two kinds (`type` in `members.json`):
  - **catalogue**: keeps objects whole and is impartial about their
    versions; each member pins an object up to a version (`version`,
    `inventorySha512`) and MAY `follow: "latest"`. An archive's main
    collection is a catalogue of its own documents.
  - **selection**: vets particular revisions; each member pins a
    **revision set** (`revisions`: `documentVersion`, `version`,
    `inventorySha512`); it changes only by an act of its curator, a new
    version of the selection.
  Collections are objects, so they nest and cross archives.
- **Pin** (3, 10.2): (object version, SHA-512 of that version's inventory).
  It fixes every byte of the version and of the versions before it, so
  collections are hash trees across archives; any copy whose bytes match a
  pin is as good as the original (6.4).
- **Mirror** (10.4): a byte-for-byte copy of a whole object of another
  archive, the same object (`mirrorOf`), updated only by copying the
  original's versions; allowed only if the licences of all versions allow
  redistribution.
- **Accepted copy** (10.5): a selection's own document holding exactly the
  files of one vetted revision (not `datacite.json` and `object.json`),
  with the source and its pin in `external`; a new object, never a mirror.
- **Withdrawal** (11.1): a description-only version with `status`
  `withdrawn`; the content stays. **Takedown** (11.2): the object is deleted
  and a **tombstone** stays in the discovery document (11.3).
- **Witnesses** (13.2): signatures and OpenTimestamps proofs of inventory
  checksum files, in `extensions/opensheaf-witnesses/` of the object; not
  part of any version.
- **Profiles** (4, appendices A-C): `zenodo` (DOIs from Zenodo), `texmacs`,
  `website`; declared in `profiles`.
- **Extensions** (4): specifications published separately, named by a URI,
  whose data goes under `extensions` in `object.json`; they never change the
  core, and readers ignore those they do not know.

## The files of an object version

- **Document**: sources (the main source and what it needs), renditions (a
  PDF, recommended), files of notes, `datacite.json`, `object.json`. No HTML
  or other presentation files.
- **Collection**: `datacite.json`, `object.json`, `members.json`.
- `datacite.json` (8): MUST `titles`, `creators`, `publicationYear`,
  `types`, `version` (the document version as a string), `publisher`;
  SHOULD abstract, subjects, dates, `rightsList`, `relatedIdentifiers`.
  Dates: `Issued` (first public appearance, anywhere), `Available` (this
  version first public), `Updated`, `Created`, `Submitted`, `Accepted`,
  `Withdrawn`. Mathematics in titles and abstracts as `$...$` LaTeX.
  Relations (8.1): `IsVersionOf` the concept DOI, `IsNewVersionOf`,
  `IsIdenticalTo` / `IsVariantFormOf` for the same work elsewhere,
  `HasPart` for collection members with DOIs; a document never states the
  collections that include it.
- `object.json` (9): MUST `format`, `specification`, `kind`, `archiveId`,
  `objectId`, `documentVersion`, `status`; documents also `mainSource` and
  `sourceFormat` (or `sourcesMissing`), SHOULD `renditions`, `toolchain`;
  MAY `changes`, `stage` (NISO JAV: `AO`, `SMUR`, `AM`, `P`, `VoR`, ...),
  `history`, `notices`, `licence`, `agreement`, `external`, `withdrawal`,
  `extensions`.
- Metadata files (`datacite.json`, `object.json`, `members.json`,
  inventories, the discovery document) are CC0 (16).

## Verification (14)

A verifier validates the JSON files against the schemas (formats as
assertions), the storage root and objects against OCFL, the discovery
document against the storage root, the rules of sections 7 to 11 on every
object version (document version numbering, `history`, notices kept), and
resolves and checks the pins of the head of every collection, reporting
each member as verified, mismatch, unavailable or removed. Over HTTP it
cannot list folders, so completeness is checked only with the files.

## Schemas

`schemas/opensheaf-archive-0.1.schema.json` (`opensheaf.json`),
`opensheaf-object-0.1.schema.json` (`object.json`),
`opensheaf-collection-0.1.schema.json` (`members.json`), JSON Schema
2020-12, CC0. They do not forbid additional properties (section 12). A
change of a field in the text needs the same change in its schema, and the
other way round.

## Changing the specification

- 0.1 is a draft: changes go into 0.1 itself, with a dated changelog entry
  (17) and the date in the heading updated; no compatibility rules for
  draft names.
- A new field: in the text (where its file is defined), in the schema, in
  the verification rules (14) if it can be checked, in an example
  (appendix E) if it is common, and in the rationale (appendix F) if the
  choice is not obvious.
- A renamed concept: every file of the repository (specification,
  schemas, FAQ, use cases, README), including words split across wrapped
  lines; then the tools and templates in other repositories follow.
- After a change, check the use cases and the FAQ against it: they are
  non-normative but must agree, and the "What happens when ..." table of
  the use cases summarises behaviour.
- Open questions go to issues on `opensheaf/opensheaf.github.io`. Ongoing
  designs (as of November 2026): #13 decentralised holding and keys, #14
  global names, #19 scale, #20 self-certifying names, #21 references and
  applications, #22 external copies and pins, #28 companion documents (an
  extension), #29 private archives, draft/private/public states, review
  processes and anonymous referees. Read the relevant issue before
  touching its topic.

## Design principles to keep

- Standards first: use OCFL and DataCite as they are; invent only what they
  leave open.
- Fixed versions: nothing deposited ever changes; corrections, notices,
  descriptions and withdrawals are new object versions.
- Integrity comes from pins, not places: any matching copy is valid.
- Statements are made by their authors in their own objects: a document
  never states the collections or reviews about it.
- Keeping and vetting are different acts (catalogues and selections; mirrors
  and accepted copies).
- A minimal core: richer relations (summaries and detailed proofs, reviews,
  data and analyses) are built on top, by links, DataCite relations or
  extensions, never by growing the core.
