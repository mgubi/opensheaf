# OpenSheaf: frequently asked questions

*Answers to questions that come up about the design of
[OpenSheaf](https://opensheaf.org). The specification
([opensheaf-specification-0.1.md](opensheaf-specification-0.1.md)) is
authoritative; this page explains its choices.*

## What is OpenSheaf for?

It is an open format for archives of scholarly documents and for collections
of them: a lean alternative to arXiv and to the usual publication
infrastructure. Anyone can keep an archive of their documents as plain files
on a static website, with sources, versions fixed by hashes, standard
metadata, and collections that combine documents from several archives.

## Why not just use arXiv, or Zenodo?

Both are excellent services, and OpenSheaf works with them: a document can
also be on arXiv (linked with `IsIdenticalTo`), and the Zenodo binding gives
every version a DOI on Zenodo. What OpenSheaf adds is an archive that its
owner keeps and controls, that stores sources (not only PDFs) in a
documented layout, that anyone can verify file by file, and that can be
combined with other archives into collections and selections without asking
any central service.

## Do I need Zenodo, TeXmacs, git or GitHub?

No. The core of the format is an OCFL storage root and a discovery document
served over HTTPS. Zenodo, TeXmacs and the website are optional profiles
(appendices A, B and C). Git and GitHub Pages are convenient ways to keep and
serve an archive, but any static web server will do.

## Why OCFL? Isn't git enough?

Git records history, but its layout is internal to git and its hashes (SHA-1
in most repositories) are not meant for long-term preservation. OCFL (the
Oxford Common File Layout) is a published specification for exactly this
problem: versioned objects stored as plain files, every file fixed by a
SHA-512 digest, readable without any special software, with independent
validators, used by research libraries. An OpenSheaf archive can still be
kept in git; git just is not part of its integrity.

## Why DataCite metadata, and not RO-Crate, Dublin Core or JATS?

DataCite is the metadata behind DOIs for repositories (Zenodo, arXiv's DOIs,
university repositories). It has the relations needed here (versions,
preprints and published articles, collections), it maps directly to Zenodo,
and its records are harvested by ORCID, OpenAlex and search services.
RO-Crate is richer but heavier; Dublin Core is too thin; JATS is for the
full text of journal articles.

## Why JSON and not YAML?

The metadata files are written by tools and checked by machines. JSON is
strict, has one way of writing each value, and is read everywhere without
extra libraries. YAML is nicer to edit by hand but converts values silently
(dates, version numbers like `1.10`, identifiers like `2611.14296`).

## Why is there a discovery document (opensheaf.json)?

Static web servers cannot list folders, so a program visiting an archive
could not find its objects. `opensheaf.json`, at the archive's address, lists
them with their head versions and digests, names the storage root and the
main collection, and says which version of the specification the archive
follows. It is only a map: everything it says is checked against the storage
root.

## Why are identifiers short names and not URIs?

The flat-direct storage layout puts each object in a folder named by its
identifier, so paths stay readable and can be computed over plain HTTP; a
folder name cannot contain `/`. The archive itself has a URI-like identifier
(a `tag:` URI, for instance `tag:opensheaf.org,2026:mgubi`), and an object is
named globally by the pair (archive identifier, object identifier).

## What is the difference between a document version and an object version?

The document version is the version of the work, what readers see and what
gets a DOI: it changes only when the sources or the PDF change. The object
version (`v1`, `v2`, ...) is OCFL's: it changes at every change of the
object, including corrections of the description (adding the DOI of the
journal version, fixing an affiliation).

## How do collections work across archives? What if another archive disappears?

A collection lists its members by archive identifier, address, object
identifier, version and the SHA-512 digest of that version's inventory (the
"pin"). Since an inventory fixes all its files, the pin fixes the member
completely, and a collection becomes a hash tree over everything it contains.
If the member's archive moves or disappears, the member can be fetched from a
mirror, from its DOI deposit or from a Software Heritage snapshot: any copy
that matches the pin is the right one. A collection also keeps a cached
citation of each member, so that it stays readable even if no copy is found.

## Can I put someone else's paper in my collection?

Yes. A reference (a pin) copies nothing and needs no permission. Copying
(mirroring) another archive's object into your own storage root is allowed
only if the document's licence permits redistribution. The licence of a
collection (CC0 for the list) never extends to its members.

## Where do signatures and timestamps go, and why not in the version itself?

A signature or timestamp of an object version can only be made after the
version is committed, so it cannot be part of that version: a signature of an
inventory cannot be listed in the inventory it signs. Making a new version
for each signature would mix evidence with changes of the work, and every
upgrade of a timestamp proof (OpenTimestamps proofs are completed once their
attestation is confirmed) would be another version.

OCFL does not allow arbitrary files in an object folder; its `logs/` folder
is meant for unstructured records of actions and is not covered by digests.
The place OCFL provides for data that is not part of any version is the
object's `extensions/` folder (the registered mutable-head extension keeps its
data there). So OpenSheaf puts witnesses in
`extensions/opensheaf-witnesses/`, where they travel with the object. An
archive that never touches object folders after commit may keep them in a
`witnesses/` folder outside the storage root instead. Witnesses need no
digests of their own: each one is checked directly against the checksum file
it names, which the pins fix.

## Why is the HTML version not part of the deposit?

Because presentations improve (stylesheets, exporters, fixes) and deposits
must not change. The deposit keeps the sources and the PDF; the HTML is
regenerated from the sources whenever the presentation changes.

## How do I withdraw or take down a document?

To withdraw a document (for instance a retraction), make a new version with a
withdrawal notice: the content and its history stay, and presentations show
the notice. If content must be removed (by law, or for a breach of rights),
the object is deleted and a tombstone is left in the discovery document, so
that collections pinning it report it as removed rather than corrupt. OCFL
version 2 is expected to add a native mechanism for deleting single files;
OpenSheaf will adopt it when it is published.

## Can I use "All rights reserved"?

Yes. Each document carries the licence its authors choose; "All rights
reserved" means readers may access the document but not reuse it. The
metadata (descriptions, provenance, member lists, inventories) is CC0, so that
it can be harvested and mirrored freely. On Zenodo, "All rights reserved" is
entered as a custom licence.

## Will Google Scholar find the papers?

If the archive follows the website profile: each document then has a landing
page with the `citation_*` meta tags Google Scholar reads, and a PDF on the
same host. Appendix C also recommends a sitemap and FAIR Signposting links.

## How do I check an archive?

A verifier validates the JSON files against the schemas in
[schemas/](schemas/), validates the storage root with a standard OCFL
validator (such as `ocfl-py`), checks that the discovery document matches the
storage root, and resolves and checks every member of every collection. The
specification (section 14) lists the checks.

## Is the format stable?

Not yet: version 0.1 is a draft, and versions before 1.0 may change in
incompatible ways. Every file declares the version of the format it follows,
so that tools can tell. From version 1.0, minor versions will be backward
compatible.

## Why the name?

A sheaf is a bundle of papers. In mathematics, a sheaf is the structure in
which local pieces glue into a whole: archives kept and verified separately
compose into collections.
