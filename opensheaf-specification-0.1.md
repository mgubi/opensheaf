# OpenSheaf: an open format for document archives and collections

*Specification, version 0.1 (draft), 13 November 2026. OpenSheaf is a common, open format for archives of scholarly documents and for collections of them, built on the Oxford Common File Layout (OCFL 1.1) and the DataCite Metadata Schema (4.7). This version is experimental and may change in incompatible ways before version 1.0. The text is licensed under CC BY-SA 4.0; the JSON Schemas are dedicated to the public domain under CC0 1.0.*

## 1. Introduction (non-normative)

OpenSheaf is meant as a lean alternative to arXiv and to the usual publication infrastructure. Any author, group or institution can keep an archive of its documents as plain files, served as a static website, checkable by anyone, and composable with other archives:

- **Sources, not only PDFs.** A deposit keeps the sources of a document with its renditions (a PDF, typically), so that the archive can be read as a website and in the authoring tool.
- **Fixed versions.** Every version of every document is fixed by content hashes and never changes once deposited. Corrections are new versions, and the history can be verified from the files alone.
- **Standards, not inventions.** Storage follows OCFL 1.1 and description follows DataCite 4.7. This specification only defines what these leave open: discovery of an archive, collections, provenance, withdrawal, and the profiles for external services and tools.
- **Composable collections.** A collection is itself a versioned object. It can include documents and collections of other archives, pinned by digest, so that selections (by a seminar, an editorial board, a reading list) compose without copying.
- **External services are optional.** Archives may deposit their documents with a DOI service such as Zenodo, publish them as a website, and keep their files in git; none of this is required by the core of the format.

