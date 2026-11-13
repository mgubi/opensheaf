<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|OpenSheaf: an open format for document archives and collections>

  <notes-abstract|Specification, version 0.1 (draft), 13 November 2026. OpenSheaf is a common, open format for archives of scholarly documents and for collections of them, built on the Oxford Common File Layout (OCFL 1.1) and the DataCite Metadata Schema (4.7). This version is experimental and may change in incompatible ways before version 1.0. The text is licensed under CC BY-SA 4.0; the JSON Schemas are dedicated to the public domain under CC0 1.0.>

  <os-alert|warning|Warning.|<strong|Draft.> This version is a draft. Until version 1.0, any revision may change the format in incompatible ways (one already did: <verbatim|provenance.json> became <verbatim|object.json>), and archives and collections made now may have to be rebuilt or migrated. Do not rely on it yet for anything you cannot redo. Changes are listed in the changelog (section 17) and discussed in the <hlink|issues|https://github.com/opensheaf/opensheaf/issues>.>

  <section*|1. Introduction (non-normative)>

  OpenSheaf is meant as a lean alternative to arXiv and to the usual publication infrastructure. Any author, group or institution can keep an archive of its documents as plain files, served as a static website, checkable by anyone, and composable with other archives:

  <\itemize>
    <item><strong|Sources, not only PDFs.> A deposit keeps the sources of a document with its renditions (a PDF, typically), so that the archive can be read as a website and in the authoring tool.

    <item><strong|Fixed versions.> Every version of every document is fixed by content hashes and never changes once deposited. Corrections are new versions, and the history can be verified from the files alone.

    <item><strong|Standards, not inventions.> Storage follows OCFL 1.1 and description follows DataCite 4.7. This specification only defines what these leave open: discovery of an archive, collections, provenance, withdrawal, and the profiles for external services and tools.

    <item><strong|Composable collections.> A collection is itself a versioned object. It can include documents and collections of other archives, pinned by digest, so that selections (by a seminar, an editorial board, a reading list) compose without copying.

    <item><strong|External services are optional.> Archives may deposit their documents with a DOI service such as Zenodo, publish them as a website, and keep their files in git; none of this is required by the core of the format.
  </itemize>

  Answers to common questions about the design are collected in the <hlink|FAQ|https://github.com/opensheaf/opensheaf/blob/main/FAQ.md>.

  The name: a sheaf is a bundle of papers and, in mathematics, the structure in which local pieces glue into a whole, as archives kept and verified separately compose into collections. The home of the format is <verbatim|https://opensheaf.org/>. The first OpenSheaf archive is <verbatim|https://mgubi.org/papers/>; its values appear in the examples.

  <section*|2. Conventions>

  The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, NOT RECOMMENDED, MAY and OPTIONAL in this document are to be interpreted as described in BCP 14 (RFC 2119 and RFC 8174) when, and only when, they appear in all capitals.

  Sections marked non-normative, examples, notes and the appendices marked as such are informative. JSON means RFC 8259 JSON encoded in UTF-8 without a byte order mark. URLs are absolute unless stated otherwise; a relative URL in a JSON file is resolved against the URL of that file.

  <section*|3. Terminology>

  <\itemize>
    <item><strong|Archive:> a set of objects kept by one owner (a person, group or institution), with one storage root and one discovery document, identified by an archive identifier.

    <item><strong|Archive identifier:> a URI naming the archive independently of where it is served (section 6).

    <item><strong|Base URL:> the URL at which an archive is currently served, ending with <verbatim|/>; its discovery document is at <verbatim|\<less\>base URL\<gtr\>opensheaf.json>.

    <item><strong|Storage root:> an OCFL 1.1 storage root holding the objects of the archive.

    <item><strong|Object:> an OCFL object. Its <strong|kind> is <verbatim|document> or <verbatim|collection>.

    <item><strong|Document:> an object holding one scholarly work (an article, notes, a thesis, a book) with its sources and renditions.

    <item><strong|Collection:> an object holding a list of members. A collection is an archive collection or a selection (section 10.1).

    <item><strong|Archive collection:> a collection that keeps objects whole, impartial about their versions: each member pins an object with all its versions, and may follow it as it grows. An archive's main collection, and the list of objects an archive mirrors, are archive collections.

    <item><strong|Selection:> a collection that vets particular revisions of documents (a journal, a digest, a review journal, a reading list): each member pins a revision set, and earlier or later versions are not part of the selection unless its curator adds them, by a new version of the selection.

    <item><strong|Revision:> a document version, as vetted by a selection, pinned by the object version that held it when it was vetted.

    <item><strong|Revision set:> the revisions of one document vetted by a selection (usually one; more after a correction).

    <item><strong|Mirror:> a copy, in an archive's storage root, of another archive's object, whole and byte for byte (section 10.4).

    <item><strong|Accepted copy:> a document of a selection's archive holding exactly the files of a revision it vetted from another archive (section 10.5).

    <item><strong|Object version:> an OCFL version of an object (<verbatim|v1>, <verbatim|v2>, ...). It changes at every change of the object.

    <item><strong|Document version:> the version of the work, a positive integer numbered by the archive, in <verbatim|object.json> and <verbatim|datacite.json>. It changes exactly when the document's own files change (section 7.3).

    <item><strong|Description-only version:> an object version that holds an existing document version with its files unchanged, changing only the description, the state or the notices of the object (section 7.3).

    <item><strong|History:> the order of a document's versions in the history of the work (section 7.3).

    <item><strong|Current version:> the document version to which readers are directed: the last in the history.

    <item><strong|Note:> a short text, a file of the content, or both, as used for change notes, notices and withdrawals (section 9).

    <item><strong|Member:> an entry of a collection: an object (in an archive collection) or a revision set of a document (in a selection), of any archive.

    <item><strong|Pin:> the pair (object version, SHA-512 digest of that version's inventory file).

    <item><strong|Rendition:> a file produced from the sources and deposited with them (a PDF, an EPUB).

    <item><strong|Presentation:> files generated from the archive for readers (web pages, indexes, HTML versions of documents). It is never authoritative.

    <item><strong|Witness:> an independent copy or proof: a signature, a timestamp, an external deposit, a software archive snapshot.

    <item><strong|Verifier:> a program that checks an archive or a collection against this specification.
  </itemize>

  <section*|4. Conformance>

  This specification defines the following conformance classes. An archive, object or program conforms to a class if it satisfies every MUST and MUST NOT of the sections listed for it.

  <\itemize>
    <item><strong|OpenSheaf archive:> sections 5 to 13 and 16 (section 10 for the collections it contains).

    <item><strong|OpenSheaf collection:> section 10, in addition to the requirements on objects in sections 7 to 9.

    <item><strong|OpenSheaf verifier:> sections 12 (as a reader), 14 and 15. Tools that build presentations follow the requirements on presentations in sections 11.1, 15 and appendix C.

    <item><strong|Profiles>, optional: an archive MAY additionally conform to the Zenodo binding (appendix A), the TeXmacs profile (appendix B) and the website profile (appendix C). A conforming archive MUST state in its discovery document which profiles it follows.
  </itemize>

  The JSON files defined here (<verbatim|opensheaf.json>, <verbatim|object.json>, <verbatim|members.json>) MUST validate against the JSON Schemas of appendix D for their declared format version.

  <section*|5. Layout>

  An archive consists of:

  <\itemize>
    <item><strong|A discovery document>, <verbatim|opensheaf.json>, at its base URL (section 6). It is REQUIRED.

    <item><strong|A storage root>, REQUIRED, conforming to OCFL 1.1, at a URL given by the discovery document. It MUST use the storage layout extension <verbatim|0002-flat-direct-storage-layout>, so that an object with identifier <verbatim|\<less\>id\<gtr\>> is at <verbatim|\<less\>storage root URL\<gtr\>\<less\>id\<gtr\>/>. It MAY contain, as loose files allowed by OCFL, a copy of the OCFL specification and of this specification.

    <item><strong|Witnesses>, OPTIONAL: signatures and timestamp proofs of object versions, in each object's extension folder <verbatim|extensions/opensheaf-witnesses/>, or under <verbatim|witnesses/> next to the discovery document (section 13.2).

    <item><strong|Presentation files>, OPTIONAL, anywhere outside the storage root and <verbatim|witnesses/> (appendix C).
  </itemize>

  Because OCFL does not allow directories other than objects and extensions inside a storage root, the storage root SHOULD be a dedicated folder (by convention <verbatim|ocfl/>), and presentation files MUST NOT be placed inside it.

  All files of the discovery document, the storage root and <verbatim|witnesses/> (if used) MUST be served byte for byte, as stored: no conversion of line endings or character sets, no compression that changes the bytes delivered after decoding. Archives kept in git SHOULD mark these files as binary (for instance with <verbatim|.gitattributes> lines <verbatim|ocfl/** -text> and <verbatim|opensheaf.json -text>). Archives SHOULD be served over HTTPS and SHOULD allow cross-origin requests to these files (<verbatim|Access-Control-Allow-Origin: *>), so that tools running in a browser can resolve members.

  An archive MAY be kept in git and served by any static web server (GitHub Pages, object storage, a university server). A deployment guide, outside this specification, discusses hosting limits and practices.

  <section*|6. Discovery and identity>

  <subsection*|6.1 The discovery document>

  The discovery document is the JSON file <verbatim|opensheaf.json> at the base URL of the archive. It MUST contain:

  <\itemize>
    <item><verbatim|format>: <verbatim|"opensheaf-archive/0.1">;

    <item><verbatim|specification>: the version of this specification the archive follows, <verbatim|"0.1">;

    <item><verbatim|archiveId>: the archive identifier (section 6.2);

    <item><verbatim|name>: a human-readable name;

    <item><verbatim|storageRoot>: the URL of the storage root, ending with <verbatim|/> (relative URLs are allowed);

    <item><verbatim|storageLayout>: <verbatim|"0002-flat-direct-storage-layout">;

    <item><verbatim|objects>: the list of all objects in the storage root, each with <verbatim|id>, <verbatim|kind>, <verbatim|head> (the head object version), <verbatim|inventorySha512> (the SHA-512 digest of the head inventory, as written in its checksum file) and <verbatim|status> (<verbatim|active> or <verbatim|withdrawn>, section 11); a mirror (section 10.4) also has <verbatim|mirrorOf>, the archive identifier of the archive whose object it copies.
  </itemize>

  It MUST also contain <verbatim|profiles>, the list of profiles followed, from <verbatim|zenodo>, <verbatim|texmacs>, <verbatim|website> (an empty list if none). It SHOULD contain <verbatim|mainCollection> (the identifier of the collection that lists the archive's own documents) and <verbatim|contact> (a URI). It MAY contain <verbatim|mirrors> (base URLs of complete copies of the archive), <verbatim|tombstones> (section 11.3), <verbatim|keys> (section 13.2) and <verbatim|feed> (the URL of an Atom feed of new object versions).

  The discovery document is mutable: it is rewritten whenever an object is added or changed. It is a map, not a witness: what it states about objects (<verbatim|objects>: kinds, head versions, digests, status) MUST be verifiable from the storage root. Digests are written in lowercase hexadecimal, here and in every file defined by this specification.

  <subsection*|6.2 Archive identifiers>

  An archive identifier is a URI that does not change when the archive moves. It SHOULD be a <verbatim|tag:> URI (RFC 4151) built from a domain or e-mail address controlled by the owner at the time of creation and a date, for instance <verbatim|tag:opensheaf.org,2026:mgubi>. A DOI or another persistent URI MAY be used instead. Two different archives MUST NOT use the same archive identifier.

  <subsection*|6.3 Object identifiers>

  An object identifier MUST match <verbatim|^[a-z0-9]+(-[a-z0-9]+)*$> and MUST be at most 64 characters long. It is the OCFL <verbatim|id> of the object and the name of its folder in the storage root. It MUST be unique in the archive and MUST NOT be reused, also after a takedown. Since it is permanent and appears in every URL of the object, it SHOULD be short (at most 32 characters), readable and chosen by the depositor, and SHOULD NOT be derived mechanically from the title, which may change between versions while the identifier cannot; tools importing documents propose identifiers and the depositor decides. The kind of an object is given by its <verbatim|object.json>, never by its identifier. Outside the archive, an object is named by the pair (archive identifier, object identifier).

  <subsection*|6.4 Resolution>

  To fetch an object version of a member, a client:

  <\itemize>
    <item>reads the discovery document at the member's archive URL (section 10.2) and fetches <verbatim|\<less\>storageRoot\<gtr\>\<less\>id\<gtr\>/\<less\>version\<gtr\>/inventory.json>;

    <item>if this fails, tries the mirrors listed in the member, then those listed in the archive's discovery document;

    <item>if this fails, MAY use external copies: the files of an external record named in the version's <verbatim|object.json> (a DOI record), or a software archive snapshot (a SWHID).
  </itemize>

  Any copy whose bytes match the pinned digest is acceptable: integrity comes from the pin, not from the place.

  <section*|7. Objects>

  <subsection*|7.1 Common rules>

  Every object MUST be a valid OCFL 1.1 object. Its inventories MUST use <verbatim|sha512> as digest algorithm. Every object version MUST contain, in its content, the files <verbatim|object.json> and <verbatim|datacite.json> at the top level. Every version directory MUST contain a copy of the inventory as of that version, with its checksum file (OCFL makes this a recommendation; OpenSheaf requires it, so that each version can be pinned and fetched on its own). Version directories MUST NOT be zero-padded (<verbatim|v1>, <verbatim|v2>, ..., not <verbatim|v001>), which OCFL allows. OCFL recommends that object identifiers be URIs; OpenSheaf identifiers are short names (section 6.3), so OCFL validators may warn about them.

  Each version in the inventory MUST have a <verbatim|user> with a <verbatim|name>, and SHOULD have an <verbatim|address> (an ORCID iD, a <verbatim|mailto:> URI or another URI identifying the depositor), and MUST have a <verbatim|message> describing the change. The inventory is the record of deposits: the <verbatim|created> date and the <verbatim|user> of an object version are when and by whom it was deposited, and the deposit of a document version is that of the first object version holding it. They are not repeated in <verbatim|object.json>.

  Logical paths MUST be encoded in UTF-8 in Unicode normalisation form C, MUST NOT begin with <verbatim|/>, and MUST NOT contain <verbatim|.> or <verbatim|..> segments.

  <subsection*|7.2 Documents>

  A document version contains, at the top level of its content unless a profile says otherwise:

  <\itemize>
    <item>the <strong|sources>: the main source and every file needed to produce the renditions that is not part of the toolchain (images, bibliography databases, local style files). The main source is named in <verbatim|object.json>. Sources SHOULD be flat (no sub-folders) when possible. When the sources of a version are not available (for instance a version imported from a service that keeps only its PDF), the version has none, and <verbatim|object.json> says so (section 9);

    <item>the <strong|renditions>, OPTIONAL but RECOMMENDED: at least a PDF for documents meant to be read and cited, named in <verbatim|object.json>;

    <item>the files of notes, if any (the change note, notices, a withdrawal; section 9), named in <verbatim|object.json>;

    <item><verbatim|datacite.json> (section 8) and <verbatim|object.json> (section 9).
  </itemize>

  HTML versions and other presentation files SHOULD NOT be deposited, since they depend on the presentation and are regenerated when it improves.

  <subsection*|7.3 Document versions>

  <strong|Numbering.> Document versions are numbered by the archive, from 1, without gaps, independently of any external numbering: a work whose versions 1, 3 and 4 are available on arXiv has document versions 1, 2 and 3. External labels (arXiv's <verbatim|v3>) are recorded in <verbatim|external> (section 9), and presentations SHOULD show them with the document version.

  <strong|New versions.> A new document version number is assigned exactly when files of the document's own (sources, renditions, change note) that were not deposited before are added, except when a version without sources is completed (below). An object version holding the same sources, renditions and change note as an earlier document version keeps its number.

  <strong|Description-only versions.> A description-only version holds an existing document version, with its files unchanged, and changes only its description (<verbatim|datacite.json>, such as a DOI, a stage or a link to the published article), the state of the object or its notices. It MAY hold any document version, not only the current one, so that an earlier version can be described after later versions exist; tools otherwise hold the current version. If the object has <verbatim|history>, its entry for that document version becomes the new object version.

  <strong|Completion.> A document version recorded without sources (section 9, <verbatim|sourcesMissing>) MAY be completed later, keeping its number: the completing object version adds the sources, and MAY add renditions produced from them (for instance a PDF typeset from the added sources, beside the one received), but changes or removes no file of the version; until the sources are complete it keeps <verbatim|sourcesMissing> and names no main source; the object version that completes them names the main source and removes <verbatim|sourcesMissing>, after which the version is fixed like any other.

  <strong|Other versions.> A version that was not public at the time, such as the manuscript submitted to a journal, deposited later, is a document version like any other. A version published by someone else, such as the journal's version of record, is not a document version of the author's object: it is linked by a relation (section 8.1).

  <strong|History.> The order of the document versions in the history of the work is the order of their numbers, unless <verbatim|object.json> has <verbatim|history> (section 9): the list, in the order of the work, of the last object version holding each document version. The last object version is used because it carries the most complete description of that document version (a DOI added later, a corrected stage). An object version that deposits a document version out of order (an earlier version found later) MUST write <verbatim|history>, and once an object version has <verbatim|history>, every later object version MUST have it. A version whose place in the history is unknown goes just before the current version, and its <verbatim|object.json> SHOULD say so in its change note. The history is read from the head version; earlier object versions keep the history as it was known when they were made.

  <strong|Current version.> The current version of a document is the last entry of the history of its head version (without <verbatim|history>: the highest document version). The head may hold another document version, after an earlier version is deposited out of order or described by a description-only version; the current version stays where it was. Landing pages, indexes and citations use the current version, not the head; selections vet revisions explicitly (section 10.2).

  <strong|Notices.> A notice about a document version (for instance that a theorem of version 2 is wrong as stated, and is corrected in version 3) is written after that version, which cannot change. Notices are added to <verbatim|notices> in <verbatim|object.json> (section 9) by description-only versions. A notice present in an object version is present, unchanged, in every later object version; a notice is corrected or withdrawn by a later notice that says so. Presentations showing a document version SHOULD show the current notices about it.

  Dates never order document versions and never decide the current version (section 8).

  <subsection*|7.4 Collections>

  A collection version contains <verbatim|datacite.json>, <verbatim|object.json> and <verbatim|members.json> (section 10), which states whether the collection is an archive collection or a selection. Its <verbatim|object.json> declares <verbatim|kind> <verbatim|collection>; its document version counts the changes of the member list, and it has none of the fields specific to documents (<verbatim|mainSource>, <verbatim|sourceFormat>, <verbatim|sourcesMissing>, <verbatim|renditions>, <verbatim|toolchain>, <verbatim|changes>, <verbatim|stage>, <verbatim|history>, <verbatim|notices>).

  <section*|8. Description: datacite.json>

  Every object version MUST contain <verbatim|datacite.json>, a JSON object with the DataCite 4.7 properties in the form of the <verbatim|attributes> of a DOI in the DataCite REST API. It is the authoritative description of the object version. It MUST contain:

  <\itemize>
    <item><verbatim|titles>, <verbatim|creators> (with <verbatim|name>, and <verbatim|nameType>; personal names SHOULD also have <verbatim|givenName> and <verbatim|familyName>), <verbatim|publicationYear>, <verbatim|types> (with <verbatim|resourceTypeGeneral>), <verbatim|version> (the document version, as a decimal string without leading zeros, such as <verbatim|"3">), and <verbatim|publisher>.
  </itemize>

  It SHOULD contain:

  <\itemize>
    <item><verbatim|descriptions> with a <verbatim|descriptionType> <verbatim|Abstract>, as plain text with mathematics as below;

    <item><verbatim|subjects> with a <verbatim|subjectScheme> (any scheme; MSC2020 is common in mathematics);

    <item><verbatim|dates>, as below;

    <item><verbatim|rightsList>: for a licence with an SPDX identifier, that identifier in lower case and the licence URL; for a licence without one, its name in <verbatim|rights> and the URL identifying it in <verbatim|rightsUri> (for arXiv's default licence, <verbatim|http://arxiv.org/licenses/nonexclusive-distrib/1.0/>), which MUST then be present, so that archives record the same licence the same way; or a statement such as "All rights reserved", without URL;

    <item><verbatim|language>, <verbatim|formats> (the media types of the sources and renditions) and <verbatim|sizes>;

    <item>identifiers of creators (ORCID) and of affiliations (ROR), where they exist;

    <item><verbatim|relatedIdentifiers> (section 8.1).
  </itemize>

  <verbatim|publisher> is the archive's name, or the external service registering a DOI for the version (appendix A). <verbatim|publisher> and <verbatim|affiliation> SHOULD be written as objects (with <verbatim|name> and, where available, an identifier); readers MUST also accept plain strings.

  <verbatim|doi> and <verbatim|url> are OPTIONAL: they are present when the version has a DOI. <verbatim|types> gives the kind of content: <verbatim|resourceTypeGeneral> from DataCite's list (<verbatim|Preprint>, <verbatim|JournalArticle>, <verbatim|Book>, <verbatim|Dissertation>, <verbatim|Report>, <verbatim|Text>, <verbatim|Dataset>, <verbatim|Software>, <verbatim|Audiovisual> and so on, and <verbatim|Collection> for collections), with <verbatim|resourceType> for detail (for instance "Lecture notes"). An author's versions of a work not published elsewhere are <verbatim|Preprint>, also the accepted manuscript; the stage of a version is given by <verbatim|stage> in <verbatim|object.json> (section 9).

  <strong|Dates.> Dates are information for readers and services: they never order document versions (section 7.3). Each date type has one meaning:

  <\itemize>
    <item><verbatim|Issued>: the first public appearance of the work, anywhere; the same in every version. RECOMMENDED for documents; tools importing works published elsewhere SHOULD set it.

    <item><verbatim|Available>: when this document version first became public, anywhere: for a version imported from another service, its date there; for a version first made public by this archive, the date of its deposit (section 7.1). SHOULD be present.

    <item><verbatim|Updated>: the date of the latest description-only version holding this document version; absent when the document version has had none.

    <item><verbatim|Created> (when a version was written, for a version not public at the time), <verbatim|Submitted> and <verbatim|Accepted> (journal milestones), OPTIONAL.

    <item><verbatim|Withdrawn>: the date of a withdrawal, equal to <verbatim|withdrawal.date> in <verbatim|object.json> (section 11.1).
  </itemize>

  <strong|Mathematics in titles and abstracts.> Titles and abstracts are plain text in which mathematics MAY be written in LaTeX between single dollar signs (<verbatim|$\\Phi^4_3$>); a literal dollar sign is written <verbatim|\\$>. The LaTeX SHOULD use only the mathematical commands of LaTeX with the <verbatim|amsmath> and <verbatim|amssymb> packages, which common renderers (MathJax, KaTeX) display without the document's preamble; presentations render it, and readers that do not are left with readable LaTeX. Tools importing titles and abstracts from elsewhere SHOULD replace the authors' own macros (such as <verbatim|\\R> or <verbatim|\\be>) with standard LaTeX when their definitions are known, for instance from the preamble of the imported sources, and otherwise keep them unchanged; they MUST NOT invent definitions.

  Dates MAY be approximate, as DataCite allows (<verbatim|2019>, <verbatim|2019-03>, a range <verbatim|2018/2019>), with <verbatim|dateInformation> explaining them (for instance "from file timestamps"); unknown dates are omitted.

  <subsection*|8.1 Relations>

  <\itemize>
    <item>A document version with a DOI SHOULD have <verbatim|IsVersionOf> the concept DOI of the document, and <verbatim|IsNewVersionOf> the DOI of the document version before it in the history (section 7.3), if that version has a DOI. Relations state what was known when a version was described; after a version is deposited out of order, the relation of the version that follows it MAY be corrected by a description-only version.

    <item>The same work published elsewhere SHOULD be linked with <verbatim|IsIdenticalTo> (same content, for instance an arXiv version) or <verbatim|IsVariantFormOf> (different content or form).

    <item>A preprint SHOULD be linked to its later published article with <verbatim|IsVersionOf> the article's DOI, as DataCite recommends; consumers distinguish this relation from the concept DOI by its target. It is added by a description-only version.

    <item>The sources MAY be linked to a software archive snapshot (<verbatim|relatedIdentifierType> <verbatim|SWHID>).

    <item>A collection version MUST have <verbatim|HasPart> for each member (each revision, in a selection) that has a version DOI, pointing to that version DOI. Members without a DOI are listed only in <verbatim|members.json>.

    <item>A document MUST NOT state the collections that include it: membership is stated only by collections, so that including a document in any collection never changes the document.
  </itemize>

  <section*|9. The object: object.json>

  Every object version MUST contain <verbatim|object.json>, OpenSheaf's record of the object as of that version: its identity, the structure of its content, its versions and its state. It MUST contain:

  <\itemize>
    <item><verbatim|format>: <verbatim|"opensheaf-object/0.1">;

    <item><verbatim|specification>: <verbatim|"0.1">;

    <item><verbatim|kind>: <verbatim|document> or <verbatim|collection>;

    <item><verbatim|archiveId> and <verbatim|objectId>;

    <item><verbatim|documentVersion>: a positive integer, equal to the <verbatim|version> of <verbatim|datacite.json>;

    <item><verbatim|status>: <verbatim|active> or <verbatim|withdrawn> (section 11).
  </itemize>

  A document MUST also have <verbatim|mainSource> (a logical path) and <verbatim|sourceFormat> (the media type of the main source), and SHOULD have <verbatim|renditions> (a list of objects with <verbatim|path>, a logical path, and <verbatim|mediaType>) and <verbatim|toolchain> (a list of tools with <verbatim|name>, <verbatim|version> and, optionally, <verbatim|packages>), enough to reproduce the renditions. A document version whose sources are not available instead has <verbatim|sourcesMissing>, a note (see below) saying why (for instance "arXiv keeps only the PDF of this version"), no <verbatim|mainSource> and <verbatim|sourceFormat>, and at least one rendition; a rendition is never presented as a source.

  A <strong|note> is an object with <verbatim|text> (a short plain text), or <verbatim|path> and <verbatim|mediaType> (a file of the content of the same object version), or both: the text serves feeds, indexes and external services, the file holds the full statement (with mathematics, or as a PDF). Files of notes are covered by the inventory like every file of the content.

  A document MAY contain:

  <\itemize>
    <item><verbatim|changes>: a note saying what changed in this document version, written and deposited with it (like arXiv's comments). It is part of the document version (section 7.3);

    <item><verbatim|stage>: the stage of this document version, an object with <verbatim|scheme> and <verbatim|value>. For articles the RECOMMENDED scheme is <verbatim|NISO-JAV>, the NISO Journal Article Versions: <verbatim|AO> (author's original), <verbatim|SMUR> (submitted manuscript under review), <verbatim|AM> (accepted manuscript), <verbatim|P> (proof), <verbatim|VoR> (version of record), <verbatim|CVoR> (corrected version of record), <verbatim|EVoR> (enhanced version of record). Other kinds of content use other schemes (editions, software releases), named by the archive. A description-only version MAY add or correct it;

    <item><verbatim|history>: the list of object versions giving the order of the document versions (section 7.3);

    <item><verbatim|notices>: a list of notices (section 7.3), each a note with the <verbatim|documentVersion> it is about and a <verbatim|date>.
  </itemize>

  Any object MAY contain:

  <\itemize>
    <item><verbatim|licence>: a note with the full text or terms of the licence of the content, kept in the package (useful for licences without an SPDX identifier); <verbatim|rightsList> in <verbatim|datacite.json> remains the description for readers and services;

    <item><verbatim|agreement>: a minimal record that the authors agreed to the deposit and to the licence: <verbatim|by> (the names of those who agreed, names only), <verbatim|date>, and <verbatim|method> (how, for instance "by e-mail"), all three required. It MUST NOT contain e-mail addresses, correspondence or signatures of persons;

    <item><verbatim|external>: the external records of this version, each with its <verbatim|role> (required): <verbatim|deposit> for a deposit of the version made by the archive (appendix A), <verbatim|source> for the record it was imported from; the <verbatim|service> (required, its name), the <verbatim|record> (required, the URL of the record), the <verbatim|doi>, the <verbatim|label> the service gives the version (for instance <verbatim|v3> on arXiv), and <verbatim|files>: the files kept there that are not in the content (for a deposit, such as a source archive uploaded instead of the sources) or the files received from it (for a source, as they were received before being unpacked), each with <verbatim|name> and <verbatim|sha512> (required), <verbatim|md5> and <verbatim|bytes>;

    <item><verbatim|withdrawal> (section 11).
  </itemize>

  <verbatim|object.json> is metadata and is placed under CC0 (section 16).

  <section*|10. Collections: members.json>

  <subsection*|10.1 Archive collections and selections>

  Collections are of two kinds, which differ in how they treat the versions of their members.

  <\itemize>
    <item>An <strong|archive collection> keeps objects whole and is impartial about their versions. Each member pins an object, with all its versions, and the collection may follow it as it grows, whoever adds the versions: the owner of the object decides what its versions are. An archive's main collection (its own documents) and the list of objects an archive mirrors (section 10.4) are archive collections.

    <item>A <strong|selection> vets particular revisions: a journal its accepted version, a digest or a review journal the version it reviewed, a reading list the version it recommends. Each member pins a revision set, the document versions the curator vetted; earlier and later versions of the same document are not part of the selection, and the selection changes only by an explicit act of its curator, which is a new version of the selection. A selection may also keep its own copies of the revisions it vetted (section 10.5).
  </itemize>

  Both kinds may contain collections as members (an archive of archives, a selection of issues). <verbatim|members.json> states the kind.

  <subsection*|10.2 The member list>

  A collection version MUST contain <verbatim|members.json> with:

  <\itemize>
    <item><verbatim|format>: <verbatim|"opensheaf-collection/0.1">;

    <item><verbatim|type>: <verbatim|"archive"> or <verbatim|"selection">;

    <item><verbatim|members>: a list, in the order in which the members are presented. This order is authoritative: presentations MUST present members in it.
  </itemize>

  It MAY contain <verbatim|order>, the rule by which tools maintaining the collection place members: <verbatim|manual> (the default: tools append new members and never reorder), <verbatim|issued-desc> or <verbatim|issued-asc> (by the members' <verbatim|Issued> date, then their <verbatim|Available> date, members with neither last, ties broken by object identifier, so that the result is reproducible).

  Each member MUST have:

  <\itemize>
    <item><verbatim|kind>: <verbatim|document> or <verbatim|collection>;

    <item><verbatim|archive>: the archive identifier of the member's archive;

    <item><verbatim|archiveUrl>: the base URL of that archive when the collection version was made;

    <item><verbatim|id>: the object identifier.
  </itemize>

  Each member MAY have <verbatim|mirrors> (base URLs of archives holding a copy: section 10.4 for archive collections, section 10.5 for the accepted copy of a selection's revision), <verbatim|doi> (the version DOI), <verbatim|conceptDoi> and <verbatim|cite>, a cached citation (<verbatim|title>, <verbatim|creators> as a list of names, <verbatim|year>, and <verbatim|issued>, the member's <verbatim|Issued> date) so that the collection stays readable, and can be ordered, without resolving its members, also if they become unavailable. <verbatim|cite> is not authoritative.

  <strong|Members of an archive collection> MUST have <verbatim|version>, the pinned object version (the head of the object when the collection version was made), and <verbatim|inventorySha512>, the SHA-512 digest of that version's inventory file. Since the inventory of an object version lists every earlier version, the pin fixes the object with all its versions up to it. A member MAY have <verbatim|follow>, <verbatim|"latest">: a curation setting, not a floating reference. A tool maintaining the collection reads the member archive's discovery document (or its feed); when the followed object has a new head, the tool writes a new collection version pinning it, whatever the new head holds (a new document version, a description, a notice, a withdrawal): an archive collection does not judge the versions of its members. A withdrawn member stays, and presentations show the withdrawal. Presentations show the current version of each member, read from the history of the pinned version (section 7.3).

  <strong|Members of a selection> MUST have <verbatim|revisions>: a non-empty list of the revisions vetted, in the order of the document's history, each with <verbatim|documentVersion>, <verbatim|version> (the object version vetted, which holds that document version) and <verbatim|inventorySha512> (the digest of its inventory file). They MUST NOT have <verbatim|version>, <verbatim|inventorySha512> or <verbatim|follow> themselves. The revision presented as the selection's is the last of the list. A revision pins the object version that was vetted: descriptions and notices added later by the document's archive are not vetted by the selection, and presentations that show them SHOULD say where they come from. Tools MUST NOT change revision sets on their own: adding a revision (for instance a corrected version, accepted after review), removing one, or adding or removing a member is a new version of the selection, made by its curator, recorded in the inventory (who and when) with a message saying what was decided. A revision set MAY hold several revisions of the same document, for instance a version accepted and its later correction.

  Every member is pinned: a collection version states exactly which object versions it contains, whole objects up to a version in an archive collection, revisions in a selection. A collection version therefore fixes everything it contains, also across archives; since a pin fixes an inventory, which fixes all its files, collections are hash trees. Pins cannot form cycles.

  <subsection*|10.3 Members of other archives>

  A member may belong to another archive. Nothing is copied: the member is resolved as in section 6.4. A reference (a pin without a copy) needs no permission. Copies are of two kinds: mirrors (section 10.4) and accepted copies (section 10.5).

  <subsection*|10.4 Mirrors>

  An archive MAY mirror an object of another archive: copy the whole object, every version with its inventories and files, byte for byte, into its own storage root, under the same identifier (only if no object of its own has it). A mirror is the same object, not a new one: its <verbatim|object.json> files keep naming the original archive, and the discovery document lists it with <verbatim|mirrorOf>, the identifier of the original archive (section 6.1). A mirror is brought up to date only by copying the new versions of the original, which is possible because OCFL objects only grow; it MUST NOT be changed otherwise. Mirroring is allowed only if the licences of all the versions copied allow redistribution. An archive collection MAY list a mirror of a member in the member's <verbatim|mirrors>. An archive that mirrors another archive entirely SHOULD be listed in the <verbatim|mirrors> of that archive's discovery document, with the agreement of its owner.

  Mirrors serve preservation and access (an institution keeping copies of its members' archives, an independent storage site): they are impartial, like archive collections, and carry every version.

  <subsection*|10.5 Accepted copies>

  A selection MAY keep its own copy of a revision it vetted, as a document of the selection's archive, called an accepted copy, so that what it vetted stays available whatever happens to the original. Its first document version holds exactly the files of the vetted revision (every file except <verbatim|datacite.json> and <verbatim|object.json>), byte for byte; its <verbatim|object.json> records the source in <verbatim|external>, with <verbatim|role> <verbatim|source>, <verbatim|service> <verbatim|OpenSheaf>, <verbatim|record> the URL of the source object version, <verbatim|label> the source object identifier and object version (for instance <verbatim|"paper v2">), and <verbatim|files> with one entry, <verbatim|inventory.json>, whose <verbatim|sha512> is the pin of the source version; its <verbatim|datacite.json> describes it with the selection's archive as <verbatim|publisher>, keeps the relations of the source, and links the source version with <verbatim|IsIdenticalTo> (a <verbatim|URL>). Copying requires the right to redistribute only the revision copied.

  Later document versions of an accepted copy are acts of the selection's curator (a corrected version accepted, a notice, a withdrawal); the authors' later versions change nothing in it. The selection lists the accepted copy as its member (a member of its own archive), or the original revision set with the accepted copy's archive in the member's <verbatim|mirrors>.

  A version that the selection makes itself, such as a journal's typeset version of record, is a document of the selection's archive like any other, with the selection as <verbatim|publisher>, the authors' agreement in <verbatim|object.json> (section 9), and relations to the authors' versions (sections 7.3 and 8.1).

  <subsection*|10.6 Rights>

  The member list of a collection is placed under CC0. The licence of a collection never extends to its members. Mirrors and accepted copies keep the licences of what they copy.

  <section*|11. Withdrawal and takedown>

  <subsection*|11.1 Withdrawal>

  A document or collection is withdrawn (for instance retracted by its authors) by a description-only version whose <verbatim|object.json> has <verbatim|status> <verbatim|withdrawn> and a <verbatim|withdrawal> object with a <verbatim|date> and a <verbatim|reason> (a note, section 9), and whose <verbatim|datacite.json> has the same date as <verbatim|Withdrawn>. The status belongs to the object, whatever document version its head holds. Its content is kept, its history remains verifiable, and the discovery document lists it with <verbatim|status> <verbatim|withdrawn>. Presentations MUST show the withdrawal notice with the document.

  <subsection*|11.2 Takedown>

  When content must be removed (by law, or for a breach of rights), the object is deleted from the storage root and a tombstone MUST be added to the discovery document.

  <subsection*|11.3 Tombstones>

  A tombstone records <verbatim|id>, <verbatim|kind>, <verbatim|lastVersion>, <verbatim|inventorySha512> of that version, <verbatim|date> and <verbatim|reason> (plain text, since the discovery document has no content files). Identifiers of tombstoned objects MUST NOT be reused. Verifiers report a pin to a tombstoned object as "removed", not as a corruption. External copies (DOI records, snapshots) follow the rules of their services.

  Note: OCFL 1.1 has no way to remove files from an object short of deleting and rebuilding it. Physical deletion of files, and the flagging of lost or corrupted files, are accepted as in scope for OCFL version 2, with a tombstone or status recorded in the inventory. When that mechanism is published, a later version of this specification will adopt it for takedowns of single files.

  <section*|12. Versioning of this specification>

  This specification is versioned MAJOR.MINOR.PATCH, a form of semantic versioning adapted to a format:

  <\itemize>
    <item>a <strong|major> version (1.0, 2.0) may make incompatible changes;

    <item>a <strong|minor> version (1.1, 1.2) only adds: every file valid under 1.x remains valid under 1.y for y \<gtr\> x, with the same meaning;

    <item>a <strong|patch> version (1.1.1) corrects or clarifies the text without changing any requirement.
  </itemize>

  Before version 1.0, any change of the minor version (0.1, 0.2, ...) may be incompatible, as semantic versioning allows for initial development.

  Every JSON file defined here declares its format version, and the discovery document and every <verbatim|object.json> declare the version of this specification, both as MAJOR.MINOR only (for instance <verbatim|"opensheaf-object/0.1"> and <verbatim|"0.1">): a patch version never changes what is valid, so files do not record it.

  A reader that finds a major version it does not know (or, before 1.0, a minor version it does not know) SHOULD report it and MUST NOT silently treat the files as valid. A reader that finds a later minor version of a major version it knows (from 1.0) reads the files as that major version, ignoring properties it does not know, and SHOULD report the version. For this to work, readers MUST ignore unknown properties in files of a major version they know, and the schemas of this specification do not forbid additional properties.

  While a version is a draft, successive drafts are identified by the date in the heading and by the changelog (section 17). The text of each version is published at <verbatim|https://opensheaf.org/opensheaf-specification-\<less\>MAJOR.MINOR\<gtr\>.md> and is not changed after the version is final, except by patch versions, which are listed in its changelog.

  <section*|13. Integrity and authenticity>

  <subsection*|13.1 Integrity>

  Integrity rests on OCFL digests: every file is fixed by its SHA-512 digest in the inventory, every inventory by its checksum file, and every collection version pins its members by inventory digest. Inventories MAY also record MD5 and SHA-256 digests in their <verbatim|fixity> block; archives following the Zenodo binding MUST record MD5 (appendix A).

  <subsection*|13.2 Authenticity and dates>

  Digests show that files were not changed; they do not show who made them or when. An archive MAY provide, for each object version:

  <\itemize>
    <item><verbatim|\<less\>version\<gtr\>.inventory.json.sha512.sig>: a detached signature of the inventory checksum file of that version (<verbatim|\<less\>version\<gtr\>/inventory.json.sha512>), made with a key listed in <verbatim|keys> of the discovery document (each key with a <verbatim|type>, such as <verbatim|openpgp> or <verbatim|ssh>, and a <verbatim|url> or <verbatim|fingerprint>);

    <item><verbatim|\<less\>version\<gtr\>.inventory.json.sha512.ots>: an OpenTimestamps proof of the same file.
  </itemize>

  These witness files SHOULD be kept in the object's extension folder <verbatim|extensions/opensheaf-witnesses/>, so that they travel with the object when it is copied or mirrored. OCFL allows object extension folders, which are not part of any version; the extension name <verbatim|opensheaf-witnesses> is not yet registered with OCFL, so validators may warn about it. An archive that does not modify object folders after a version is committed MAY instead keep them under <verbatim|witnesses/\<less\>object id\<gtr\>/>, next to the discovery document. Witnesses can be added later, by the owner or by others, and replaced when a proof is upgraded (an OpenTimestamps proof is completed once its attestation is confirmed); they are not covered by the inventory digests, and need not be, since each one is checked directly against the checksum file it names, which the pins fix.

  External deposits (appendix A) and software archive snapshots are further witnesses. Archives kept in git MAY also sign their commits or tags, but git hashes are not part of the integrity chain of this specification.

  <section*|14. Verification>

  A verifier checking an archive MUST:

  <\itemize>
    <item>validate the discovery document, and every <verbatim|object.json> and <verbatim|members.json>, against the schemas of their declared versions, checking formats (dates, URIs) as assertions, which JSON Schema 2020-12 leaves optional;

    <item>validate the storage root and every object against OCFL 1.1 (with a standard OCFL validator or equivalent checks);

    <item>check that the discovery document lists the objects of the storage root with their kinds, head versions, inventory digests and status as their head versions state them, and that no listed object has the identifier of a tombstone; a verifier reading the archive over HTTP cannot list folders, so it checks the listed objects and reports that completeness was not checked, while a verifier with access to the files also checks that no object is missing;

    <item>check the requirements of sections 7 to 11 on every object version, including that <verbatim|datacite.json> and <verbatim|object.json> agree on the document version and on the date of a withdrawal, and that <verbatim|Available>, for a version first made public by the archive, is the date of its deposit (section 7.1);

    <item>check the document versions of each document (section 7.3): object versions with the same document version have the same sources, renditions and change note, except that a version with <verbatim|sourcesMissing> may be completed by adding files (section 7.3); new numbers follow the rule of new versions, without gaps; <verbatim|history>, when present, lists distinct document versions, covers all of them, each entry being the last object version holding its document version; no object version after the first one with <verbatim|history> lacks it; every notice is kept unchanged in every later object version;

    <item>check that each <verbatim|members.json> has a <verbatim|type>, that the members of an archive collection have <verbatim|version> and <verbatim|inventorySha512>, and that the members of a selection have <verbatim|revisions> and none of <verbatim|version>, <verbatim|inventorySha512> or <verbatim|follow>, with distinct document versions;

    <item>for each collection version, resolve each member (each revision, in a selection) as in section 6.4 and check its pin, and for a revision that the pinned object version holds the stated document version, reporting each as verified, mismatch (a copy was found and does not match), unavailable (no copy found) or removed (tombstoned);

    <item>for each mirror (<verbatim|mirrorOf>), check that its <verbatim|object.json> files name that archive; for each accepted copy, check that its first document version holds exactly the files of the source version named in <verbatim|external>, when the source is available.
  </itemize>

  A verifier SHOULD check the witnesses it finds, and the requirements of the profiles the archive declares. It MUST NOT treat the presentation as authoritative. It SHOULD limit the depth and size of the collections it follows, and report when it stops.

  <section*|15. Security considerations>

  <\itemize>
    <item><strong|Untrusted inventories.> Inventories, logical paths and member lists from other archives are untrusted input. Verifiers MUST reject logical paths that break the rules of section 7.1 (absolute, with <verbatim|.> or <verbatim|..> segments, not in Unicode normalisation form C), and SHOULD limit the size of the files they fetch.

    <item><strong|Archives of sources.> Tools unpacking source archives (appendix A) MUST guard against paths leaving the target folder and against archives that expand to excessive sizes.

    <item><strong|Presentation.> A website MUST NOT embed HTML of other archives in its own pages; it links to them. Documents' HTML versions are generated by the archive's own tools.

    <item><strong|Subdomains.> A domain that offers subdomains to archives (as <verbatim|opensheaf.org> does) MUST remove the DNS records of abandoned archives, to prevent takeover by others.

    <item><strong|Weak hashes.> SHA-1 (as in most git repositories) and MD5 are not used for integrity: MD5 appears only for comparison with external services.

    <item><strong|Mutable maps.> The discovery document and presentation files can be changed by whoever controls the server; their statements are only trusted after checking them against the storage root and the pins.
  </itemize>

  <section*|16. Privacy and rights>

  <\itemize>
    <item><strong|Documents.> Each document carries the licence chosen by its authors in <verbatim|rightsList>. "All rights reserved" is allowed: deposit grants readers access, not reuse.

    <item><strong|Metadata.> <verbatim|datacite.json>, <verbatim|object.json>, <verbatim|members.json>, inventories and the discovery document are placed under CC0, so that they can be harvested and mirrored freely.

    <item><strong|Personal data.> Archives record only the personal data needed to describe and cite the work (names, identifiers, affiliations) and the depositor of each version. The depositor is recorded in the inventory (section 7.1). Agreement records are minimal (section 9). A request to erase personal data from an immutable history is handled by a takedown (section 11.2).
  </itemize>

  <section*|17. Changelog>

  <\itemize>
    <item><strong|0.1 (draft), 13 November 2026:> first version.

    <item><strong|0.1 (draft), 13 November 2026, revision:> collections are archive collections or selections (<verbatim|type> in <verbatim|members.json>): an archive collection pins objects whole and may follow them; a selection pins revision sets, the document versions it vetted, and changes only by an act of its curator. Mirrors (whole objects, <verbatim|mirrorOf> in the discovery document) and accepted copies (one vetted revision, as a document of the selection's archive) are defined. <verbatim|follow> is for archive collections only, and follows the head.
  </itemize>

  <section*|Appendix A. Zenodo binding (normative for archives declaring the profile <verbatim|zenodo>)>

  Zenodo issues DataCite DOIs (prefix <verbatim|10.5281>) and keeps files permanently. Under this binding:

  <\itemize>
    <item><strong|Records.> Each document is one Zenodo record with versions: the concept DOI stands for the document, and each document version is one record version with its own DOI, of Zenodo resource type <verbatim|publication-preprint> (or the type matching <verbatim|resourceTypeGeneral>). Description-only versions are metadata edits of the existing record version, not new record versions; files they add (such as notices) are not uploaded, since the files of a published record version are fixed.

    <item><strong|Versions out of order.> Zenodo orders the versions of a record by publication, and its concept DOI resolves to the latest. A document version deposited out of order (section 7.3) is therefore not deposited as a new version of the record; it MAY be deposited as a separate record, with <verbatim|IsVersionOf> the concept DOI of the document.

    <item><strong|Files.> The record version holds the content files of the object version as deposited. Zenodo records have no folders: if the sources have sub-folders, or the record would exceed Zenodo's file count, the sources are uploaded as one archive <verbatim|sources.zip>, built reproducibly (entries in byte order of their names, fixed timestamps, no extra attributes), whose digests are recorded in <verbatim|object.json> under <verbatim|external>, in the entry of the deposit (<verbatim|role> <verbatim|deposit>). Inventories MUST record MD5 digests in <verbatim|fixity>, so that the checksums reported by Zenodo can be compared directly.

    <item><strong|Order of operations.> (1) Create a draft, or a new version of the record (a new version inherits the files of the previous one, which are deleted). (2) Reserve its DOI (Zenodo reserves one with each draft; its sandbox reserves DOIs with the prefix <verbatim|10.5281> but publishes them with the test prefix <verbatim|10.5072>). (3) Write <verbatim|datacite.json> with that DOI and build the object version in a staging area. (4) Upload the files and compare the MD5 checksums reported by Zenodo with the fixity block. (5) Publish. (6) Commit the object version and update the discovery document. If a step fails before publication, the draft is discarded. If publication succeeds and the commit fails, the tool MUST complete the object version from the staging area before any other deposit of that document; it SHOULD hold a lock per document during a deposit, since Zenodo allows one unpublished version per record.

    <item><strong|Corrections.> Zenodo allows the files of a published version to be changed within 30 days. Archives following this binding MUST NOT use this: a correction is a new document version.

    <item><strong|Metadata differences.> Zenodo generates its own DataCite record for the DOI: its <verbatim|url> is the Zenodo landing page, its <verbatim|publisher> is Zenodo, and it adds relations of its own (such as <verbatim|IsVersionOf> the concept DOI). <verbatim|datacite.json> remains authoritative; verifiers tolerate exactly these differences.

    <item><strong|Collections.> A collection MAY be deposited when it is explicitly released (not at every change), as a record of type <verbatim|other>, with <verbatim|members.json> among its files. A Zenodo community MAY group an archive's records for browsing; it is not authoritative.
  </itemize>

  <section*|Appendix B. TeXmacs profile (normative for archives declaring the profile <verbatim|texmacs>)>

  <\itemize>
    <item>The main source is a TeXmacs document; <verbatim|sourceFormat> is <verbatim|application/x-texmacs> (not a registered media type; it is the type TeXmacs uses).

    <item><verbatim|toolchain> records the TeXmacs version and the style packages and plugins used that are not part of the TeXmacs distribution; such packages that belong to the document are deposited with the sources.

    <item>Renditions are produced without regenerating bibliographies or tables of contents, so that the deposited sources, with their stored references, reproduce them even if a bibliography database is not deposited; deposits SHOULD nevertheless include the databases used.

    <item>The title and abstract in <verbatim|datacite.json> are converted from the TeXmacs document to plain text, with mathematics in LaTeX as in section 8.

    <item>HTML versions are exported by TeXmacs from a copy of the sources with presentation packages added to its style; the deposited sources are not modified.

    <item>An archive whose files are kept inside a website built with TeXmacs' website converter SHOULD place an empty file <verbatim|.texmacs-noconvert> at its top (honoured by the <verbatim|max-html> plugin), so that the converter never rewrites deposited files.
  </itemize>

  <section*|Appendix C. Website profile (normative for archives declaring the profile <verbatim|website>)>

  <\itemize>
    <item><strong|Index.> The website has an index page generated from the head version of the main collection. It MAY be split into several pages. A flattened, non-authoritative list for programs that do not read OCFL MAY be published as <verbatim|catalog.json>.

    <item><strong|Landing pages.> Each document has one landing page, for its current version (section 7.3), with links to every version in the order of the history, each with its external labels, stage, change note and the notices about it, its renditions and sources, its DOI, and the withdrawal notice if any.

    <item><strong|Search engines.> Landing pages MUST carry the meta tags read by Google Scholar: <verbatim|citation_title>, <verbatim|citation_author> (one per author), <verbatim|citation_publication_date> (the <verbatim|Issued> date, or else the <verbatim|Available> date of the current version), and <verbatim|citation_pdf_url> on the same host as the PDF; and SHOULD carry schema.org <verbatim|ScholarlyArticle> JSON-LD and FAIR Signposting links (<verbatim|cite-as>, <verbatim|describedby>, <verbatim|item>, <verbatim|license>).

    <item><strong|Feeds.> A feed (section 6.1) lists object versions by their <verbatim|created> date in the inventory: what is new in the archive.

    <item><strong|Harvesters.> The website SHOULD publish a <verbatim|sitemap.xml>, and MAY publish an OAI-PMH static repository file or a ResourceSync description.

    <item><strong|Citations.> Landing pages SHOULD offer BibTeX and CSL-JSON entries generated from <verbatim|datacite.json>.

    <item><strong|Separation.> Presentation files are regenerated from the archive and never edited by hand; they do not embed other archives' HTML.
  </itemize>

  <section*|Appendix D. JSON Schemas (normative)>

  The schemas (JSON Schema draft 2020-12) are published with this specification and dedicated to the public domain under CC0 1.0, so that they can be embedded in any software:

  <\itemize>
    <item><hlink|opensheaf-archive-0.1.schema.json|https://opensheaf.org/schemas/opensheaf-archive-0.1.schema.json> for <verbatim|opensheaf.json>;

    <item><hlink|opensheaf-object-0.1.schema.json|https://opensheaf.org/schemas/opensheaf-object-0.1.schema.json> for <verbatim|object.json>;

    <item><hlink|opensheaf-collection-0.1.schema.json|https://opensheaf.org/schemas/opensheaf-collection-0.1.schema.json> for <verbatim|members.json>.
  </itemize>

  DataCite publishes its schema as an XML Schema only. <verbatim|datacite.json> is validated by converting it to DataCite XML (following DataCite's mapping between the REST API's JSON and XML) and validating the result against the DataCite 4.7 XML Schema, together with the requirements of section 8.

  <section*|Appendix E. Examples (non-normative)>

  The values below come from the first archive. Digests are shortened, and the DOIs and ORCID iDs are placeholders.

  A discovery document:

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-archive/0.1",

    \ \ "specification": "0.1",

    \ \ "archiveId": "tag:opensheaf.org,2026:mgubi",

    \ \ "name": "Papers of Massimiliano Gubinelli",

    \ \ "contact": "https://orcid.org/0000-0000-0000-0000",

    \ \ "storageRoot": "ocfl/",

    \ \ "storageLayout": "0002-flat-direct-storage-layout",

    \ \ "mainCollection": "collection-papers",

    \ \ "profiles": ["zenodo", "texmacs", "website"],

    \ \ "objects": [

    \ \ \ \ { "id": "fractional-phi42-mass-gap", "kind": "document", "head": "v1",

    \ \ \ \ \ \ "inventorySha512": "9a0c...", "status": "active" },

    \ \ \ \ { "id": "collection-papers", "kind": "collection", "head": "v1",

    \ \ \ \ \ \ "inventorySha512": "51be...", "status": "active" }

    \ \ ]

    }
  </verbatim-code>

  An <verbatim|object.json> of a document version:

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-object/0.1",

    \ \ "specification": "0.1",

    \ \ "kind": "document",

    \ \ "archiveId": "tag:opensheaf.org,2026:mgubi",

    \ \ "objectId": "fractional-phi42-mass-gap",

    \ \ "documentVersion": 1,

    \ \ "mainSource": "fractional-phi42-mass-gap.tm",

    \ \ "sourceFormat": "application/x-texmacs",

    \ \ "renditions": [ { "path": "paper.pdf", "mediaType": "application/pdf" } ],

    \ \ "toolchain": [ { "name": "TeXmacs", "version": "2.1.5" } ],

    \ \ "stage": { "scheme": "NISO-JAV", "value": "AO" },

    \ \ "agreement": { "by": ["P. Duch", "M. Gubinelli"], "date": "2026-11-12", "method": "by e-mail" },

    \ \ "external": [ { "role": "deposit", "service": "Zenodo", "record": "https://zenodo.org/records/1234567",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "doi": "10.5281/zenodo.1234567" } ],

    \ \ "status": "active"

    }
  </verbatim-code>

  The <verbatim|datacite.json> of the same version:

  <\verbatim-code>
    {

    \ \ "doi": "10.5281/zenodo.1234567",

    \ \ "url": "https://mgubi.org/papers/site/fractional-phi42-mass-gap/fractional-phi42-mass-gap.html",

    \ \ "version": "1",

    \ \ "types": { "resourceTypeGeneral": "Preprint" },

    \ \ "titles": [ { "title": "Mass gap for the fractional Phi^4_2 model" } ],

    \ \ "creators": [

    \ \ \ \ { "name": "Duch, P.", "nameType": "Personal", "givenName": "P.", "familyName": "Duch",

    \ \ \ \ \ \ "affiliation": [ { "name": "Institute of Mathematics, Polish Academy of Sciences" } ] },

    \ \ \ \ { "name": "Gubinelli, M.", "nameType": "Personal", "givenName": "M.", "familyName": "Gubinelli",

    \ \ \ \ \ \ "affiliation": [ { "name": "Mathematical Institute, University of Oxford" } ] } ],

    \ \ "publisher": { "name": "Zenodo" },

    \ \ "publicationYear": 2026,

    \ \ "dates": [ { "date": "2026-11-12", "dateType": "Issued" },

    \ \ \ \ \ \ \ \ \ \ \ \ \ { "date": "2026-11-12", "dateType": "Available" } ],

    \ \ "rightsList": [ { "rights": "Creative Commons Attribution 4.0 International",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "rightsUri": "https://creativecommons.org/licenses/by/4.0/",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "rightsIdentifier": "cc-by-4.0", "rightsIdentifierScheme": "SPDX" } ],

    \ \ "descriptions": [ { "description": "We present a new, simple ...", "descriptionType": "Abstract" } ],

    \ \ "formats": [ "application/x-texmacs", "application/pdf" ],

    \ \ "relatedIdentifiers": [

    \ \ \ \ { "relatedIdentifier": "10.5281/zenodo.1234566", "relatedIdentifierType": "DOI", "relationType": "IsVersionOf" } ]

    }
  </verbatim-code>

  The <verbatim|object.json> of a later version of a document whose arXiv version 2 was found and deposited after version 4 (document versions 1, 2, 3 for arXiv's v1, v3, v4, then 4 for arXiv's v2, placed between 1 and 2 in the history), with a notice about version 2 (arXiv's v3):

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-object/0.1",

    \ \ ...

    \ \ "documentVersion": 3,

    \ \ "changes": { "text": "Corrected the proof of Lemma 2; 32 pages." },

    \ \ "stage": { "scheme": "NISO-JAV", "value": "AM" },

    \ \ "history": [ "v1", "v4", "v2", "v5" ],

    \ \ "notices": [ { "documentVersion": 2, "date": "2026-12-01",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "text": "Theorem 3 is wrong as stated; corrected in version 3.",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "path": "notices/erratum-v2.pdf", "mediaType": "application/pdf" } ],

    \ \ "external": [ { "role": "source", "service": "arXiv", "record": "https://arxiv.org/abs/2303.18112v4",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "doi": "10.48550/arXiv.2303.18112", "label": "v4" } ],

    \ \ "status": "active"

    }
  </verbatim-code>

  Object versions <verbatim|v1> to <verbatim|v3> deposited document versions 1 to 3; <verbatim|v4> deposited document version 4 (arXiv's v2) and wrote the history <verbatim|["v1", "v4", "v2", "v3"]>, so that the current version stayed document version 3 although the head held version 4; <verbatim|v5>, shown here, is a description-only version adding the notice, which holds the current version again. The current version is document version 3, the last in the history.

  A <verbatim|members.json> of an archive collection: the main collection of an archive, following its documents whole:

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-collection/0.1",

    \ \ "type": "archive",

    \ \ "order": "issued-desc",

    \ \ "members": [

    \ \ \ \ { "kind": "document",

    \ \ \ \ \ \ "archive": "tag:opensheaf.org,2026:mgubi",

    \ \ \ \ \ \ "archiveUrl": "https://mgubi.org/papers/",

    \ \ \ \ \ \ "id": "fractional-phi42-mass-gap",

    \ \ \ \ \ \ "version": "v3",

    \ \ \ \ \ \ "inventorySha512": "9a0c...",

    \ \ \ \ \ \ "follow": "latest",

    \ \ \ \ \ \ "cite": { "title": "Mass gap for the fractional $\\\\Phi^4_2$ model",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "creators": ["P. Duch", "M. Gubinelli"], "year": 2026, "issued": "2026-11-12" } }

    \ \ ]

    }
  </verbatim-code>

  A <verbatim|members.json> of a selection: an issue of a journal, with a paper vetted in its version 2 and, after a correction accepted by the editors, its version 3; an accepted copy kept by the journal; and a member that is itself a collection, vetted in one version:

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-collection/0.1",

    \ \ "type": "selection",

    \ \ "members": [

    \ \ \ \ { "kind": "document",

    \ \ \ \ \ \ "archive": "tag:example.org,2026:authors",

    \ \ \ \ \ \ "archiveUrl": "https://authors.example.org/",

    \ \ \ \ \ \ "id": "network-discrimination",

    \ \ \ \ \ \ "revisions": [

    \ \ \ \ \ \ \ \ { "documentVersion": 2, "version": "v2", "inventorySha512": "4f1e..." },

    \ \ \ \ \ \ \ \ { "documentVersion": 3, "version": "v4", "inventorySha512": "c07a..." } ],

    \ \ \ \ \ \ "mirrors": ["https://journal.example.org/"],

    \ \ \ \ \ \ "cite": { "title": "Quantum network discrimination", "creators": ["C. Hirche"], "year": 2021 } },

    \ \ \ \ { "kind": "collection",

    \ \ \ \ \ \ "archive": "tag:example.org,2026:seminar",

    \ \ \ \ \ \ "archiveUrl": "https://seminar.example.org/",

    \ \ \ \ \ \ "id": "collection-seminar-2026",

    \ \ \ \ \ \ "revisions": [ { "documentVersion": 3, "version": "v3", "inventorySha512": "7d21..." } ] }

    \ \ ]

    }
  </verbatim-code>

  The <verbatim|object.json> of the journal's accepted copy of the first member's version 2:

  <\verbatim-code>
    {

    \ \ "format": "opensheaf-object/0.1",

    \ \ "specification": "0.1",

    \ \ "kind": "document",

    \ \ "archiveId": "tag:example.org,2026:journal",

    \ \ "objectId": "network-discrimination",

    \ \ "documentVersion": 1,

    \ \ "mainSource": "paper.tex",

    \ \ "sourceFormat": "application/x-tex",

    \ \ "renditions": [ { "path": "paper.pdf", "mediaType": "application/pdf" } ],

    \ \ "stage": { "scheme": "NISO-JAV", "value": "VoR" },

    \ \ "external": [ { "role": "source", "service": "OpenSheaf",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "record": "https://authors.example.org/ocfl/network-discrimination/v2/",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "label": "network-discrimination v2",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "files": [ { "name": "inventory.json", "sha512": "4f1e..." } ] } ],

    \ \ "status": "active"

    }
  </verbatim-code>

  <section*|Appendix F. Rationale (non-normative)>

  <\itemize>
    <item><strong|Why OCFL.> It is a published, versioned specification for exactly this problem (versioned objects as plain files with digests), with independent validators, used by research libraries. OpenSheaf adds only discovery and collections.

    <item><strong|Why the flat-direct layout.> Paths stay readable and resolvable by rule over plain HTTP; the cost is short identifiers without <verbatim|/>.

    <item><strong|Why a discovery document.> Static web servers cannot list folders; one small file makes an archive discoverable, and its statements are checked against the storage root.

    <item><strong|Why pins by inventory digest.> One digest fixes a whole object version, so collections become hash trees across archives, and any matching copy will do.

    <item><strong|Why archive collections and selections.> Keeping and vetting are different acts. An archive (an author's, an institution's, a storage site) keeps what its members deposit, every version, without judging them: following an object as it grows is its job. A selection (a journal, a digest, a review journal) vouches for particular revisions: a later version by the authors has not been vetted, so it cannot enter the selection by itself, and a change of what is vetted is an editorial act that the selection's own history records. Pinning whole objects in one case and revision sets in the other makes the difference explicit and checkable.

    <item><strong|Why mirrors and accepted copies differ.> A mirror copies a whole object and stays the same object, owned by its original archive, so it can only grow by the original's versions. An accepted copy takes one vetted revision into the selection's own archive, where it continues under the selection's responsibility (corrections, notices, withdrawal); OCFL cannot hold part of an object, so a copy of one revision is necessarily a new object.

    <item><strong|Why separate document and object versions.> Readers and DOI services see versions of the work; the storage keeps every change, including corrections of the description.

    <item><strong|Why the archive numbers document versions itself.> External numberings have gaps (versions an external service no longer serves) and do not cover versions that were never public there. The archive's own numbers have no gaps; external labels are recorded beside them.

    <item><strong|Why an explicit history, and why it lists object versions.> Dates may be approximate or unknown, so they cannot order versions, and pointers from each version to the previous one cannot be corrected when a version is inserted later, since earlier versions are fixed. A list kept in each object version, with the head's list authoritative, can be corrected by a new version and keeps a record of what was known before. Its entries name object versions, which are exact and resolved directly through the inventory, and name the last object version of each document version, which carries its most complete description. Digests could not be used: an object version cannot contain the digest of its own inventory.

    <item><strong|Why the deposit is read from the inventory.> OCFL already records when and by whom each object version was made; repeating it in <verbatim|object.json> would allow the two to disagree.

    <item><strong|Why notices are not new document versions.> A notice about a version is a later statement about it, not a change of the work. The exact state a reader saw, with or without a notice, is identified by the object version and its pin.

    <item><strong|Where witnesses live.> A witness of an object version can only be made after the version is committed, so it cannot be part of it (a signature of an inventory cannot be listed in that inventory). Putting each signature or timestamp in a new version would mix evidence with changes of the work, and every upgrade of a timestamp proof would be a version. OCFL closes the object folder to anything it does not define, and its <verbatim|logs/> folder is meant for unstructured records of actions and is not covered by digests. Object extension folders are the place OCFL provides for data that is not part of any version (the registered mutable-head extension keeps its data there), so witnesses go in <verbatim|extensions/opensheaf-witnesses/> and travel with the object; <verbatim|witnesses/> outside the storage root remains for archives that never touch object folders after commit.

    <item><strong|Why no HTML in deposits.> Presentations improve; deposits must not change.

    <item><strong|Why DataCite.> It is the metadata of DOIs for repositories, with relations for versions, preprints and collections, and it maps directly to Zenodo.
  </itemize>

  <section*|Appendix G. References>

  <\itemize>
    <item><hlink|OCFL 1.1 specification|https://ocfl.io/1.1/spec/> and <hlink|OCFL extensions|https://ocfl.github.io/extensions/>

    <item><hlink|DataCite Metadata Schema 4.7|https://schema.datacite.org/>, <hlink|DataCite guidance on preprints|https://support.datacite.org/docs/preprints-post-prints-and-author-manuscripts> and <hlink|the REST API change for publisher and affiliation|https://support.datacite.org/docs/datacite-rest-api-affiliation-and-publisher-default-change>

    <item><hlink|RFC 2119|https://www.rfc-editor.org/rfc/rfc2119>, <hlink|RFC 8174|https://www.rfc-editor.org/rfc/rfc8174>, <hlink|RFC 8259|https://www.rfc-editor.org/rfc/rfc8259>, <hlink|RFC 4151|https://www.rfc-editor.org/rfc/rfc4151> and <hlink|RFC 3339|https://www.rfc-editor.org/rfc/rfc3339>

    <item><hlink|JSON Schema 2020-12|https://json-schema.org/draft/2020-12>

    <item><hlink|Zenodo developer documentation|https://developers.zenodo.org/>, <hlink|InvenioRDM records API|https://inveniordm.docs.cern.ch/reference/rest_api_drafts_records/>, <hlink|Zenodo on folders|https://support.zenodo.org/help/en-gb/1-upload-deposit/74-can-i-upload-folders-directories>, <hlink|managing files|https://help.zenodo.org/docs/deposit/manage-files/>, <hlink|resource types|https://zenodo.org/api/vocabularies/resourcetypes> and <hlink|versioning|https://zenodo.org/help/versioning>

    <item><hlink|Google Scholar inclusion guidelines|https://scholar.google.com/intl/en/scholar/inclusion.html>, <hlink|FAIR Signposting|https://signposting.org/>, <hlink|OAI-PMH static repositories|https://www.openarchives.org/OAI/2.0/guidelines-static-repository.htm> and <hlink|ResourceSync|https://www.openarchives.org/rs/toc>

    <item><hlink|OpenTimestamps|https://opentimestamps.org/> and <hlink|Software Heritage identifiers|https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html>
  </itemize>

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
