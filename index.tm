<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|OpenSheaf: an open format for document archives and collections>

  <notes-abstract|Technical overview of OpenSheaf, a common, open format for archives of scholarly documents and for collections of them: storage in OCFL, description in DataCite, deposit on Zenodo, collections that compose across archives. Version 0.1 (draft), 12 November 2026, checked against the OCFL 1.1, DataCite 4.7 and Zenodo documentation; experimental, it may change in incompatible ways before version 1.0.>

  <section*|1. Goals>

  <\itemize>
    <item><strong|A common format.> Any author, group or institution can keep an archive of its documents in the same open format, as a lean alternative to arXiv and to the usual publication infrastructure: plain files in a git repository, served as a static website, checkable by anyone, and composable with other archives.

    <item><strong|Sources, not only PDFs.> A deposit keeps the sources of a document together with its PDF, and the archive is readable both as a website and in the authoring tool. The reference tools work with TeXmacs; other source formats fit the same layout.

    <item><strong|Fixed versions.> Every version of every document is fixed by content hashes and never changes once deposited. Corrections are new versions; the history stays verifiable from the files alone, not only from git.

    <item><strong|Standards, not inventions.> Storage follows the Oxford Common File Layout (OCFL 1.1); description follows the DataCite Metadata Schema (4.7). Only what these leave open (collections, the readable views, the TeXmacs details) is specified here.

    <item><strong|Matched with Zenodo.> Each version of a document can be deposited on Zenodo as a record version with its own DOI, with files that can be checked against the repository; collections can be released on Zenodo too.

    <item><strong|Composable collections.> A collection is itself a versioned object. It can include documents and other collections, also from other archives built the same way, so that selections of collections (by a seminar, a journal-like editorial board, a reading list) can be made without copying.
  </itemize>

  The format is called <strong|OpenSheaf>: a sheaf is a bundle of papers and, in mathematics, the structure in which local pieces glue into a whole, as archives kept and verified separately compose into collections. Its home is <verbatim|https://opensheaf.org/> (also reachable as <verbatim|sheaf.pub>). The first OpenSheaf archive is the repository <verbatim|mgubi/papers>, served at <verbatim|https://mgubi.opensheaf.org/>; its names and values appear below as examples. In what follows a document is called a paper, the main case, but nothing depends on it.

  <section*|2. Layers>

  The design separates four layers. Only the first two are authoritative; the others are derived from them or witness them.

  <\itemize>
    <item><strong|Storage> (<verbatim|ocfl/>): an OCFL storage root with one object per paper and one object per collection. Objects are self-contained, versioned, and checked by their inventories.

    <item><strong|Description>: in each object version, <verbatim|datacite.json> (DataCite metadata) and <verbatim|provenance.json> (how the version was made). A collection version also holds <verbatim|members.json>.

    <item><strong|Presentation>: the index (<verbatim|index.tm>, <verbatim|index.html>), the landing page and HTML version of each paper, BibTeX and CSL-JSON entries. Generated from the storage layer, never edited by hand, regenerable at any time.

    <item><strong|Witnesses> (<verbatim|witnesses/> and outside services): Zenodo records and DOIs, the Zenodo community, Software Heritage snapshots of the git repository, signed git tags and OpenTimestamps proofs. They are independent copies and proofs of date; the repository does not depend on them to be verified.
  </itemize>

  <section*|3. Layout>

  <\verbatim-code>
    papers/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ git repository, served by GitHub Pages

    \ \ README.md \ design.tm \ metadata.tm \ presentation and documentation

    \ \ index-template.tm \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ surrounding text of the index

    \ \ index.tm \ index.html \ \ \ \ \ \ \ \ \ \ \ \ \ \ generated from the main collection

    \ \ site/\<less\>paper-id\<gtr\>/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ generated: landing page, HTML, BibTeX

    \ \ resources/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ stylesheets, scripts, fonts of the pages

    \ \ notes-meta.ts \ paper-html.ts \ \ \ \ \ \ TeXmacs style packages of the pages

    \ \ tools/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ papers.py (deposit, collect, render, verify)

    \ \ witnesses/\<less\>object-id\<gtr\>/ \ \ \ \ \ \ \ \ \ \ \ \ timestamp proofs of inventories

    \ \ .texmacs-noconvert \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TeXmacs website converter: leave alone

    \ \ ocfl/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ OCFL storage root (authoritative)

    \ \ \ \ 0=ocfl_1.1

    \ \ \ \ ocfl_1.1.md \ README.md \ \ \ \ \ \ \ \ \ \ optional files allowed at the root

    \ \ \ \ ocfl_layout.json

    \ \ \ \ extensions/0002-flat-direct-storage-layout/config.json

    \ \ \ \ fractional-phi42-mass-gap/ \ \ \ \ \ \ paper object

    \ \ \ \ \ \ 0=ocfl_object_1.1

    \ \ \ \ \ \ inventory.json \ inventory.json.sha512

    \ \ \ \ \ \ v1/inventory.json \ v1/inventory.json.sha512

    \ \ \ \ \ \ v1/content/fractional-phi42-mass-gap.tm

    \ \ \ \ \ \ v1/content/paper.pdf

    \ \ \ \ \ \ v1/content/datacite.json

    \ \ \ \ \ \ v1/content/provenance.json

    \ \ \ \ collection-papers/ \ \ \ \ \ \ \ \ \ \ \ \ \ \ collection object (the main index)

    \ \ \ \ \ \ 0=ocfl_object_1.1

    \ \ \ \ \ \ inventory.json \ inventory.json.sha512

    \ \ \ \ \ \ v1/inventory.json \ v1/inventory.json.sha512

    \ \ \ \ \ \ v1/content/datacite.json

    \ \ \ \ \ \ v1/content/members.json
  </verbatim-code>

  The storage root must live in its own folder: OCFL allows loose files at the storage root (a copy of the specification, a README) but no directories other than objects and extensions, so the website files cannot share it. An object folder may only hold what OCFL specifies (its declaration file, inventory, checksum file, version folders, <verbatim|extensions/> and <verbatim|logs/>); timestamp proofs are therefore kept outside the storage root, in <verbatim|witnesses/>.

  The flat-direct storage layout (OCFL extension 0002) puts each object in a folder named by its identifier, which keeps paths readable. It requires identifiers that are valid folder names, in particular without <verbatim|/>; see section 4.

  <section*|4. Paper objects>

  <subsection*|Identifier>

  The OCFL identifier of a paper is a short name of lower-case letters, digits and hyphens (<verbatim|fractional-phi42-mass-gap>), unique in the repository and never reused. OCFL recommends, but does not require, URIs as identifiers; short names are chosen because the flat-direct layout cannot hold a <verbatim|/>. The repository itself is named by the URL of its storage root, <verbatim|https://mgubi.opensheaf.org/ocfl/>, and a paper is referred to from outside by the pair (repository, identifier). An archive may live at any stable address it controls; <verbatim|opensheaf.org> offers a subdomain to each archive (<verbatim|\<less\>name\<gtr\>.opensheaf.org>), so that archive addresses do not depend on the hosting service: moving an archive to another host only changes a DNS record. Once the paper is on Zenodo, its concept DOI is the persistent identifier.

  <subsection*|Content of a version>

  <\itemize>
    <item><strong|Sources>, stored at the top of the content folder, as deposited: the main source <verbatim|\<less\>id\<gtr\>.tm>, and every file needed to typeset it that is not part of TeXmacs (images, bibliography databases, local style packages). Sources stay flat whenever possible, because Zenodo records have no folders (section 7).

    <item><verbatim|paper.pdf>: the PDF made from the sources at deposit time. It is part of the deposit because it is what readers cite and what Zenodo shows.

    <item><verbatim|datacite.json>: the description of this version (section 5).

    <item><verbatim|provenance.json>: TeXmacs version, style packages and plugins used, tool version, the commands run, the date and agent of the deposit, the co-authors' agreement to the deposit and the licence, and, when the sources have sub-folders, the recipe and digests of the archive <verbatim|sources.zip> sent to Zenodo. These fields have no place in DataCite but are needed to reproduce and check the deposit.
  </itemize>

  The HTML version is <strong|not> in the object: it depends on the presentation (stylesheets, exporter fixes) and is regenerated whenever these improve, without touching the deposit.

  <subsection*|Inventory, digests and versions>

  The OCFL inventory lists every file of every version by its digest. The digest algorithm is SHA-512, the one OCFL recommends. The optional fixity block also records MD5 and SHA-256: MD5 because Zenodo reports MD5 checksums for its files, so a Zenodo record can be checked against the inventory directly; SHA-256 for tools that expect it. Every inventory has its checksum file, and every version folder keeps a copy of the inventory as it was at that version (recommended by OCFL, required here).

  <\verbatim-code>
    {

    \ \ "id": "fractional-phi42-mass-gap",

    \ \ "type": "https://ocfl.io/1.1/spec/#inventory",

    \ \ "digestAlgorithm": "sha512",

    \ \ "head": "v1",

    \ \ "contentDirectory": "content",

    \ \ "manifest": { "4f1c...": ["v1/content/fractional-phi42-mass-gap.tm"], ... },

    \ \ "versions": {

    \ \ \ \ "v1": {

    \ \ \ \ \ \ "created": "2026-11-12T18:00:00Z",

    \ \ \ \ \ \ "message": "Deposit: paper version 1 (Zenodo record 1234567)",

    \ \ \ \ \ \ "user": { "name": "Massimiliano Gubinelli", "address": "https://orcid.org/..." },

    \ \ \ \ \ \ "state": { "4f1c...": ["fractional-phi42-mass-gap.tm"], ... }

    \ \ \ \ }

    \ \ },

    \ \ "fixity": { "md5": { ... }, "sha256": { ... } }

    }
  </verbatim-code>

  The state of a version maps each digest to the logical paths that have it. Logical paths stay the same from version to version, and OCFL stores a file only once if it does not change, so a version that changes only the description costs one small file. In each version the user's name is required and the address is an ORCID iD.

  <subsection*|Paper versions and object versions>

  Two numbers are kept apart:

  <\itemize>
    <item>the <strong|paper version> (field <verbatim|version> of <verbatim|datacite.json>): it increases only when the sources or the PDF change. It is what readers see ("version 2"), and it corresponds to a Zenodo record version with its own DOI;

    <item>the <strong|OCFL version> (<verbatim|v1>, <verbatim|v2>, ...): it increases at every change of the object, including changes of the description only, for instance adding the DOI of the journal version later.
  </itemize>

  A description-only change makes a new OCFL version with the same content files and a new <verbatim|datacite.json>; on Zenodo it is an edit of the metadata of the existing record version, not a new DOI. The files on Zenodo are therefore the snapshot made at deposit, including the <verbatim|datacite.json> of that moment; the current description is the head OCFL version, mirrored by the live metadata of the DOI.

  <section*|5. DataCite metadata>

  Each version has a <verbatim|datacite.json> following the DataCite Metadata Schema 4.7, in the JSON form of the DataCite REST API (the <verbatim|attributes> of a DOI). It is written by the tool from a short deposit form and never edited in place. <verbatim|publisher> and <verbatim|affiliation> are written as objects (name and identifier); the REST API returns them as plain strings by default until September 2027, so the tools read both forms.

  <\itemize>
    <item><strong|Identification:> <verbatim|doi> (the DOI of this paper version, reserved on Zenodo before the version is built), <verbatim|version>, <verbatim|url> (the landing page).

    <item><strong|Creators:> names split into family and given names as printed in the paper, ORCID iDs as name identifiers, affiliations with ROR identifiers.

    <item><strong|Titles and descriptions:> title, and the abstract as plain text (description type <verbatim|Abstract>), with mathematics written in LaTeX between dollar signs, converted from the TeXmacs abstract.

    <item><strong|Type:> <verbatim|resourceTypeGeneral> <verbatim|Preprint>.

    <item><strong|Subjects:> MSC2020 codes (<verbatim|subjectScheme> <verbatim|MSC2020>) and free keywords.

    <item><strong|Dates:> <verbatim|Submitted> (deposit date), <verbatim|Available>; <verbatim|Updated> for description-only versions.

    <item><strong|Rights:> <verbatim|rightsList> with the licence's SPDX identifier in lower case (<verbatim|cc-by-4.0>, scheme <verbatim|SPDX>) and its URL, or a custom statement such as "All rights reserved". Metadata itself is CC0, as on Zenodo and DataCite.

    <item><strong|Related identifiers> (the relation types DataCite recommends):

    <\itemize>
      <item><verbatim|IsVersionOf> the concept DOI of the paper;

      <item><verbatim|IsNewVersionOf> the DOI of the previous paper version;

      <item><verbatim|IsIdenticalTo> an arXiv identifier carrying the same content, or <verbatim|IsVariantFormOf> when the content differs;

      <item><verbatim|IsVersionOf> the DOI of the published journal article, added by a description-only version when it appears (DataCite's recommendation for a preprint and its version of record, which in turn has <verbatim|HasVersion>);

      <item>optionally the SWHID of the sources in Software Heritage (identifier type <verbatim|SWHID>, new in 4.7).
    </itemize>

    <item><strong|No membership.> A paper does not list the collections that include it: membership is stated only by the collections (<verbatim|HasPart>), so that adding a paper to a collection, including someone else's, never changes the paper.

    <item><strong|Formats and sizes:> media types of the files (<verbatim|application/x-texmacs>, <verbatim|application/pdf>).
  </itemize>

  <\verbatim-code>
    {

    \ \ "doi": "10.5281/zenodo.1234567",

    \ \ "version": "1",

    \ \ "types": { "resourceTypeGeneral": "Preprint" },

    \ \ "titles": [ { "title": "Mass gap for the fractional Phi^4_2 model" } ],

    \ \ "creators": [

    \ \ \ \ { "name": "Duch, P.", "nameType": "Personal",

    \ \ \ \ \ \ "affiliation": [ { "name": "Institute of Mathematics, Polish Academy of Sciences" } ] },

    \ \ \ \ { "name": "Gubinelli, M.", "nameType": "Personal",

    \ \ \ \ \ \ "nameIdentifiers": [ { "nameIdentifier": "https://orcid.org/...", "nameIdentifierScheme": "ORCID" } ],

    \ \ \ \ \ \ "affiliation": [ { "name": "Mathematical Institute, University of Oxford" } ] } ],

    \ \ "publisher": { "name": "Zenodo" },

    \ \ "publicationYear": 2026,

    \ \ "subjects": [ { "subject": "81T08", "subjectScheme": "MSC2020" } ],

    \ \ "dates": [ { "date": "2026-11-12", "dateType": "Submitted" } ],

    \ \ "rightsList": [ { "rights": "Creative Commons Attribution 4.0 International",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "rightsIdentifier": "cc-by-4.0", "rightsIdentifierScheme": "SPDX" } ],

    \ \ "descriptions": [ { "description": "We present a new, simple ...", "descriptionType": "Abstract" } ],

    \ \ "relatedIdentifiers": [

    \ \ \ \ { "relatedIdentifier": "10.5281/zenodo.1234566", "relatedIdentifierType": "DOI", "relationType": "IsVersionOf" } ]

    }
  </verbatim-code>

  (The values above are illustrations: the DOIs are not real, and the licence, MSC codes, ORCID iDs and affiliations of each paper are to be confirmed.)

  <section*|6. Collections>

  OCFL deliberately says nothing about collections; this is the part of the design that is specific to the repository.

  <subsection*|Collection objects>

  A collection is an OCFL object like a paper. Each version holds <verbatim|datacite.json> (with <verbatim|resourceTypeGeneral> <verbatim|Collection>, its title, curators as creators, description, licence CC0 for the list itself, and <verbatim|HasPart> relations to the DOIs of the members) and <verbatim|members.json>, the authoritative list of members. Every change of the list (a paper added, removed, or moved to a new version) is a new version of the collection, so the history of the index is kept by the same mechanism as the history of the papers.

  <subsection*|Member references>

  Every member is pinned: a collection version states exactly which version of each member it contains.

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-collection/0.1",

    \ \ "members": [

    \ \ \ \ { "kind": "paper",

    \ \ \ \ \ \ "repository": "https://mgubi.opensheaf.org/ocfl/",

    \ \ \ \ \ \ "id": "fractional-phi42-mass-gap",

    \ \ \ \ \ \ "version": "v1",

    \ \ \ \ \ \ "inventorySha512": "9a0c...",

    \ \ \ \ \ \ "doi": "10.5281/zenodo.1234567",

    \ \ \ \ \ \ "conceptDoi": "10.5281/zenodo.1234566",

    \ \ \ \ \ \ "follow": "latest" },

    \ \ \ \ { "kind": "collection",

    \ \ \ \ \ \ "repository": "https://example.org/papers/ocfl/",

    \ \ \ \ \ \ "id": "collection-seminar-2026",

    \ \ \ \ \ \ "version": "v3",

    \ \ \ \ \ \ "inventorySha512": "51be...",

    \ \ \ \ \ \ "conceptDoi": "10.5281/zenodo.2222222" }

    \ \ ]

    }
  </verbatim-code>

  <\itemize>
    <item>A member is located by its repository and identifier: its inventory for the pinned version is <verbatim|\<less\>repository\<gtr\>\<less\>id\<gtr\>/\<less\>version\<gtr\>/inventory.json>. The SHA-512 of that inventory fixes the member completely, since the inventory lists the digests of all its files. A collection version is then a hash tree over everything it contains, also across repositories.

    <item><verbatim|"follow": "latest"> is a curation setting, not a floating reference: when a followed member gets a new version, the tool writes a new version of the collection with the new pin. Each collection version therefore stays exact.

    <item>A member may live in another repository; nothing is copied. A repository can also mirror another's object by copying it into its own storage root; OCFL objects are self-contained and keep their identifiers.
  </itemize>

  <subsection*|Selections>

  A selection is a collection whose members are collections (or a mix of collections and papers): for instance the papers of a seminar, a thematic selection across several authors' repositories, or a reading list. Because members are pinned by digest, selections compose to any depth without copying, and the verification of a selection follows the references down to the files.

  <section*|7. Zenodo>

  <subsection*|Papers>

  Each paper is one Zenodo record with versions: the concept DOI stands for the paper, each paper version is a record version with its own DOI (prefix <verbatim|10.5281>), resource type "Publication: Preprint".

  <\itemize>
    <item><strong|Files.> Zenodo records have no folders. Flat sources are uploaded as they are, with <verbatim|paper.pdf>, <verbatim|datacite.json> and <verbatim|provenance.json>, and Zenodo's MD5 checksums must agree with the fixity block of the inventory. When the sources have sub-folders, they are uploaded as <verbatim|sources.zip>, built reproducibly (files in sorted order, fixed timestamps, no extra attributes); its digests are recorded in <verbatim|provenance.json>, and the check rebuilds it from the OCFL content.

    <item><strong|Order of operations,> with Zenodo's current REST API (the InvenioRDM records API; the older deposit API is being retired):

    <\itemize>
      <item>(1) create a draft, or a new version of the record (a new version starts without files);

      <item>(2) reserve its DOI;

      <item>(3) write <verbatim|datacite.json> with that DOI and assemble the version in a staging folder;

      <item>(4) upload the files and check the MD5 checksums Zenodo reports;

      <item>(5) publish, which cannot be undone;

      <item>(6) commit the OCFL version, with the Zenodo record in its message, and push.
    </itemize>

    If a step fails before publication, the draft is discarded and nothing changes. Zenodo allows only one unpublished new version of a record at a time: the tool takes a lock for the paper during a deposit.

    <item><strong|Reconciliation.> If publication succeeds but the commit or the push fails, the tool finds the published record that has no OCFL version and completes the version from the staging folder; it refuses any other deposit for that paper until this is done.

    <item><strong|Corrections.> Zenodo lets authors change the files of a published version during 30 days. This is never used here: a correction is a new paper version.

    <item><strong|Description-only changes> are metadata edits of the existing Zenodo record version, matched by a new OCFL version of the object (section 4).
  </itemize>

  <subsection*|Collections>

  <\itemize>
    <item><strong|Communities.> A Zenodo community (for instance "Massimiliano Gubinelli: papers") groups the paper records for browsing on Zenodo; a record can belong to several communities. It is a convenience, not the authoritative list.

    <item><strong|Releases.> A collection is deposited on Zenodo only when it is explicitly released, not at every change: the record version holds <verbatim|datacite.json> and <verbatim|members.json>, so that a released selection has a DOI and a fixed membership. Zenodo has no general collection type; such records use the type "Other", while their DataCite metadata says <verbatim|Collection>.

    <item><strong|The whole repository.> A git tag of the repository can be archived as a snapshot of all the files (Zenodo's GitHub integration archives the source archive of a release; Software Heritage archives the history), which also preserves the presentation layer as it was at that time.
  </itemize>

  <subsection*|Practicalities>

  <\itemize>
    <item><strong|Limits:> up to 100 files and 50 GB per record; uploads go through the files API.

    <item><strong|Tokens:> personal access tokens with the scopes for depositing and for publishing.

    <item><strong|Testing:> the Zenodo sandbox (<verbatim|sandbox.zenodo.org>) has separate accounts and tokens and issues test DOIs (prefix <verbatim|10.5072>); every step is tried there first.

    <item><strong|Licences:> Zenodo's licence chooser uses the SPDX list; any Creative Commons licence can be chosen directly, and "All rights reserved" can be entered as a custom licence. Zenodo publishes all record metadata under CC0.
  </itemize>

  <section*|8. Presentation>

  <\itemize>
    <item><strong|Index.> <verbatim|index.tm> is generated from the head version of the main collection object (<verbatim|collection-papers>) and the template <verbatim|index-template.tm>; <verbatim|index.html> is exported from it by TeXmacs. Each entry shows the title, authors, links, the abstract (in a fold) and the pinned digest, in the style of the website. A flattened <verbatim|index.json> may be generated alongside for programs that do not read OCFL.

    <item><strong|Paper pages.> For each paper, <verbatim|site/\<less\>id\<gtr\>/> holds a landing page with the Google Scholar <verbatim|citation_*> meta tags (title, authors, date, PDF URL), schema.org <verbatim|ScholarlyArticle> JSON-LD, the DOI and the links; the HTML version, exported from a copy of the sources with <verbatim|paper-html.ts> added to its style; and BibTeX and CSL-JSON entries generated from <verbatim|datacite.json>.

    <item><strong|Browsing in TeXmacs.> The index links to the main source of each paper inside the storage root. Because OCFL stores an unchanged file under the version where it first appeared, the generator resolves the logical path of the head version to its content path through the inventory.

    <item><strong|Not authoritative.> All of these files are regenerated from the storage layer; a difference between them and the storage layer is a bug in the generator, never a change of the deposit.
  </itemize>

  <section*|9. Integrity and trust>

  <\itemize>
    <item><strong|Hash tree.> git commit, then collection inventory (with its <verbatim|.sha512> checksum file), then member inventories (pinned by digest), then content files (by digest). Verifying the head of the main collection verifies everything it contains.

    <item><strong|Verification.> Standard OCFL validators check the storage root and each object (<verbatim|ocfl-py> checks both; <verbatim|ocfl-java> checks objects); <verbatim|papers.py verify> adds the checks specific to this design: DataCite fields consistent with the inventory, member pins, the Zenodo checksums (rebuilding <verbatim|sources.zip> where needed), and the presentation layer consistent with the storage layer.

    <item><strong|Authenticity and dates.> Digests show that files were not changed; they do not show who made them or when. For that: signed git tags for each deposit; OpenTimestamps proofs of each inventory checksum file, kept in <verbatim|witnesses/\<less\>object-id\<gtr\>/> outside the storage root (OCFL does not allow them in the object folder, and its <verbatim|logs/> folder is not covered by any digest); and the Zenodo and DataCite records and Software Heritage snapshots as independent witnesses.

    <item><strong|Working copy.> The working copy of the repository should not be synchronised by a file-syncing service such as Dropbox, which can corrupt a git repository; the remote on GitHub and its archives are the copies that count.
  </itemize>

  <section*|10. Rights>

  <\itemize>
    <item>Papers and their sources: the licence chosen for each paper by its authors, recorded in <verbatim|datacite.json>; the co-authors' agreement to the deposit and to the licence is recorded in <verbatim|provenance.json>.

    <item>Metadata, collections and the index: CC0.

    <item>Tools, style packages and page scripts: the licence of each archive's tools (GPL-3.0 in the first archive, as its website and TeXmacs plugins).

    <item>Fonts in <verbatim|resources/>: their own licence (SIL Open Font License for the Source fonts).
  </itemize>

  <section*|11. Open points>

  <\itemize>
    <item><strong|Zenodo:> whether its API accepts file names containing <verbatim|/> (the documentation only says that folders are not supported, so the design assumes flat names); how Zenodo displays LaTeX in descriptions; whether released collections should rather use the type "Dataset".

    <item><strong|Papers:> licence, MSC codes, ORCID iDs and affiliations of every author; the missing bibliography database of the sine-Gordon paper, so that its sources typeset without the stored bibliography.

    <item><strong|Namespace:> the rules for giving <verbatim|opensheaf.org> subdomains to archives (who may have one, and what happens when an archive moves or is abandoned), so that addresses cited inside collections stay valid.

    <item><strong|Validator:> which OCFL validator to run in the tests (<verbatim|ocfl-py> covers storage roots and objects).
  </itemize>

  <section*|12. From the prototype>

  In the first archive, the earlier prototype layout (format <verbatim|mgubi-papers-metadata/0.1>, which predates OpenSheaf) becomes this design as follows: each <verbatim|SLUG/sources/> with its <verbatim|metadata-v1.json> becomes version <verbatim|v1> of a paper object, with the source moved to the top of the content folder and <verbatim|metadata-v1.json> split into <verbatim|datacite.json> and <verbatim|provenance.json>; <verbatim|index.json> becomes <verbatim|members.json> of the collection object <verbatim|collection-papers>; <verbatim|SLUG/html/> moves to <verbatim|site/\<less\>id\<gtr\>/>; and <verbatim|tools/papers.py> is rewritten around the OCFL and DataCite files. Nothing of the prototype has been published, so the two deposits can be rebuilt as first versions without keeping the old format.

  <section*|13. Sources>

  <\itemize>
    <item><hlink|OCFL 1.1 specification|https://ocfl.io/1.1/spec/> and <hlink|OCFL extensions|https://ocfl.github.io/extensions/>

    <item><hlink|DataCite Metadata Schema 4.7|https://schema.datacite.org/>, <hlink|DataCite guidance on preprints|https://support.datacite.org/docs/preprints-post-prints-and-author-manuscripts> and <hlink|the REST API change for publisher and affiliation|https://support.datacite.org/docs/datacite-rest-api-affiliation-and-publisher-default-change>

    <item><hlink|Zenodo developer documentation|https://developers.zenodo.org/>, <hlink|InvenioRDM records API|https://inveniordm.docs.cern.ch/reference/rest_api_drafts_records/>, <hlink|Zenodo on folders|https://support.zenodo.org/help/en-gb/1-upload-deposit/74-can-i-upload-folders-directories>, <hlink|managing files|https://help.zenodo.org/docs/deposit/manage-files/>, <hlink|resource types|https://zenodo.org/api/vocabularies/resourcetypes> and <hlink|versioning|https://zenodo.org/help/versioning>

    <item><hlink|Zenodo licences|https://help.zenodo.org/docs/deposit/describe-records/licenses> and <hlink|general policies|https://about.zenodo.org/policies>
  </itemize>

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