Answers to common questions about the design are collected in the [FAQ](https://github.com/opensheaf/opensheaf/blob/main/FAQ.md).

The name: a sheaf is a bundle of papers and, in mathematics, the structure in which local pieces glue into a whole, as archives kept and verified separately compose into collections. The home of the format is `https://opensheaf.org/`. The first OpenSheaf archive is `https://mgubi.opensheaf.org/`; its values appear in the examples.

## 2. Conventions

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, NOT RECOMMENDED, MAY and OPTIONAL in this document are to be interpreted as described in BCP 14 (RFC 2119 and RFC 8174) when, and only when, they appear in all capitals.

Sections marked non-normative, examples, notes and the appendices marked as such are informative. JSON means RFC 8259 JSON encoded in UTF-8 without a byte order mark. URLs are absolute unless stated otherwise; a relative URL in a JSON file is resolved against the URL of that file.

## 3. Terminology

- **Archive:** a set of objects kept by one owner (a person, group or institution), with one storage root and one discovery document, identified by an archive identifier.
- **Archive identifier:** a URI naming the archive independently of where it is served (section 6).
- **Base URL:** the URL at which an archive is currently served; its discovery document is at `<base URL>opensheaf.json`.
- **Storage root:** an OCFL 1.1 storage root holding the objects of the archive.
- **Object:** an OCFL object. Its **kind** is `document` or `collection`.
- **Document:** an object holding one scholarly work (an article, notes, a thesis, a book) with its sources and renditions.
- **Collection:** an object holding a list of members.
- **Selection:** a collection whose members include collections. Selections are collections; the word only describes their use.
- **Object version:** an OCFL version of an object (`v1`, `v2`, ...). It changes at every change of the object.
- **Document version:** the version of the work, a positive integer in `provenance.json` and `datacite.json`. It changes only when the sources or the renditions change.
- **Member:** an entry of a collection, pinning an object version of some archive.
- **Pin:** the pair (object version, SHA-512 digest of that version's inventory file).
- **Rendition:** a file produced from the sources and deposited with them (a PDF, an EPUB).
- **Presentation:** files generated from the archive for readers (web pages, indexes, HTML versions of documents). It is never authoritative.
- **Witness:** an independent copy or proof: a signature, a timestamp, an external deposit, a software archive snapshot.
- **Verifier:** a program that checks an archive or a collection against this specification.

## 4. Conformance

This specification defines the following conformance classes. An archive, object or program conforms to a class if it satisfies every MUST and MUST NOT of the sections listed for it.

- **OpenSheaf archive:** sections 5, 6, 7, 8, 9, 11, 12 and 13.
- **OpenSheaf collection:** section 10, in addition to the requirements on objects in sections 7 to 9.
- **OpenSheaf verifier:** section 14.
- **Profiles**, optional: an archive MAY additionally conform to the Zenodo binding (appendix A), the TeXmacs profile (appendix B) and the website profile (appendix C). A conforming archive MUST state in its discovery document which profiles it follows.

The JSON files defined here (`opensheaf.json`, `provenance.json`, `members.json`) MUST validate against the JSON Schemas of appendix D for their declared format version.

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
- `objects`: the list of all objects in the storage root, each with `id`, `kind`, `head` (the head object version), `inventorySha512` (the SHA-512 digest of the head inventory, as written in its checksum file) and `status` (`active` or `withdrawn`, section 11).

It SHOULD contain `mainCollection` (the identifier of the collection that lists the archive's own documents), `contact` (a URI), and `profiles` (the list of profiles followed, from `zenodo`, `texmacs`, `website`). It MAY contain `mirrors` (base URLs of complete copies of the archive), `tombstones` (section 11.3), `keys` (section 13.2) and `feed` (the URL of an Atom feed of new object versions).

The discovery document is mutable: it is rewritten whenever an object is added or changed. It is a map, not a witness: everything it states MUST be verifiable from the storage root.

### 6.2 Archive identifiers

An archive identifier is a URI that does not change when the archive moves. It SHOULD be a `tag:` URI (RFC 4151) built from a domain or e-mail address controlled by the owner at the time of creation and a date, for instance `tag:opensheaf.org,2026:mgubi`. A DOI or another persistent URI MAY be used instead. Two different archives MUST NOT use the same archive identifier.

### 6.3 Object identifiers

An object identifier MUST match `^[a-z0-9]+(-[a-z0-9]+)*$` and MUST be at most 64 characters long. It is the OCFL `id` of the object and the name of its folder in the storage root. It MUST be unique in the archive and MUST NOT be reused, also after a takedown. The kind of an object is given by its `provenance.json`, never by its identifier. Outside the archive, an object is named by the pair (archive identifier, object identifier).

### 6.4 Resolution

To fetch an object version of a member, a client:

- reads the discovery document at the member's archive URL (section 10.2) and fetches `<storageRoot><id>/<version>/inventory.json`;
- if this fails, tries the mirrors listed in the member, then those listed in the archive's discovery document;
- if this fails, MAY use external copies: the files of the external deposit named in the version's provenance (a DOI record), or a software archive snapshot (a SWHID).

Any copy whose bytes match the pinned digest is acceptable: integrity comes from the pin, not from the place.

## 7. Objects

### 7.1 Common rules

Every object MUST be a valid OCFL 1.1 object. Its inventories MUST use `sha512` as digest algorithm. Every object version MUST contain, in its content, the files `provenance.json` and `datacite.json` at the top level. Every version directory MUST contain a copy of the inventory as of that version, with its checksum file (OCFL makes this a recommendation; OpenSheaf requires it, so that each version can be pinned and fetched on its own).

Each version in the inventory MUST have a `user` with a `name`, and SHOULD have an `address` (an ORCID iD, a `mailto:` URI or another URI identifying the depositor), and MUST have a `message` describing the change.

Logical paths MUST be encoded in UTF-8 in Unicode normalisation form C, MUST NOT begin with `/`, and MUST NOT contain `.` or `..` segments.

### 7.2 Documents

A document version contains, at the top level of its content unless a profile says otherwise:

- the **sources**: the main source and every file needed to produce the renditions that is not part of the toolchain (images, bibliography databases, local style files). The main source is named in `provenance.json`. Sources SHOULD be flat (no sub-folders) when possible;
- the **renditions**, OPTIONAL but RECOMMENDED: at least a PDF for documents meant to be read and cited, named in `provenance.json`;
- `datacite.json` (section 8) and `provenance.json` (section 9).

HTML versions and other presentation files SHOULD NOT be deposited, since they depend on the presentation and are regenerated when it improves.

The document version MUST increase by one exactly when the sources or the renditions change. A version that changes only `datacite.json` or `provenance.json` (a description-only version) keeps the document version.

### 7.3 Collections

A collection version contains `datacite.json`, `provenance.json` and `members.json` (section 10). Its `provenance.json` declares `kind` `collection`; its document version counts the changes of the member list.

## 8. Description: datacite.json

Every object version MUST contain `datacite.json`, a JSON object with the DataCite 4.7 properties in the form of the `attributes` of a DOI in the DataCite REST API. It is the authoritative description of the object version. It MUST contain:

- `titles`, `creators` (with `name`, and `nameType`; personal names SHOULD also have `givenName` and `familyName`), `publicationYear`, `types` (with `resourceTypeGeneral`), `version` (the document version, as a string), and `publisher`.

It SHOULD contain:

- `descriptions` with a `descriptionType` `Abstract`, as plain text;
- `subjects` with a `subjectScheme` (any scheme; MSC2020 is common in mathematics);
- `dates`, with `Available` for the date the version was deposited, `Updated` for description-only versions, and `Issued` or `Submitted` only in their DataCite meaning;
- `rightsList`, with an SPDX identifier in lower case and the licence URL, or a statement such as "All rights reserved";
- `language`, `formats` (the media types of the sources and renditions) and `sizes`;
- identifiers of creators (ORCID) and of affiliations (ROR), where they exist;
- `relatedIdentifiers` (section 8.1).

`publisher` is the archive's name, or the external service registering a DOI for the version (appendix A). `publisher` and `affiliation` SHOULD be written as objects (with `name` and, where available, an identifier); readers MUST also accept plain strings.

`doi` and `url` are OPTIONAL: they are present when the version has a DOI. `types.resourceTypeGeneral` SHOULD be `Preprint` for a work not yet published elsewhere, `JournalArticle`, `Book`, `Dissertation`, `Text` and so on otherwise, and `Collection` for collections.

### 8.1 Relations

- A document version with a DOI SHOULD have `IsVersionOf` the concept DOI of the document, and `IsNewVersionOf` the DOI of the previous document version.
- The same work published elsewhere SHOULD be linked with `IsIdenticalTo` (same content, for instance an arXiv version) or `IsVariantFormOf` (different content or form).
- A preprint SHOULD be linked to its later published article with `IsVersionOf` the article's DOI, as DataCite recommends; consumers distinguish this relation from the concept DOI by its target. It is added by a description-only version.
- The sources MAY be linked to a software archive snapshot (`relatedIdentifierType` `SWHID`).
- A collection version MUST have `HasPart` for each member that has a version DOI, pointing to that version DOI. Members without a DOI are listed only in `members.json`.
- A document MUST NOT state the collections that include it: membership is stated only by collections, so that including a document in any collection never changes the document.

## 9. Provenance: provenance.json

Every object version MUST contain `provenance.json` with:

- `format`: `"opensheaf-provenance/0.1"`;
- `specification`: `"0.1"`;
- `kind`: `document` or `collection`;
- `archiveId` and `objectId`;
- `documentVersion`: a positive integer, equal to the `version` of `datacite.json`;
- `deposit`: the `date` (RFC 3339) and the `agent` (name and URI) of the deposit;
- `status`: `active` or `withdrawn` (section 11).

A document MUST also have `mainSource` (a logical path) and `sourceFormat` (the media type of the main source), and SHOULD have `renditions` (a list of logical paths with media types) and `toolchain` (a list of tools with `name`, `version` and, optionally, `packages`), enough to reproduce the renditions.

It MAY contain:

- `agreement`: a minimal record that the authors agreed to the deposit and to the licence: who agreed (names only), when, and how (for instance "by e-mail"). It MUST NOT contain e-mail addresses, correspondence or signatures of persons;
- `external`: the external deposits of this version (appendix A), each with the service, the record identifier, the DOI and the digests of any file deposited there that is not in the content (such as a source archive);
- `withdrawal` (section 11).

`provenance.json` is metadata and is placed under CC0 (section 16).

## 10. Collections: members.json

### 10.1 The member list

A collection version MUST contain `members.json` with:

- `format`: `"opensheaf-collection/0.1"`;
- `members`: a list, in the order in which the members are presented.

Each member MUST have:

- `kind`: `document` or `collection`;
- `archive`: the archive identifier of the member's archive;
- `archiveUrl`: the base URL of that archive when the collection version was made;
- `id`: the object identifier;
- `version`: the pinned object version;
- `inventorySha512`: the SHA-512 digest of that version's inventory file.

Each member MAY have `mirrors` (base URLs), `doi` (the version DOI), `conceptDoi`, `follow` (`"latest"`, section 10.3) and `cite`, a cached citation (`title`, `creators` as a list of names, `year`) so that the collection stays readable if the member becomes unavailable. `cite` is not authoritative.

Every member is pinned: a collection version states exactly which object version of each member it contains. A collection version therefore fixes everything it contains, also across archives; since a pin fixes an inventory, which fixes all its files, collections are hash trees. Pins cannot form cycles.

### 10.2 Members of other archives

A member may belong to another archive. Nothing is copied: the member is resolved as in section 6.4. An archive MAY also mirror another archive's object by copying it into its own storage root, keeping its identifier only if no object of its own has it, and only if the licence of the member allows redistribution. A reference (a pin without a copy) needs no permission.

### 10.3 Following members

`"follow": "latest"` is a curation setting, not a floating reference. A tool maintaining the collection reads the member archive's discovery document (or its feed); when the followed object has a new head version, the tool writes a new collection version with the new pin. If the followed object is withdrawn, the pin is kept and the tool reports it to the curator.

### 10.4 Rights

The member list of a collection is placed under CC0. The licence of a collection never extends to its members.

## 11. Withdrawal and takedown

### 11.1 Withdrawal

A document or collection is withdrawn (for instance retracted by its authors) by a description-only version whose `provenance.json` has `status` `withdrawn` and a `withdrawal` object with `date` and `reason`. Its content is kept, its history remains verifiable, and the discovery document lists it with `status` `withdrawn`. Presentations MUST show the withdrawal notice with the document.

### 11.2 Takedown

When content must be removed (by law, or for a breach of rights), the object is deleted from the storage root and a tombstone is added to the discovery document.

### 11.3 Tombstones

A tombstone records `id`, `kind`, `lastVersion`, `inventorySha512` of that version, `date` and `reason`. Identifiers of tombstoned objects MUST NOT be reused. Verifiers report a pin to a tombstoned object as "removed", not as a corruption. External copies (DOI records, snapshots) follow the rules of their services.

Note: OCFL 1.1 has no way to remove files from an object short of deleting and rebuilding it. Physical deletion of files, and the flagging of lost or corrupted files, are accepted as in scope for OCFL version 2, with a tombstone or status recorded in the inventory. When that mechanism is published, a later version of this specification will adopt it for takedowns of single files.

## 12. Versioning of this specification

Every JSON file defined here declares its format version, and the discovery document and every `provenance.json` declare the version of this specification. Before version 1.0, any change of the minor version (0.1, 0.2, ...) may be incompatible; a reader that finds a version it does not know SHOULD report it and MUST NOT silently treat the files as valid. From version 1.0, minor versions will be backward compatible.

The text of each version is published at `https://opensheaf.org/opensheaf-specification-<version>.md` and is not changed after the version is final.

## 13. Integrity and authenticity

### 13.1 Integrity

Integrity rests on OCFL digests: every file is fixed by its SHA-512 digest in the inventory, every inventory by its checksum file, and every collection version pins its members by inventory digest. Inventories MAY also record MD5 and SHA-256 digests in their `fixity` block; archives following the Zenodo binding MUST record MD5 (appendix A).

### 13.2 Authenticity and dates

Digests show that files were not changed; they do not show who made them or when. An archive MAY provide, for each object version:

- `<version>.inventory.json.sha512.sig`: a detached signature of the inventory checksum file of that version (`<version>/inventory.json.sha512`), made with a key listed in `keys` of the discovery document (each key with `type`, such as `openpgp` or `ssh`, and a `url` or `fingerprint`);
- `<version>.inventory.json.sha512.ots`: an OpenTimestamps proof of the same file.

These witness files SHOULD be kept in the object's extension folder `extensions/opensheaf-witnesses/`, so that they travel with the object when it is copied or mirrored. OCFL allows object extension folders, which are not part of any version; the extension name `opensheaf-witnesses` is not yet registered with OCFL, so validators may warn about it. An archive that does not modify object folders after a version is committed MAY instead keep them under `witnesses/<object id>/`, next to the discovery document. Witnesses can be added later, by the owner or by others, and replaced when a proof is upgraded (an OpenTimestamps proof is completed once its attestation is confirmed); they are not covered by the inventory digests, and need not be, since each one is checked directly against the checksum file it names, which the pins fix.

External deposits (appendix A) and software archive snapshots are further witnesses. Archives kept in git MAY also sign their commits or tags, but git hashes are not part of the integrity chain of this specification.

## 14. Verification

A verifier checking an archive MUST:

- validate the discovery document, and every `provenance.json` and `members.json`, against the schemas of their declared versions;
- validate the storage root and every object against OCFL 1.1 (with a standard OCFL validator or equivalent checks);
- check that the discovery document lists exactly the objects of the storage root, with their head versions and inventory digests, and lists every tombstone;
- check the requirements of sections 7 to 11 on every object version, including that `datacite.json` and `provenance.json` agree on the document version;
- for each collection version, resolve each member as in section 6.4 and check its pin, reporting each member as verified, mismatch (a copy was found and does not match), unavailable (no copy found) or removed (tombstoned).

A verifier SHOULD check the witnesses it finds, and the requirements of the profiles the archive declares. It MUST NOT treat the presentation as authoritative. It SHOULD limit the depth and size of the collections it follows, and report when it stops.

## 15. Security considerations

- **Untrusted inventories.** Inventories, logical paths and member lists from other archives are untrusted input. Verifiers MUST reject paths that are absolute or contain `..`, and SHOULD limit the size of the files they fetch.
- **Archives of sources.** Tools unpacking source archives (appendix A) MUST guard against paths leaving the target folder and against archives that expand to excessive sizes.
- **Presentation.** A website MUST NOT embed HTML of other archives in its own pages; it links to them. Documents' HTML versions are generated by the archive's own tools.
- **Subdomains.** A domain that offers subdomains to archives (as `opensheaf.org` does) MUST remove the DNS records of abandoned archives, to prevent takeover by others.
- **Weak hashes.** SHA-1 (as in most git repositories) and MD5 are not used for integrity: MD5 appears only for comparison with external services.
- **Mutable maps.** The discovery document and presentation files can be changed by whoever controls the server; their statements are only trusted after checking them against the storage root and the pins.

## 16. Privacy and rights

- **Documents.** Each document carries the licence chosen by its authors in `rightsList`. "All rights reserved" is allowed: deposit grants readers access, not reuse.
- **Metadata.** `datacite.json`, `provenance.json`, `members.json`, inventories and the discovery document are placed under CC0, so that they can be harvested and mirrored freely.
- **Personal data.** Archives record only the personal data needed to describe and cite the work (names, identifiers, affiliations) and the depositor of each version. Agreement records are minimal (section 9). A request to erase personal data from an immutable history is handled by a takedown (section 11.2).

## 17. Changelog

- **0.1 (draft), 13 November 2026:** first version.

## Appendix A. Zenodo binding (normative for archives declaring the profile `zenodo`)

Zenodo issues DataCite DOIs (prefix `10.5281`) and keeps files permanently. Under this binding:

- **Records.** Each document is one Zenodo record with versions: the concept DOI stands for the document, and each document version is one record version with its own DOI, of Zenodo resource type `publication-preprint` (or the type matching `resourceTypeGeneral`). Description-only versions are metadata edits of the existing record version, not new record versions.
- **Files.** The record version holds the content files of the object version as deposited. Zenodo records have no folders: if the sources have sub-folders, or the record would exceed Zenodo's file count, the sources are uploaded as one archive `sources.zip`, built reproducibly (entries in byte order of their names, fixed timestamps, no extra attributes), whose digests are recorded in `provenance.json` under `external`. Inventories MUST record MD5 digests in `fixity`, so that the checksums reported by Zenodo can be compared directly.
- **Order of operations.** (1) Create a draft, or a new version of the record (a new version starts without files). (2) Reserve its DOI. (3) Write `datacite.json` with that DOI and build the object version in a staging area. (4) Upload the files and compare the MD5 checksums reported by Zenodo with the fixity block. (5) Publish. (6) Commit the object version and update the discovery document. If a step fails before publication, the draft is discarded. If publication succeeds and the commit fails, the tool MUST complete the object version from the staging area before any other deposit of that document; it SHOULD hold a lock per document during a deposit, since Zenodo allows one unpublished version per record.
- **Corrections.** Zenodo allows the files of a published version to be changed within 30 days. Archives following this binding MUST NOT use this: a correction is a new document version.
- **Metadata differences.** Zenodo generates its own DataCite record for the DOI: its `url` is the Zenodo landing page, its `publisher` is Zenodo, and it adds relations of its own (such as `IsVersionOf` the concept DOI). `datacite.json` remains authoritative; verifiers tolerate exactly these differences.
- **Collections.** A collection MAY be deposited when it is explicitly released (not at every change), as a record of type `other`, with `members.json` among its files. A Zenodo community MAY group an archive's records for browsing; it is not authoritative.

## Appendix B. TeXmacs profile (normative for archives declaring the profile `texmacs`)

- The main source is a TeXmacs document; `sourceFormat` is `application/x-texmacs` (not a registered media type; it is the type TeXmacs uses).
- `toolchain` records the TeXmacs version and the style packages and plugins used that are not part of the TeXmacs distribution; such packages that belong to the document are deposited with the sources.
- Renditions are produced without regenerating bibliographies or tables of contents, so that the deposited sources, with their stored references, reproduce them even if a bibliography database is not deposited; deposits SHOULD nevertheless include the databases used.
- The abstract in `datacite.json` is the TeXmacs abstract converted to plain text, with mathematics written in LaTeX between dollar signs.
- HTML versions are exported by TeXmacs from a copy of the sources with presentation packages added to its style; the deposited sources are not modified.
- An archive whose files are kept inside a website built with TeXmacs' website converter SHOULD place an empty file `.texmacs-noconvert` at its top (honoured by the `max-html` plugin), so that the converter never rewrites deposited files.

## Appendix C. Website profile (normative for archives declaring the profile `website`)

- **Index.** The website has an index page generated from the head version of the main collection. It MAY be split into several pages. A flattened, non-authoritative list for programs that do not read OCFL MAY be published as `catalog.json`.
- **Landing pages.** Each document has one landing page, for its newest version, with links to every version, its renditions and sources, its DOI, and its withdrawal notice if any.
- **Search engines.** Landing pages MUST carry the meta tags read by Google Scholar: `citation_title`, `citation_author` (one per author), `citation_publication_date`, and `citation_pdf_url` on the same host as the PDF; and SHOULD carry schema.org `ScholarlyArticle` JSON-LD and FAIR Signposting links (`cite-as`, `describedby`, `item`, `license`).
- **Harvesters.** The website SHOULD publish a `sitemap.xml`, and MAY publish an OAI-PMH static repository file or a ResourceSync description.
- **Citations.** Landing pages SHOULD offer BibTeX and CSL-JSON entries generated from `datacite.json`.
- **Separation.** Presentation files are regenerated from the archive and never edited by hand; they do not embed other archives' HTML.

## Appendix D. JSON Schemas (normative)

The schemas (JSON Schema draft 2020-12) are published with this specification and dedicated to the public domain under CC0 1.0, so that they can be embedded in any software:

- [opensheaf-archive-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-archive-0.1.schema.json) for `opensheaf.json`;
- [opensheaf-provenance-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-provenance-0.1.schema.json) for `provenance.json`;
- [opensheaf-collection-0.1.schema.json](https://opensheaf.org/schemas/opensheaf-collection-0.1.schema.json) for `members.json`.

`datacite.json` is validated against the DataCite 4.7 schema together with the requirements of section 8.

## Appendix E. Examples (non-normative)

The values below come from the first archive. Digests are shortened, and the DOIs and ORCID iDs are placeholders.

A discovery document:

```
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

A `provenance.json` of a document version:

```
{
  "format": "opensheaf-provenance/0.1",
  "specification": "0.1",
  "kind": "document",
  "archiveId": "tag:opensheaf.org,2026:mgubi",
  "objectId": "fractional-phi42-mass-gap",
  "documentVersion": 1,
  "mainSource": "fractional-phi42-mass-gap.tm",
  "sourceFormat": "application/x-texmacs",
  "renditions": [ { "path": "paper.pdf", "mediaType": "application/pdf" } ],
  "toolchain": [ { "name": "TeXmacs", "version": "2.1.5" } ],
  "deposit": { "date": "2026-11-12T18:00:00Z",
               "agent": { "name": "Massimiliano Gubinelli", "uri": "https://orcid.org/0000-0000-0000-0000" } },
  "agreement": { "by": ["P. Duch", "M. Gubinelli"], "date": "2026-11-12", "method": "by e-mail" },
  "status": "active"
}
```

A `datacite.json` of the same version:

```
{
  "doi": "10.5281/zenodo.1234567",
  "url": "https://mgubi.opensheaf.org/site/fractional-phi42-mass-gap/",
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
  "dates": [ { "date": "2026-11-12", "dateType": "Available" } ],
  "rightsList": [ { "rights": "Creative Commons Attribution 4.0 International",
                    "rightsUri": "https://creativecommons.org/licenses/by/4.0/",
                    "rightsIdentifier": "cc-by-4.0", "rightsIdentifierScheme": "SPDX" } ],
  "descriptions": [ { "description": "We present a new, simple ...", "descriptionType": "Abstract" } ],
  "formats": [ "application/x-texmacs", "application/pdf" ],
  "relatedIdentifiers": [
    { "relatedIdentifier": "10.5281/zenodo.1234566", "relatedIdentifierType": "DOI", "relationType": "IsVersionOf" } ]
}
```

A `members.json` of a collection version, with a member from another archive:

```
{
  "format": "opensheaf-collection/0.1",
  "members": [
    { "kind": "document",
      "archive": "tag:opensheaf.org,2026:mgubi",
      "archiveUrl": "https://mgubi.opensheaf.org/",
      "id": "fractional-phi42-mass-gap",
      "version": "v1",
      "inventorySha512": "9a0c...",
      "doi": "10.5281/zenodo.1234567",
      "follow": "latest",
      "cite": { "title": "Mass gap for the fractional Phi^4_2 model",
                "creators": ["P. Duch", "M. Gubinelli"], "year": 2026 } },
    { "kind": "collection",
      "archive": "tag:example.org,2026:seminar",
      "archiveUrl": "https://seminar.example.org/",
      "id": "collection-seminar-2026",
      "version": "v3",
      "inventorySha512": "7d21..." }
  ]
}
```

## Appendix F. Rationale (non-normative)

- **Why OCFL.** It is a published, versioned specification for exactly this problem (versioned objects as plain files with digests), with independent validators, used by research libraries. OpenSheaf adds only discovery and collections.
- **Why the flat-direct layout.** Paths stay readable and resolvable by rule over plain HTTP; the cost is short identifiers without `/`.
- **Why a discovery document.** Static web servers cannot list folders; one small file makes an archive discoverable, and its statements are checked against the storage root.
- **Why pins by inventory digest.** One digest fixes a whole object version, so collections become hash trees across archives, and any matching copy will do.
- **Why separate document and object versions.** Readers and DOI services see versions of the work; the storage keeps every change, including corrections of the description.
- **Where witnesses live.** A witness of an object version can only be made after the version is committed, so it cannot be part of it (a signature of an inventory cannot be listed in that inventory). Putting each signature or timestamp in a new version would mix evidence with changes of the work, and every upgrade of a timestamp proof would be a version. OCFL closes the object folder to anything it does not define, and its `logs/` folder is meant for unstructured records of actions and is not covered by digests. Object extension folders are the place OCFL provides for data that is not part of any version (the registered mutable-head extension keeps its data there), so witnesses go in `extensions/opensheaf-witnesses/` and travel with the object; `witnesses/` outside the storage root remains for archives that never touch object folders after commit.
- **Why no HTML in deposits.** Presentations improve; deposits must not change.
- **Why DataCite.** It is the metadata of DOIs for repositories, with relations for versions, preprints and collections, and it maps directly to Zenodo.

## Appendix G. References

- [OCFL 1.1 specification](https://ocfl.io/1.1/spec/) and [OCFL extensions](https://ocfl.github.io/extensions/)
- [DataCite Metadata Schema 4.7](https://schema.datacite.org/), [DataCite guidance on preprints](https://support.datacite.org/docs/preprints-post-prints-and-author-manuscripts) and [the REST API change for publisher and affiliation](https://support.datacite.org/docs/datacite-rest-api-affiliation-and-publisher-default-change)
- [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174), [RFC 8259](https://www.rfc-editor.org/rfc/rfc8259), [RFC 4151](https://www.rfc-editor.org/rfc/rfc4151) and [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339)
- [JSON Schema 2020-12](https://json-schema.org/draft/2020-12)
- [Zenodo developer documentation](https://developers.zenodo.org/), [InvenioRDM records API](https://inveniordm.docs.cern.ch/reference/rest_api_drafts_records/), [Zenodo on folders](https://support.zenodo.org/help/en-gb/1-upload-deposit/74-can-i-upload-folders-directories), [managing files](https://help.zenodo.org/docs/deposit/manage-files/), [resource types](https://zenodo.org/api/vocabularies/resourcetypes) and [versioning](https://zenodo.org/help/versioning)
- [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html), [FAIR Signposting](https://signposting.org/), [OAI-PMH static repositories](https://www.openarchives.org/OAI/2.0/guidelines-static-repository.htm) and [ResourceSync](https://www.openarchives.org/rs/toc)
- [OpenTimestamps](https://opentimestamps.org/) and [Software Heritage identifiers](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)
