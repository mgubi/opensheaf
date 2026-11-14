# OpenSheaf: an open format for document archives and collections

*Specification, version 0.1 (draft), 14 November 2026. OpenSheaf is a common, open format for archives of scholarly documents and for collections of them, built on the Oxford Common File Layout (OCFL 1.1) and the DataCite Metadata Schema (4.7). This version is experimental and may change in incompatible ways before version 1.0. The text is licensed under CC BY-SA 4.0; the JSON Schemas are dedicated to the public domain under CC0 1.0.*

> [!WARNING]
> **Draft.** This version is a draft. Until version 1.0, any revision may change the format in incompatible ways, and archives and collections made now may have to be rebuilt or migrated. Do not rely on it yet for anything you cannot redo. Changes are listed in the changelog (section 17) and discussed in the [issues](https://github.com/opensheaf/opensheaf.github.io/issues).

## 1. Introduction (non-normative)

OpenSheaf is meant as a lean alternative to arXiv and to the usual publication infrastructure. Any author, group or institution can keep an archive of its documents as plain files, served as a static website, checkable by anyone, and composable with other archives:

- **Sources, not only PDFs.** A deposit keeps the sources of a document with its renditions (a PDF, typically), so that the archive can be read as a website and in the authoring tool.
- **Fixed versions.** Every version of every document is fixed by content hashes and never changes once deposited. Corrections are new versions, and the history can be verified from the files alone.
- **Standards, not inventions.** Storage follows OCFL 1.1 and description follows DataCite 4.7. This specification only defines what these leave open: discovery of an archive, collections, provenance, withdrawal, and the profiles for external services and tools.
- **Composable collections.** A collection is itself a versioned object. It can include documents and collections of other archives, pinned by digest, so that selections (by a seminar, an editorial board, a reading list) compose without copying.
- **External services are optional.** Archives may deposit their documents with a DOI service such as Zenodo, publish them as a website, and keep their files in git; none of this is required by the core of the format.

Answers to common questions about the design are collected in the [FAQ](https://github.com/opensheaf/opensheaf.github.io/blob/main/FAQ.md).

The name: a sheaf is a bundle of papers and, in mathematics, the structure in which local pieces glue into a whole, as archives kept and verified separately compose into collections. The home of the format is `https://opensheaf.org/`. The first OpenSheaf archive is `https://mgubi.org/papers/`; its values appear in the examples.

## 2. Conventions

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, NOT RECOMMENDED, MAY and OPTIONAL in this document are to be interpreted as described in BCP 14 (RFC 2119 and RFC 8174) when, and only when, they appear in all capitals.

Sections marked non-normative, examples, notes and the appendices marked as such are informative. JSON means RFC 8259 JSON encoded in UTF-8 without a byte order mark. URLs are absolute unless stated otherwise; a relative URL in a JSON file is resolved against the URL of that file.

## 3. Terminology

- <dfn>Archive</dfn>: a set of objects kept by one owner (a person, group or institution), with one storage root and one discovery document, identified by an archive identifier.
- <dfn>Archive identifier</dfn>: a URI naming the archive independently of where it is served (section 6).
- <dfn>Base URL</dfn>: the URL at which an archive is currently served, ending with `/`; its discovery document is at `<base URL>opensheaf.json`.
- <dfn>Storage root</dfn>: an OCFL 1.1 storage root holding the objects of the archive.
- <dfn>Object</dfn>: an OCFL object. Its <dfn>kind</dfn> is `document` or `collection`.
- <dfn>Document</dfn>: an object holding one scholarly work (an article, notes, a thesis, a book) with its sources and renditions.
- <dfn>Collection</dfn>: an object holding a list of members. A collection is a catalogue or a selection (section 10.1).
- <dfn>Catalogue</dfn>: a collection that keeps objects whole, impartial about their versions: each member pins an object with all its versions, and may follow it as it grows. An archive's main collection, and the list of objects an archive mirrors, are catalogues.
- <dfn>Selection</dfn>: a collection that vets particular revisions of documents (a journal, a digest, a review journal, a reading list): each member pins a revision set, and earlier or later versions are not part of the selection unless its curator adds them, by a new version of the selection.
- <dfn>Revision</dfn>: a document version, as vetted by a selection, pinned by the object version that held it when it was vetted.
- <dfn>Revision set</dfn>: the revisions of one document vetted by a selection (usually one; more after a correction).
- <dfn>Mirror</dfn>: a copy, in an archive's storage root, of another archive's object, whole and byte for byte (section 10.4).
- <dfn>Accepted copy</dfn>: a document of a selection's archive holding exactly the files of a revision it vetted from another archive (section 10.5).
- <dfn>Object version</dfn>: an OCFL version of an object (`v1`, `v2`, ...). It changes at every change of the object.
- <dfn>Document version</dfn>: the version of the work, a positive integer numbered by the archive, in `object.json` and `datacite.json`. It changes exactly when the document's own files change (section 7.3).
- <dfn>Description-only version</dfn>: an object version that holds an existing document version with its files unchanged, changing only the description, the state or the notices of the object (section 7.3).
- <dfn>History</dfn>: the order of a document's versions in the history of the work (section 7.3).
- <dfn>Current version</dfn>: the document version to which readers are directed: the last in the history.
- <dfn>Note</dfn>: a short text, a file of the content, or both, as used for change notes, notices and withdrawals (section 9).
- <dfn>Member</dfn>: an entry of a collection: an object (in a catalogue) or a revision set of a document (in a selection), of any archive.
- <dfn>Pin</dfn>: the pair (object version, SHA-512 digest of that version's inventory file).
- <dfn>Rendition</dfn>: a file produced from the sources and deposited with them (a PDF, an EPUB).
- <dfn>Presentation</dfn>: files generated from the archive for readers (web pages, indexes, HTML versions of documents). It is never authoritative.
- <dfn>Witness</dfn>: an independent copy or proof: a signature, a timestamp, an external deposit, a software archive snapshot.
- <dfn>Verifier</dfn>: a program that checks an archive or a collection against this specification.

## 4. Conformance

This specification defines the following conformance classes. An archive, object or program conforms to a class if it satisfies every MUST and MUST NOT of the sections listed for it.

- **OpenSheaf archive:** sections 5 to 13 and 16 (section 10 for the collections it contains).
- **OpenSheaf collection:** section 10, in addition to the requirements on objects in sections 7 to 9.
- **OpenSheaf verifier:** sections 12 (as a reader), 14 and 15. Tools that build presentations follow the requirements on presentations in sections 11.1, 15 and appendix C.
- **Profiles**, optional: an archive MAY additionally conform to the Zenodo binding (appendix A), the TeXmacs profile (appendix B) and the website profile (appendix C). A conforming archive MUST state in its discovery document which profiles it follows.
- **Extensions**, optional: an extension is a specification published separately from this one, named by a URI (RECOMMENDED: the `https` URL at which it is published), that records in `object.json` what this specification leaves open, so that tools aware of it can act on it (for instance relations between documents that tools must follow when they copy or verify them). An object version records the data of an extension under `extensions` in its `object.json` (section 9), keyed by the name of the extension; the discovery document SHOULD list the extensions its objects use (section 6.1). Extensions MUST NOT change the meaning of what this specification defines, nor relax its requirements: an archive is conforming, and its objects and collections are read and verified, without knowing any of its extensions. Readers ignore extensions they do not know, as they ignore unknown properties (section 12). The data of an extension is part of the object version, covered by its inventory like the rest of `object.json`, so pins fix it too.

The JSON files defined here (`opensheaf.json`, `object.json`, `members.json`) MUST validate against the JSON Schemas of appendix D for their declared format version.

## 5. Layout

An archive consists of:

- **A discovery document**, `opensheaf.json`, at its base URL (section 6). It is REQUIRED.
- **A storage root**, REQUIRED, conforming to OCFL 1.1, at a URL given by the discovery document. It MUST use the storage layout extension `0002-flat-direct-storage-layout`, so that an object with identifier `<id>` is at `<storage root URL><id>/`. It MAY contain, as loose files allowed by OCFL, a copy of the OCFL specification and of this specification.
- **Witnesses**, OPTIONAL: signatures and timestamp proofs of object versions, in each object's extension folder `extensions/opensheaf-witnesses/`, or under `witnesses/` next to the discovery document (section 13.2).
- **Presentation files**, OPTIONAL, anywhere outside the storage root and `witnesses/` (appendix C).

Because OCFL does not allow directories other than objects and extensions inside a storage root, the storage root SHOULD be a dedicated folder (by convention `ocfl/`), and presentation files MUST NOT be placed inside it.

All files of the discovery document, the storage root and `witnesses/` (if used) MUST be served byte for byte, as stored: no conversion of line endings or character sets, no compression that changes the bytes delivered after decoding. Archives kept in git SHOULD mark these files as binary (for instance with `.gitattributes` lines `ocfl/** -text` and `opensheaf.json -text`). Archives SHOULD be served over HTTPS and SHOULD allow cross-origin requests to these files (`Access-Control-Allow-Origin: *`), so that tools running in a browser can resolve members.

An archive MAY be kept in git and served by any static web server (GitHub Pages, object storage, a university server). A deployment guide, outside this specification, discusses hosting limits and practices.

## 6. Discovery and identity

### 6.1 The discovery document

The discovery document is the JSON file `opensheaf.json` at the base URL of the archive. It MUST contain:

- `format`: `"opensheaf-archive/0.1"`;
- `specification`: the version of this specification the archive follows, `"0.1"`;
- `archiveId`: the archive identifier (section 6.2);
- `name`: a human-readable name;
- `storageRoot`: the URL of the storage root, ending with `/` (relative URLs are allowed);
- `storageLayout`: `"0002-flat-direct-storage-layout"`;
- `objects`: the list of all objects in the storage root, each with `id`, `kind`, `head` (the head object version), `inventorySha512` (the SHA-512 digest of the head inventory, as written in its checksum file) and `status` (`active` or `withdrawn`, section 11); a mirror (section 10.4) also has `mirrorOf`, the archive identifier of the archive whose object it copies.

It MUST also contain `profiles`, the list of profiles followed, from `zenodo`, `texmacs`, `website` (an empty list if none). It SHOULD contain `mainCollection` (the identifier of the collection that lists the archive's own documents), `contact` (a URI) and, if its objects use extensions, `extensions` (their names, section 4). It MAY contain `mirrors` (base URLs of complete copies of the archive), `tombstones` (section 11.3), `keys` (section 13.2) and `feed` (the URL of an Atom feed of new object versions).

The discovery document is mutable: it is rewritten whenever an object is added or changed. It is a map, not a witness: what it states about objects (`objects`: kinds, head versions, digests, status) MUST be verifiable from the storage root. Digests are written in lowercase hexadecimal, here and in every file defined by this specification.

### 6.2 Archive identifiers

An archive identifier is a URI that does not change when the archive moves. It SHOULD be a `tag:` URI (RFC 4151) built from a domain or e-mail address controlled by the owner at the time of creation and a date, for instance `tag:opensheaf.org,2026:mgubi`. A DOI or another persistent URI MAY be used instead. Two different archives MUST NOT use the same archive identifier.

### 6.3 Object identifiers

An object identifier MUST match `^[a-z0-9]+(-[a-z0-9]+)*$` and MUST be at most 64 characters long. It is the OCFL `id` of the object and the name of its folder in the storage root. It MUST be unique in the archive and MUST NOT be reused, also after a takedown. Since it is permanent and appears in every URL of the object, it SHOULD be short (at most 32 characters), readable and chosen by the depositor, and SHOULD NOT be derived mechanically from the title, which may change between versions while the identifier cannot; tools importing documents propose identifiers and the depositor decides. The kind of an object is given by its `object.json`, never by its identifier. Outside the archive, an object is named by the pair (archive identifier, object identifier).

### 6.4 Resolution

To fetch an object version of a member, a client:

- reads the discovery document at the member's archive URL (section 10.2) and fetches `<storageRoot><id>/<version>/inventory.json`;
- if this fails, tries the mirrors listed in the member, then those listed in the archive's discovery document;
- if this fails, MAY use external copies: the files of an external record named in the version's `object.json` (a DOI record), or a software archive snapshot (a SWHID).

Any copy whose bytes match the pinned digest is acceptable: integrity comes from the pin, not from the place.

## 7. Objects

### 7.1 Common rules

Every object MUST be a valid OCFL 1.1 object. Its inventories MUST use `sha512` as digest algorithm. Every object version MUST contain, in its content, the files `object.json` and `datacite.json` at the top level. Every version directory MUST contain a copy of the inventory as of that version, with its checksum file (OCFL makes this a recommendation; OpenSheaf requires it, so that each version can be pinned and fetched on its own). Version directories MUST NOT be zero-padded (`v1`, `v2`, ..., not `v001`), which OCFL allows. OCFL recommends that object identifiers be URIs; OpenSheaf identifiers are short names (section 6.3), so OCFL validators may warn about them.

Each version in the inventory MUST have a `user` with a `name`, and SHOULD have an `address` (an ORCID iD, a `mailto:` URI or another URI identifying the depositor), and MUST have a `message` describing the change. The inventory is the record of deposits: the `created` date and the `user` of an object version are when and by whom it was deposited, and the deposit of a document version is that of the first object version holding it. They are not repeated in `object.json`.

Logical paths MUST be encoded in UTF-8 in Unicode normalisation form C, MUST NOT begin with `/`, and MUST NOT contain `.` or `..` segments.

### 7.2 Documents

A document version contains, at the top level of its content unless a profile says otherwise:

- the **sources**: the main source and every file needed to produce the renditions that is not part of the toolchain (images, bibliography databases, local style files). The main source is named in `object.json`. Sources SHOULD be flat (no sub-folders) when possible. When the sources of a version are not available (for instance a version imported from a service that keeps only its PDF), the version has none, and `object.json` says so (section 9);
- the **renditions**, OPTIONAL but RECOMMENDED: at least a PDF for documents meant to be read and cited, named in `object.json`;
- the files of notes, if any (the change note, notices, a withdrawal; section 9), named in `object.json`;
- `datacite.json` (section 8) and `object.json` (section 9).

HTML versions and other presentation files SHOULD NOT be deposited, since they depend on the presentation and are regenerated when it improves.

### 7.3 Document versions

**Numbering.** Document versions are numbered by the archive, from 1, without gaps, independently of any external numbering: a work whose versions 1, 3 and 4 are available on arXiv has document versions 1, 2 and 3. External labels (arXiv's `v3`) are recorded in `external` (section 9), and presentations SHOULD show them with the document version.

**New versions.** A new document version number is assigned exactly when files of the document's own (sources, renditions, change note) that were not deposited before are added, except when a version without sources is completed (below). An object version holding the same sources, renditions and change note as an earlier document version keeps its number.

**Description-only versions.** A description-only version holds an existing document version, with its files unchanged, and changes only its description (`datacite.json`, such as a DOI, a stage or a link to the published article), the state of the object or its notices. It MAY hold any document version, not only the current one, so that an earlier version can be described after later versions exist; tools otherwise hold the current version. If the object has `history`, its entry for that document version becomes the new object version.

**Completion.** A document version recorded without sources (section 9, `sourcesMissing`) MAY be completed later, keeping its number: the completing object version adds the sources, and MAY add renditions produced from them (for instance a PDF typeset from the added sources, beside the one received), but changes or removes no file of the version; until the sources are complete it keeps `sourcesMissing` and names no main source; the object version that completes them names the main source and removes `sourcesMissing`, after which the version is fixed like any other.

**Other versions.** A version that was not public at the time, such as the manuscript submitted to a journal, deposited later, is a document version like any other. A version published by someone else, such as the journal's version of record, is not a document version of the author's object: it is linked by a relation (section 8.1).

**History.** The order of the document versions in the history of the work is the order of their numbers, unless `object.json` has `history` (section 9): the list, in the order of the work, of the last object version holding each document version. The last object version is used because it carries the most complete description of that document version (a DOI added later, a corrected stage). An object version that deposits a document version out of order (an earlier version found later) MUST write `history`, and once an object version has `history`, every later object version MUST have it. A version whose place in the history is unknown goes just before the current version, and its `object.json` SHOULD say so in its change note. The history is read from the head version; earlier object versions keep the history as it was known when they were made.

**Current version.** The current version of a document is the last entry of the history of its head version (without `history`: the highest document version). The head may hold another document version, after an earlier version is deposited out of order or described by a description-only version; the current version stays where it was. Landing pages, indexes and citations use the current version, not the head; selections vet revisions explicitly (section 10.2).

**Notices.** A notice about a document version (for instance that a theorem of version 2 is wrong as stated, and is corrected in version 3) is written after that version, which cannot change. Notices are added to `notices` in `object.json` (section 9) by description-only versions. A notice present in an object version is present, unchanged, in every later object version; a notice is corrected or withdrawn by a later notice that says so. Presentations showing a document version SHOULD show the current notices about it.

Dates never order document versions and never decide the current version (section 8).

### 7.4 Collections

A collection version contains `datacite.json`, `object.json` and `members.json` (section 10), which states whether the collection is a catalogue or a selection. Its `object.json` declares `kind` `collection`; its document version counts the changes of the member list, and it has none of the fields specific to documents (`mainSource`, `sourceFormat`, `sourcesMissing`, `renditions`, `toolchain`, `changes`, `stage`, `history`, `notices`).

## 8. Description: datacite.json

Every object version MUST contain `datacite.json`, a JSON object with the DataCite 4.7 properties in the form of the `attributes` of a DOI in the DataCite REST API. It is the authoritative description of the object version. It MUST contain:

- `titles`, `creators` (with `name`, and `nameType`; personal names SHOULD also have `givenName` and `familyName`), `publicationYear`, `types` (with `resourceTypeGeneral`), `version` (the document version, as a decimal string without leading zeros, such as `"3"`), and `publisher`.

It SHOULD contain:

- `descriptions` with a `descriptionType` `Abstract`, as plain text with mathematics as below;
- `subjects` with a `subjectScheme` (any scheme; MSC2020 is common in mathematics);
- `dates`, as below;
- `rightsList`: for a licence with an SPDX identifier, that identifier in lower case and the licence URL; for a licence without one, its name in `rights` and the URL identifying it in `rightsUri` (for arXiv's default licence, `http://arxiv.org/licenses/nonexclusive-distrib/1.0/`), which MUST then be present, so that archives record the same licence the same way; or a statement such as "All rights reserved", without URL;
- `language`, `formats` (the media types of the sources and renditions) and `sizes`;
- identifiers of creators (ORCID) and of affiliations (ROR), where they exist;
- `relatedIdentifiers` (section 8.1).

`publisher` is the archive's name, or the external service registering a DOI for the version (appendix A). `publisher` and `affiliation` SHOULD be written as objects (with `name` and, where available, an identifier); readers MUST also accept plain strings.

`doi` and `url` are OPTIONAL: they are present when the version has a DOI. `types` gives the kind of content: `resourceTypeGeneral` from DataCite's list (`Preprint`, `JournalArticle`, `Book`, `Dissertation`, `Report`, `Text`, `Dataset`, `Software`, `Audiovisual`, `Presentation` (slides, since DataCite 4.7) and so on, and `Collection` for collections), with `resourceType` for detail (for instance "Lecture notes"). An author's versions of a work not published elsewhere are `Preprint`, also the accepted manuscript; the stage of a version is given by `stage` in `object.json` (section 9).

**Dates.** Dates are information for readers and services: they never order document versions (section 7.3). Each date type has one meaning:

- `Issued`: the first public appearance of the work, anywhere; the same in every version. RECOMMENDED for documents; tools importing works published elsewhere SHOULD set it.
- `Available`: when this document version first became public, anywhere: for a version imported from another service, its date there; for a version first made public by this archive, the date of its deposit (section 7.1). SHOULD be present.
- `Updated`: the date of the latest description-only version holding this document version; absent when the document version has had none.
- `Created` (when a version was written, for a version not public at the time), `Submitted` and `Accepted` (journal milestones), OPTIONAL.
- `Withdrawn`: the date of a withdrawal, equal to `withdrawal.date` in `object.json` (section 11.1).

**Mathematics in titles and abstracts.** Titles and abstracts are plain text in which mathematics MAY be written in LaTeX between single dollar signs (`$\Phi^4_3$`); a literal dollar sign is written `\$`. The LaTeX SHOULD use only the mathematical commands of LaTeX with the `amsmath` and `amssymb` packages, which common renderers (MathJax, KaTeX) display without the document's preamble; presentations render it, and readers that do not are left with readable LaTeX. Tools importing titles and abstracts from elsewhere SHOULD replace the authors' own macros (such as `\R` or `\be`) with standard LaTeX when their definitions are known, for instance from the preamble of the imported sources, and otherwise keep them unchanged; they MUST NOT invent definitions.

Dates MAY be approximate, as DataCite allows (`2019`, `2019-03`, a range `2018/2019`), with `dateInformation` explaining them (for instance "from file timestamps"); unknown dates are omitted.

### 8.1 Relations

- A document version with a DOI SHOULD have `IsVersionOf` the concept DOI of the document, and `IsNewVersionOf` the DOI of the document version before it in the history (section 7.3), if that version has a DOI. Relations state what was known when a version was described; after a version is deposited out of order, the relation of the version that follows it MAY be corrected by a description-only version.
- The same work published elsewhere SHOULD be linked with `IsIdenticalTo` (same content, for instance an arXiv version) or `IsVariantFormOf` (different content or form).
- A preprint SHOULD be linked to its later published article with `IsVersionOf` the article's DOI, as DataCite recommends; consumers distinguish this relation from the concept DOI by its target. It is added by a description-only version.
- The sources MAY be linked to a software archive snapshot (`relatedIdentifierType` `SWHID`).
- A collection version MUST have `HasPart` for each member (each revision, in a selection) that has a version DOI, pointing to that version DOI. Members without a DOI are listed only in `members.json`.
- A document MUST NOT state the collections that include it: membership is stated only by collections, so that including a document in any collection never changes the document.

## 9. The object: object.json

Every object version MUST contain `object.json`, OpenSheaf's record of the object as of that version: its identity, the structure of its content, its versions and its state. It MUST contain:

- `format`: `"opensheaf-object/0.1"`;
- `specification`: `"0.1"`;
- `kind`: `document` or `collection`;
- `archiveId` and `objectId`;
- `documentVersion`: a positive integer, equal to the `version` of `datacite.json`;
- `status`: `active` or `withdrawn` (section 11).

A document MUST also have `mainSource` (a logical path) and `sourceFormat` (the media type of the main source), and SHOULD have `renditions` (a list of objects with `path`, a logical path, and `mediaType`) and `toolchain` (a list of tools with `name`, `version` and, optionally, `packages`), enough to reproduce the renditions. A document version whose sources are not available instead has `sourcesMissing`, a note (see below) saying why (for instance "arXiv keeps only the PDF of this version"), no `mainSource` and `sourceFormat`, and at least one rendition; a rendition is never presented as a source.

A **note** is an object with `text` (a short plain text), or `path` and `mediaType` (a file of the content of the same object version), or both: the text serves feeds, indexes and external services, the file holds the full statement (with mathematics, or as a PDF). Files of notes are covered by the inventory like every file of the content.

A document MAY contain:

- `changes`: a note saying what changed in this document version, written and deposited with it (like arXiv's comments). It is part of the document version (section 7.3);
- `stage`: the stage of this document version, an object with `scheme` and `value`. For articles the RECOMMENDED scheme is `NISO-JAV`, the NISO Journal Article Versions: `AO` (author's original), `SMUR` (submitted manuscript under review), `AM` (accepted manuscript), `P` (proof), `VoR` (version of record), `CVoR` (corrected version of record), `EVoR` (enhanced version of record). Other kinds of content use other schemes (editions, software releases), named by the archive. A description-only version MAY add or correct it;
- `history`: the list of object versions giving the order of the document versions (section 7.3);
- `notices`: a list of notices (section 7.3), each a note with the `documentVersion` it is about and a `date`.

Any object MAY contain:

- `licence`: a note with the full text or terms of the licence of the content, kept in the package (useful for licences without an SPDX identifier); `rightsList` in `datacite.json` remains the description for readers and services;
- `agreement`: a minimal record that the authors agreed to the deposit and to the licence: `by` (the names of those who agreed, names only), `date`, and `method` (how, for instance "by e-mail"), all three required. It MUST NOT contain e-mail addresses, correspondence or signatures of persons;
- `external`: the external records of this version, each with its `role` (required): `deposit` for a deposit of the version made by the archive (appendix A), `source` for the record it was imported from; the `service` (required, its name), the `record` (required, the URL of the record), the `doi`, the `label` the service gives the version (for instance `v3` on arXiv), and `files`: the files kept there that are not in the content (for a deposit, such as a source archive uploaded instead of the sources) or the files received from it (for a source, as they were received before being unpacked), each with `name` and `sha512` (required), `md5` and `bytes`;
- `withdrawal` (section 11);
- `extensions`: the data of extensions (section 4), an object whose keys are the names of the extensions and whose values are defined by them.

`object.json` is metadata and is placed under CC0 (section 16).

## 10. Collections: members.json

### 10.1 Catalogues and selections

Collections are of two kinds, which differ in how they treat the versions of their members.

- A **catalogue** keeps objects whole and is impartial about their versions. Each member pins an object, with all its versions, and the collection may follow it as it grows, whoever adds the versions: the owner of the object decides what its versions are. An archive's main collection (its own documents) and the list of objects an archive mirrors (section 10.4) are catalogues.
- A **selection** vets particular revisions: a journal its accepted version, a digest or a review journal the version it reviewed, a reading list the version it recommends. Each member pins a revision set, the document versions the curator vetted; earlier and later versions of the same document are not part of the selection, and the selection changes only by an explicit act of its curator, which is a new version of the selection. A selection may also keep its own copies of the revisions it vetted (section 10.5).

Both kinds may contain collections as members (an archive of archives, a selection of issues). `members.json` states the kind.

### 10.2 The member list

A collection version MUST contain `members.json` with:

- `format`: `"opensheaf-collection/0.1"`;
- `type`: `"catalogue"` or `"selection"`;
- `members`: a list, in the order in which the members are presented. This order is authoritative: presentations MUST present members in it.

It MAY contain `order`, the rule by which tools maintaining the collection place members: `manual` (the default: tools append new members and never reorder), `issued-desc` or `issued-asc` (by the members' `Issued` date, then their `Available` date, members with neither last, ties broken by object identifier, so that the result is reproducible).

Each member MUST have:

- `kind`: `document` or `collection`;
- `archive`: the archive identifier of the member's archive;
- `archiveUrl`: the base URL of that archive when the collection version was made;
- `id`: the object identifier.

Each member MAY have `mirrors` (base URLs of archives holding a mirror of the object, section 10.4), `doi` (the version DOI), `conceptDoi` and `cite`, a cached citation (`title`, `creators` as a list of names, `year`, and `issued`, the member's `Issued` date) so that the collection stays readable, and can be ordered, without resolving its members, also if they become unavailable. `cite` is not authoritative.

**Members of a catalogue** MUST have `version`, the pinned object version, and `inventorySha512`, the SHA-512 digest of that version's inventory file. Since the inventory of an object version lists every earlier version, the pin fixes the object with all its versions up to it. A member MAY have `follow`, `"latest"`: a curation setting, not a floating reference. A followed member pins the head of the object when the collection version was made; a member without `follow` keeps the version its curator pinned, which MAY be earlier than the head, until the curator changes it. A tool maintaining the collection reads the member archive's discovery document (or its feed); when the followed object has a new head, the tool writes a new collection version pinning it, whatever the new head holds (a new document version, a description, a notice, a withdrawal): a catalogue does not judge the versions of its members. A withdrawn member stays, and presentations show the withdrawal. Presentations show the current version of each member, read from the history of the pinned version (section 7.3).

**Members of a selection** MUST have `revisions`: a non-empty list of the revisions vetted, in the order of the document's history, each with `documentVersion`, `version` (the object version vetted, which holds that document version: when several do, the last of them when the revision was vetted, which is its entry in the history, section 7.3) and `inventorySha512` (the digest of its inventory file). They MUST NOT have `version`, `inventorySha512` or `follow` themselves. The revision presented as the selection's is the last of the list. A revision pins the object version that was vetted: descriptions and notices added later by the document's archive are not vetted by the selection, and presentations that show them SHOULD say where they come from; a revision keeps its pin in later versions of the selection. If the document is withdrawn in its archive, the revisions stay vetted, and presentations show the withdrawal as section 11.1 asks, saying that it comes from the member's archive. Tools MUST NOT change revision sets on their own: adding a revision (for instance a corrected version, accepted after review), removing one, or adding or removing a member is a new version of the selection, made by its curator, recorded in the inventory (who and when) with a message saying what was decided. A revision set MAY hold several revisions of the same document, for instance a version accepted and its later correction.

Every member is pinned: a collection version states exactly which object versions it contains, whole objects up to a version in a catalogue, revisions in a selection. A collection version therefore fixes everything it contains, also across archives; since a pin fixes an inventory, which fixes all its files, collections are hash trees. Pins cannot form cycles.

### 10.3 Members of other archives

A member may belong to another archive. Nothing is copied: the member is resolved as in section 6.4. A reference (a pin without a copy) needs no permission. Copies are of two kinds: mirrors (section 10.4) and accepted copies (section 10.5).

### 10.4 Mirrors

An archive MAY mirror an object of another archive: copy the whole object, every version with its inventories and files, byte for byte, into its own storage root, under the same identifier (only if no object of its own has it). A mirror is the same object, not a new one: its `object.json` files keep naming the original archive, and the discovery document lists it with `mirrorOf`, the identifier of the original archive (section 6.1). A mirror is brought up to date only by copying the new versions of the original, which is possible because OCFL objects only grow; it MUST NOT be changed otherwise. Mirroring is allowed only if the licences of all the versions copied allow redistribution. A catalogue MAY list a mirror of a member in the member's `mirrors`. An archive that mirrors another archive entirely SHOULD be listed in the `mirrors` of that archive's discovery document, with the agreement of its owner.

Mirrors serve preservation and access (an institution keeping copies of its members' archives, an independent storage site): they are impartial, like catalogues, and carry every version.

### 10.5 Accepted copies

A selection MAY keep its own copy of a revision it vetted, as a document of the selection's archive, called an accepted copy, so that what it vetted stays available whatever happens to the original. Its first document version holds exactly the files of the vetted revision (every file except `datacite.json` and `object.json`), byte for byte; its `object.json` records the source in `external`, with `role` `source`, `service` `OpenSheaf`, `record` the URL of the source object version, `label` the source object identifier and object version (for instance `"paper v2"`), and `files` with one entry, `inventory.json`, whose `sha512` is the pin of the source version; its `datacite.json` describes it with the selection's archive as `publisher`, keeps the relations of the source, and links the source version with `IsIdenticalTo` (a `URL`). Copying requires the right to redistribute only the revision copied.

Later document versions of an accepted copy are acts of the selection's curator (a corrected version accepted, a notice, a withdrawal); the authors' later versions change nothing in it. The selection lists the accepted copy as its member, a member of its own archive; it MAY list the original revision set as well. An accepted copy is not a mirror: it is another object, with its own inventories, and cannot stand for the original in the resolution of a pin (section 6.4), so it is never listed in `mirrors`.

A version that the selection makes itself, such as a journal's typeset version of record, is a document of the selection's archive like any other, with the selection as `publisher`, the authors' agreement in `object.json` (section 9), and relations to the authors' versions (sections 7.3 and 8.1).

### 10.6 Rights

The member list of a collection is placed under CC0. The licence of a collection never extends to its members. Mirrors and accepted copies keep the licences of what they copy.

## 11. Withdrawal and takedown

### 11.1 Withdrawal

A document or collection is withdrawn (for instance retracted by its authors) by a description-only version whose `object.json` has `status` `withdrawn` and a `withdrawal` object with a `date` and a `reason` (a note, section 9), and whose `datacite.json` has the same date as `Withdrawn`. The status belongs to the object, whatever document version its head holds. Its content is kept, its history remains verifiable, and the discovery document lists it with `status` `withdrawn`. Presentations MUST show the withdrawal notice with the document.

### 11.2 Takedown

When content must be removed (by law, or for a breach of rights), the object is deleted from the storage root and a tombstone MUST be added to the discovery document.

### 11.3 Tombstones

A tombstone records `id`, `kind`, `lastVersion`, `inventorySha512` of that version, `date` and `reason` (plain text, since the discovery document has no content files). Identifiers of tombstoned objects MUST NOT be reused. Verifiers report a pin to a tombstoned object as "removed", not as a corruption. External copies (DOI records, snapshots) follow the rules of their services.

Note: OCFL 1.1 has no way to remove files from an object short of deleting and rebuilding it. Physical deletion of files, and the flagging of lost or corrupted files, are accepted as in scope for OCFL version 2, with a tombstone or status recorded in the inventory. When that mechanism is published, a later version of this specification will adopt it for takedowns of single files.

## 12. Versioning of this specification

This specification is versioned MAJOR.MINOR.PATCH, a form of semantic versioning adapted to a format:

- a **major** version (1.0, 2.0) may make incompatible changes;
- a **minor** version (1.1, 1.2) only adds: every file valid under 1.x remains valid under 1.y for y > x, with the same meaning;
- a **patch** version (1.1.1) corrects or clarifies the text without changing any requirement.

Before version 1.0, any change of the minor version (0.1, 0.2, ...) may be incompatible, as semantic versioning allows for initial development.

Every JSON file defined here declares its format version, and the discovery document and every `object.json` declare the version of this specification, both as MAJOR.MINOR only (for instance `"opensheaf-object/0.1"` and `"0.1"`): a patch version never changes what is valid, so files do not record it.

A reader that finds a major version it does not know (or, before 1.0, a minor version it does not know) SHOULD report it and MUST NOT silently treat the files as valid. A reader that finds a later minor version of a major version it knows (from 1.0) reads the files as that major version, ignoring properties it does not know, and SHOULD report the version. For this to work, readers MUST ignore unknown properties in files of a major version they know, and the schemas of this specification do not forbid additional properties.

While a version is a draft, successive drafts are identified by the date in the heading and by the changelog (section 17). The text of each version is published at `https://opensheaf.org/opensheaf-specification-<MAJOR.MINOR>.md` and is not changed after the version is final, except by patch versions, which are listed in its changelog.

## 13. Integrity and authenticity

### 13.1 Integrity

Integrity rests on OCFL digests: every file is fixed by its SHA-512 digest in the inventory, every inventory by its checksum file, and every collection version pins its members by inventory digest. Inventories MAY also record MD5 and SHA-256 digests in their `fixity` block; archives following the Zenodo binding MUST record MD5 (appendix A).

### 13.2 Authenticity and dates

Digests show that files were not changed; they do not show who made them or when. An archive MAY provide, for each object version:

- `<version>.inventory.json.sha512.sig`: a detached signature of the inventory checksum file of that version (`<version>/inventory.json.sha512`), made with a key listed in `keys` of the discovery document (each key with a `type`, such as `openpgp` or `ssh`, and a `url` or `fingerprint`);
- `<version>.inventory.json.sha512.ots`: an OpenTimestamps proof of the same file.

These witness files SHOULD be kept in the object's extension folder `extensions/opensheaf-witnesses/`, so that they travel with the object when it is copied or mirrored. OCFL allows object extension folders, which are not part of any version; the extension name `opensheaf-witnesses` is not yet registered with OCFL, so validators may warn about it. An archive that does not modify object folders after a version is committed MAY instead keep them under `witnesses/<object id>/`, next to the discovery document. Witnesses can be added later, by the owner or by others, and replaced when a proof is upgraded (an OpenTimestamps proof is completed once its attestation is confirmed); they are not covered by the inventory digests, and need not be, since each one is checked directly against the checksum file it names, which the pins fix.

External deposits (appendix A) and software archive snapshots are further witnesses. Archives kept in git MAY also sign their commits or tags, but git hashes are not part of the integrity chain of this specification.

## 14. Verification

A verifier checking an archive MUST:

- validate the discovery document, and every `object.json` and `members.json`, against the schemas of their declared versions, checking formats (dates, URIs) as assertions, which JSON Schema 2020-12 leaves optional;
- validate the storage root and every object against OCFL 1.1 (with a standard OCFL validator or equivalent checks);
- check that the discovery document lists the objects of the storage root with their kinds, head versions, inventory digests and status as their head versions state them, and that no listed object has the identifier of a tombstone; a verifier reading the archive over HTTP cannot list folders, so it checks the listed objects and reports that completeness was not checked, while a verifier with access to the files also checks that no object is missing;
- check the requirements of sections 7 to 11 on every object version, including that `datacite.json` and `object.json` agree on the document version and on the date of a withdrawal, and that `Available`, for a version first made public by the archive, is the date of its deposit (section 7.1);
- check the document versions of each document (section 7.3): object versions with the same document version have the same sources, renditions and change note, except that a version with `sourcesMissing` may be completed by adding files (section 7.3); new numbers follow the rule of new versions, without gaps; `history`, when present, lists distinct document versions, covers all of them, each entry being the last object version holding its document version; no object version after the first one with `history` lacks it; every notice is kept unchanged in every later object version;
- check that each `members.json` has a `type`, that the members of a catalogue have `version` and `inventorySha512`, and that the members of a selection have `revisions` and none of `version`, `inventorySha512` or `follow`, with distinct document versions;
- for the head of each collection, resolve each member (each revision, in a selection) as in section 6.4 and check its pin, and for earlier collection versions check the pins of members of the archive itself (resolving the members of other archives for every earlier collection version is OPTIONAL); for a revision, check that the pinned object version holds the stated document version; report each as verified, mismatch (a copy was found and does not match), unavailable (no copy found) or removed (tombstoned);
- for each mirror (`mirrorOf`), check that its `object.json` files name that archive; for each accepted copy, check that its first document version holds exactly the files of the source version named in `external`, when the source is available.

A verifier SHOULD check the witnesses it finds, the requirements of the profiles the archive declares, and those of the extensions it knows; it SHOULD report the extensions it does not know, which do not make an archive fail verification. It MUST NOT treat the presentation as authoritative. It SHOULD limit the depth and size of the collections it follows, and report when it stops.

## 15. Security considerations

- **Untrusted inventories.** Inventories, logical paths and member lists from other archives are untrusted input. Verifiers MUST reject logical paths that break the rules of section 7.1 (absolute, with `.` or `..` segments, not in Unicode normalisation form C), and SHOULD limit the size of the files they fetch.
- **Archives of sources.** Tools unpacking source archives (appendix A) MUST guard against paths leaving the target folder and against archives that expand to excessive sizes.
- **Presentation.** A website MUST NOT embed HTML of other archives in its own pages; it links to them. Documents' HTML versions are generated by the archive's own tools.
- **Subdomains.** A domain that offers subdomains to archives (as `opensheaf.org` does) MUST remove the DNS records of abandoned archives, to prevent takeover by others.
- **Weak hashes.** SHA-1 (as in most git repositories) and MD5 are not used for integrity: MD5 appears only for comparison with external services.
- **Mutable maps.** The discovery document and presentation files can be changed by whoever controls the server; their statements are only trusted after checking them against the storage root and the pins.

## 16. Privacy and rights

- **Documents.** Each document carries the licence chosen by its authors in `rightsList`. "All rights reserved" is allowed: deposit grants readers access, not reuse.
- **Metadata.** `datacite.json`, `object.json`, `members.json`, inventories and the discovery document are placed under CC0, so that they can be harvested and mirrored freely.
- **Personal data.** Archives record only the personal data needed to describe and cite the work (names, identifiers, affiliations) and the depositor of each version. The depositor is recorded in the inventory (section 7.1). Agreement records are minimal (section 9). A request to erase personal data from an immutable history is handled by a takedown (section 11.2).

## 17. Changelog

- **0.1 (draft), 13 November 2026:** first version.
- **0.1 (draft), 13 November 2026, revision:** collections are archive collections or selections (`type` in `members.json`): an archive collection pins objects whole and may follow them; a selection pins revision sets, the document versions it vetted, and changes only by an act of its curator. A member of an archive collection without `follow` may stay at an earlier version; a revision pins the last object version holding its document version when it was vetted; accepted copies are never listed as mirrors; verifiers resolve remote members for the head of a collection. Mirrors (whole objects, `mirrorOf` in the discovery document) and accepted copies (one vetted revision, as a document of the selection's archive) are defined. `follow` is for archive collections only, and follows the head.
- **0.1 (draft), 14 November 2026, revision:** extensions (section 4): specifications published separately, whose data `object.json` records under `extensions`, keyed by their names; the discovery document should list them; they never change the core, and verifiers report those they do not know.
- **0.1 (draft), 14 November 2026, revision:** the impartial kind of collection is named catalogue (`type` `catalogue` in `members.json`), formerly archive collection, so that it is not confused with an archive.
- **0.1 (draft), 14 November 2026, revision:** `Presentation` (slides) named among the values of `resourceTypeGeneral` (section 8).

## Appendix A. Zenodo binding (normative for archives declaring the profile `zenodo`)

Zenodo issues DataCite DOIs (prefix `10.5281`) and keeps files permanently. Under this binding:

- **Records.** Each document is one Zenodo record with versions: the concept DOI stands for the document, and each document version is one record version with its own DOI, of Zenodo resource type `publication-preprint` (or the type matching `resourceTypeGeneral`). Description-only versions are metadata edits of the existing record version, not new record versions; files they add (such as notices) are not uploaded, since the files of a published record version are fixed.
- **Versions out of order.** Zenodo orders the versions of a record by publication, and its concept DOI resolves to the latest. A document version deposited out of order (section 7.3) is therefore not deposited as a new version of the record; it MAY be deposited as a separate record, with `IsVersionOf` the concept DOI of the document.
- **Files.** The record version holds the content files of the object version as deposited. Zenodo records have no folders: if the sources have sub-folders, or the record would exceed Zenodo's file count, the sources are uploaded as one archive `sources.zip`, built reproducibly (entries in byte order of their names, fixed timestamps, no extra attributes), whose digests are recorded in `object.json` under `external`, in the entry of the deposit (`role` `deposit`). Inventories MUST record MD5 digests in `fixity`, so that the checksums reported by Zenodo can be compared directly.
- **Order of operations.** (1) Create a draft, or a new version of the record (a new version inherits the files of the previous one, which are deleted). (2) Reserve its DOI (Zenodo reserves one with each draft; its sandbox reserves DOIs with the prefix `10.5281` but publishes them with the test prefix `10.5072`). (3) Write `datacite.json` with that DOI and build the object version in a staging area. (4) Upload the files and compare the MD5 checksums reported by Zenodo with the fixity block. (5) Publish. (6) Commit the object version and update the discovery document. If a step fails before publication, the draft is discarded. If publication succeeds and the commit fails, the tool MUST complete the object version from the staging area before any other deposit of that document; it SHOULD hold a lock per document during a deposit, since Zenodo allows one unpublished version per record.
- **Corrections.** Zenodo allows the files of a published version to be changed within 30 days. Archives following this binding MUST NOT use this: a correction is a new document version.
- **Metadata differences.** Zenodo generates its own DataCite record for the DOI: its `url` is the Zenodo landing page, its `publisher` is Zenodo, and it adds relations of its own (such as `IsVersionOf` the concept DOI). `datacite.json` remains authoritative; verifiers tolerate exactly these differences.
- **Collections.** A collection MAY be deposited when it is explicitly released (not at every change), as a record of type `other`, with `members.json` among its files. A Zenodo community MAY group an archive's records for browsing; it is not authoritative.

## Appendix B. TeXmacs profile (normative for archives declaring the profile `texmacs`)

- The main source is a TeXmacs document; `sourceFormat` is `application/x-texmacs` (not a registered media type; it is the type TeXmacs uses).
- `toolchain` records the TeXmacs version and the style packages and plugins used that are not part of the TeXmacs distribution; such packages that belong to the document are deposited with the sources.
- Renditions are produced without regenerating bibliographies or tables of contents, so that the deposited sources, with their stored references, reproduce them even if a bibliography database is not deposited; deposits SHOULD nevertheless include the databases used.
- The title and abstract in `datacite.json` are converted from the TeXmacs document to plain text, with mathematics in LaTeX as in section 8.
- HTML versions are exported by TeXmacs from a copy of the sources with presentation packages added to its style; the deposited sources are not modified.
- An archive whose files are kept inside a website built with TeXmacs' website converter SHOULD place an empty file `.texmacs-noconvert` at its top (honoured by the `max-html` plugin), so that the converter never rewrites deposited files.

## Appendix C. Website profile (normative for archives declaring the profile `website`)

- **Index.** The website has an index page generated from the head version of the main collection. It MAY be split into several pages. A flattened, non-authoritative list for programs that do not read OCFL MAY be published as `catalog.json`.
- **Landing pages.** Each document has one landing page, for its current version (section 7.3), with links to every version in the order of the history, each with its external labels, stage, change note and the notices about it, its renditions and sources, its DOI, and the withdrawal notice if any.
- **Search engines.** Landing pages MUST carry the meta tags read by Google Scholar: `citation_title`, `citation_author` (one per author), `citation_publication_date` (the `Issued` date, or else the `Available` date of the current version), and `citation_pdf_url` on the same host as the PDF; and SHOULD carry schema.org `ScholarlyArticle` JSON-LD and FAIR Signposting links (`cite-as`, `describedby`, `item`, `license`).
- **Feeds.** A feed (section 6.1) lists object versions by their `created` date in the inventory: what is new in the archive.
- **Harvesters.** The website SHOULD publish a `sitemap.xml`, and MAY publish an OAI-PMH static repository file or a ResourceSync description.
- **Citations.** Landing pages SHOULD offer BibTeX and CSL-JSON entries generated from `datacite.json`.
- **Separation.** Presentation files are regenerated from the archive and never edited by hand; they do not embed other archives' HTML.

## Appendix D. JSON Schemas (normative)

The schemas (JSON Schema draft 2020-12) are published with this specification and dedicated to the public domain under CC0 1.0, so that they can be embedded in any software:

- [opensheaf-archive-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-archive-0.1.schema.json) for `opensheaf.json`;
- [opensheaf-object-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-object-0.1.schema.json) for `object.json`;
- [opensheaf-collection-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-collection-0.1.schema.json) for `members.json`.

DataCite publishes its schema as an XML Schema only. `datacite.json` is validated by converting it to DataCite XML (following DataCite's mapping between the REST API's JSON and XML) and validating the result against the DataCite 4.7 XML Schema, together with the requirements of section 8.

## Appendix E. Examples (non-normative)

The values below come from the first archive. Digests are shortened, and the DOIs and ORCID iDs are placeholders.

A discovery document:

```json
{
  "format": "opensheaf-archive/0.1",
  "specification": "0.1",
  "archiveId": "tag:opensheaf.org,2026:mgubi",
  "name": "Papers of Massimiliano Gubinelli",
  "contact": "https://orcid.org/0000-0000-0000-0000",
  "storageRoot": "ocfl/",
  "storageLayout": "0002-flat-direct-storage-layout",
  "mainCollection": "collection-papers",
  "profiles": ["zenodo", "texmacs", "website"],
  "objects": [
    { "id": "fractional-phi42-mass-gap", "kind": "document", "head": "v1",
      "inventorySha512": "9a0c...", "status": "active" },
    { "id": "collection-papers", "kind": "collection", "head": "v1",
      "inventorySha512": "51be...", "status": "active" }
  ]
}
```

An `object.json` of a document version:

```json
{
  "format": "opensheaf-object/0.1",
  "specification": "0.1",
  "kind": "document",
  "archiveId": "tag:opensheaf.org,2026:mgubi",
  "objectId": "fractional-phi42-mass-gap",
  "documentVersion": 1,
  "mainSource": "fractional-phi42-mass-gap.tm",
  "sourceFormat": "application/x-texmacs",
  "renditions": [ { "path": "paper.pdf", "mediaType": "application/pdf" } ],
  "toolchain": [ { "name": "TeXmacs", "version": "2.1.5" } ],
  "stage": { "scheme": "NISO-JAV", "value": "AO" },
  "agreement": { "by": ["P. Duch", "M. Gubinelli"], "date": "2026-11-12", "method": "by e-mail" },
  "external": [ { "role": "deposit", "service": "Zenodo", "record": "https://zenodo.org/records/1234567",
                  "doi": "10.5281/zenodo.1234567" } ],
  "status": "active"
}
```

The `datacite.json` of the same version:

```json
{
  "doi": "10.5281/zenodo.1234567",
  "url": "https://mgubi.org/papers/site/fractional-phi42-mass-gap/fractional-phi42-mass-gap.html",
  "version": "1",
  "types": { "resourceTypeGeneral": "Preprint" },
  "titles": [ { "title": "Mass gap for the fractional Phi^4_2 model" } ],
  "creators": [
    { "name": "Duch, P.", "nameType": "Personal", "givenName": "P.", "familyName": "Duch",
      "affiliation": [ { "name": "Institute of Mathematics, Polish Academy of Sciences" } ] },
    { "name": "Gubinelli, M.", "nameType": "Personal", "givenName": "M.", "familyName": "Gubinelli",
      "affiliation": [ { "name": "Mathematical Institute, University of Oxford" } ] } ],
  "publisher": { "name": "Zenodo" },
  "publicationYear": 2026,
  "dates": [ { "date": "2026-11-12", "dateType": "Issued" },
             { "date": "2026-11-12", "dateType": "Available" } ],
  "rightsList": [ { "rights": "Creative Commons Attribution 4.0 International",
                    "rightsUri": "https://creativecommons.org/licenses/by/4.0/",
                    "rightsIdentifier": "cc-by-4.0", "rightsIdentifierScheme": "SPDX" } ],
  "descriptions": [ { "description": "We present a new, simple ...", "descriptionType": "Abstract" } ],
  "formats": [ "application/x-texmacs", "application/pdf" ],
  "relatedIdentifiers": [
    { "relatedIdentifier": "10.5281/zenodo.1234566", "relatedIdentifierType": "DOI", "relationType": "IsVersionOf" } ]
}
```

The `object.json` of a later version of a document whose arXiv version 2 was found and deposited after version 4 (document versions 1, 2, 3 for arXiv's v1, v3, v4, then 4 for arXiv's v2, placed between 1 and 2 in the history), with a notice about version 2 (arXiv's v3):

```json
{
  "format": "opensheaf-object/0.1",
  ...
  "documentVersion": 3,
  "changes": { "text": "Corrected the proof of Lemma 2; 32 pages." },
  "stage": { "scheme": "NISO-JAV", "value": "AM" },
  "history": [ "v1", "v4", "v2", "v5" ],
  "notices": [ { "documentVersion": 2, "date": "2026-12-01",
                 "text": "Theorem 3 is wrong as stated; corrected in version 3.",
                 "path": "notices/erratum-v2.pdf", "mediaType": "application/pdf" } ],
  "external": [ { "role": "source", "service": "arXiv", "record": "https://arxiv.org/abs/2303.18112v4",
                  "doi": "10.48550/arXiv.2303.18112", "label": "v4" } ],
  "status": "active"
}
```

Object versions `v1` to `v3` deposited document versions 1 to 3; `v4` deposited document version 4 (arXiv's v2) and wrote the history `["v1", "v4", "v2", "v3"]`, so that the current version stayed document version 3 although the head held version 4; `v5`, shown here, is a description-only version adding the notice, which holds the current version again. The current version is document version 3, the last in the history.

A `members.json` of a catalogue: the main collection of an archive, following its documents whole:

```json
{
  "format": "opensheaf-collection/0.1",
  "type": "catalogue",
  "order": "issued-desc",
  "members": [
    { "kind": "document",
      "archive": "tag:opensheaf.org,2026:mgubi",
      "archiveUrl": "https://mgubi.org/papers/",
      "id": "fractional-phi42-mass-gap",
      "version": "v3",
      "inventorySha512": "9a0c...",
      "follow": "latest",
      "cite": { "title": "Mass gap for the fractional $\\Phi^4_2$ model",
                "creators": ["P. Duch", "M. Gubinelli"], "year": 2026, "issued": "2026-11-12" } }
  ]
}
```

A `members.json` of a selection: an issue of a journal, with a paper vetted in its version 2 and, after a correction accepted by the editors, its version 3; an accepted copy kept by the journal; and a member that is itself a collection, vetted in one version:

```json
{
  "format": "opensheaf-collection/0.1",
  "type": "selection",
  "members": [
    { "kind": "document",
      "archive": "tag:example.org,2026:authors",
      "archiveUrl": "https://authors.example.org/",
      "id": "network-discrimination",
      "revisions": [
        { "documentVersion": 2, "version": "v2", "inventorySha512": "4f1e..." },
        { "documentVersion": 3, "version": "v4", "inventorySha512": "c07a..." } ],
      "cite": { "title": "Quantum network discrimination", "creators": ["C. Hirche"], "year": 2021 } },
    { "kind": "collection",
      "archive": "tag:example.org,2026:seminar",
      "archiveUrl": "https://seminar.example.org/",
      "id": "collection-seminar-2026",
      "revisions": [ { "documentVersion": 3, "version": "v3", "inventorySha512": "7d21..." } ] }
  ]
}
```

The `object.json` of the journal's accepted copy of the first member's version 2:

```json
{
  "format": "opensheaf-object/0.1",
  "specification": "0.1",
  "kind": "document",
  "archiveId": "tag:example.org,2026:journal",
  "objectId": "network-discrimination",
  "documentVersion": 1,
  "mainSource": "paper.tex",
  "sourceFormat": "application/x-tex",
  "renditions": [ { "path": "paper.pdf", "mediaType": "application/pdf" } ],
  "stage": { "scheme": "NISO-JAV", "value": "VoR" },
  "external": [ { "role": "source", "service": "OpenSheaf",
                  "record": "https://authors.example.org/ocfl/network-discrimination/v2/",
                  "label": "network-discrimination v2",
                  "files": [ { "name": "inventory.json", "sha512": "4f1e..." } ] } ],
  "status": "active"
}
```

## Appendix F. Rationale (non-normative)

- **Why OCFL.** It is a published, versioned specification for exactly this problem (versioned objects as plain files with digests), with independent validators, used by research libraries. OpenSheaf adds only discovery and collections.
- **Why the flat-direct layout.** Paths stay readable and resolvable by rule over plain HTTP; the cost is short identifiers without `/`.
- **Why a discovery document.** Static web servers cannot list folders; one small file makes an archive discoverable, and its statements are checked against the storage root.
- **Why pins by inventory digest.** One digest fixes a whole object version, so collections become hash trees across archives, and any matching copy will do.
- **Why catalogues and selections.** Keeping and vetting are different acts. An archive (an author's, an institution's, a storage site) keeps what its members deposit, every version, without judging them: following an object as it grows is its job. A selection (a journal, a digest, a review journal) vouches for particular revisions: a later version by the authors has not been vetted, so it cannot enter the selection by itself, and a change of what is vetted is an editorial act that the selection's own history records. Pinning whole objects in one case and revision sets in the other makes the difference explicit and checkable.
- **Why mirrors and accepted copies differ.** A mirror copies a whole object and stays the same object, owned by its original archive, so it can only grow by the original's versions. An accepted copy takes one vetted revision into the selection's own archive, where it continues under the selection's responsibility (corrections, notices, withdrawal); OCFL cannot hold part of an object, so a copy of one revision is necessarily a new object.
- **Why separate document and object versions.** Readers and DOI services see versions of the work; the storage keeps every change, including corrections of the description.
- **Why the archive numbers document versions itself.** External numberings have gaps (versions an external service no longer serves) and do not cover versions that were never public there. The archive's own numbers have no gaps; external labels are recorded beside them.
- **Why an explicit history, and why it lists object versions.** Dates may be approximate or unknown, so they cannot order versions, and pointers from each version to the previous one cannot be corrected when a version is inserted later, since earlier versions are fixed. A list kept in each object version, with the head's list authoritative, can be corrected by a new version and keeps a record of what was known before. Its entries name object versions, which are exact and resolved directly through the inventory, and name the last object version of each document version, which carries its most complete description. Digests could not be used: an object version cannot contain the digest of its own inventory.
- **Why the deposit is read from the inventory.** OCFL already records when and by whom each object version was made; repeating it in `object.json` would allow the two to disagree.
- **Why notices are not new document versions.** A notice about a version is a later statement about it, not a change of the work. The exact state a reader saw, with or without a notice, is identified by the object version and its pin.
- **Where witnesses live.** A witness of an object version can only be made after the version is committed, so it cannot be part of it (a signature of an inventory cannot be listed in that inventory). Putting each signature or timestamp in a new version would mix evidence with changes of the work, and every upgrade of a timestamp proof would be a version. OCFL closes the object folder to anything it does not define, and its `logs/` folder is meant for unstructured records of actions and is not covered by digests. Object extension folders are the place OCFL provides for data that is not part of any version (the registered mutable-head extension keeps its data there), so witnesses go in `extensions/opensheaf-witnesses/` and travel with the object; `witnesses/` outside the storage root remains for archives that never touch object folders after commit.
- **Why no HTML in deposits.** Presentations improve; deposits must not change.
- **Why a minimal core, and extensions.** The core defines only what every archive and collection needs to be kept, cited, composed and verified. Richer structures among documents (a short account of a proof and its detailed argument, a talk and its paper, a dataset and the analyses built on it, a knowledge base linking results across papers) are built on top of it: by links inside the documents and DataCite relations, which need nothing more, or by extensions that record them with pins, so that tools follow them when they copy, verify or present documents. Keeping them out of the core leaves room for designs not yet imagined, while the pins, which fix extension data with the rest of each version, keep whatever is built checkable.
- **Why DataCite.** It is the metadata of DOIs for repositories, with relations for versions, preprints and collections, and it maps directly to Zenodo.

## Appendix G. References

- [OCFL 1.1 specification](https://ocfl.io/1.1/spec/) and [OCFL extensions](https://ocfl.github.io/extensions/)
- [DataCite Metadata Schema 4.7](https://schema.datacite.org/), [DataCite guidance on preprints](https://support.datacite.org/docs/preprints-post-prints-and-author-manuscripts) and [the REST API change for publisher and affiliation](https://support.datacite.org/docs/datacite-rest-api-affiliation-and-publisher-default-change)
- [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174), [RFC 8259](https://www.rfc-editor.org/rfc/rfc8259), [RFC 4151](https://www.rfc-editor.org/rfc/rfc4151) and [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339)
- [JSON Schema 2020-12](https://json-schema.org/draft/2020-12)
- [Zenodo developer documentation](https://developers.zenodo.org/), [InvenioRDM records API](https://inveniordm.docs.cern.ch/reference/rest_api_drafts_records/), [Zenodo on folders](https://support.zenodo.org/help/en-gb/1-upload-deposit/74-can-i-upload-folders-directories), [managing files](https://help.zenodo.org/docs/deposit/manage-files/), [resource types](https://zenodo.org/api/vocabularies/resourcetypes) and [versioning](https://zenodo.org/help/versioning)
- [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html), [FAIR Signposting](https://signposting.org/), [OAI-PMH static repositories](https://www.openarchives.org/OAI/2.0/guidelines-static-repository.htm) and [ResourceSync](https://www.openarchives.org/rs/toc)
- [OpenTimestamps](https://opentimestamps.org/) and [Software Heritage identifiers](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)
