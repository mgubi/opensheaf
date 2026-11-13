# OpenSheaf: use cases

How the [specification](opensheaf-specification-0.1.md) adapts to the people
and institutions that keep and select scholarly documents. It is
non-normative: where it and the specification differ, the specification
holds. Commands of the reference tools,
[opensheaf-py](https://github.com/opensheaf/opensheaf-py) (`osheaf`), are
given as illustrations; any tool following the specification will do.

Three roles recur:

- **authors** make documents and their versions;
- **archives** keep documents, every version, impartially: an author's own
  archive, an institution's repository, an independent storage site;
- **selections** vet particular versions (revisions) of documents: a journal,
  a digest, a review journal, a reading list, proceedings.

They map to the two kinds of collections of section 10: an **archive
collection** pins objects whole and may follow them as they grow; a
**selection** pins revision sets and changes only by an act of its curator.
Copies are of two kinds too: a **mirror** copies a whole object (an archive
keeping another archive's objects), an **accepted copy** takes one vetted
revision into the selection's own archive.

## Authors

### A researcher's own archive

A mathematician keeps an archive of her papers on her website (the first
archive, [mgubi.org/papers](https://mgubi.org/papers/), is one).

- Each paper is a document object; each version of the paper, a document
  version, numbered by the archive from 1 without gaps. Versions imported
  from arXiv keep arXiv's label (`v3`) in `external`.
- A draft or a submitted manuscript found later is deposited in its place in
  the history (`history`), without renumbering what exists; versions never
  public at the time carry a `Created` date instead of `Available`.
- An erratum is a notice about a version; a retraction is a withdrawal. Both
  are description-only versions: nothing deposited changes.
- The archive's main collection is an **archive collection** of her own
  documents, following them: the index shows the current version of each.
- DOIs come from the Zenodo binding (appendix A), one per document version.

```
osheaf deposit kpz-uniqueness paper.tex --pdf paper.pdf --title ... --author ... --rights cc-by-4.0
osheaf arxiv import downloads --update      # the new arXiv versions
osheaf notice kpz-uniqueness --about 2 --text "Lemma 3 is wrong as stated; corrected in version 3."
osheaf collect && osheaf index && osheaf verify
```

### Co-authors in different archives

Two co-authors each keep an archive; their joint paper is deposited once, in
one of them. The other lists it in a collection of her own archive (for
instance "papers with my students") as a member of another archive. In an
**archive collection** with `follow`, her list keeps pointing to the current
version as her co-author adds versions; nothing is copied, and no permission
is needed. If she wants the paper in her archive too, and every version is
openly licensed, she can **mirror** it: a byte-for-byte copy of the whole
object, which stays the co-author's object (`mirrorOf`).

### A research group, a seminar, lecture notes

A group keeps one archive for its members' papers, theses and slides, or each
member keeps her own and the group keeps an archive collection of members of
those archives. Lecture notes and slides are documents like papers (with
`types` such as `Text` or `Audiovisual`); notes revised every year are
versions of one document, or one document per edition when each edition
should stay citable on its own.

## Archives

### An institutional repository

A university keeps an archive of its members' work.

- Members may deposit directly in the institution's archive, whose main
  collection is an archive collection of its documents, perhaps with one
  archive collection per department.
- Or members keep their own archives, and the institution **mirrors** their
  documents: each mirror is a whole copy, every version, kept up to date by
  copying new versions, and listed with `mirrorOf` in the institution's
  discovery document. Mirroring needs the right to redistribute every
  version (an open licence, or the authors' agreement); otherwise the
  institution only references the documents.
- The institution is impartial: it keeps what its members deposit. It does
  not vet versions; that is what selections do.

### An independent storage site

A preservation service (a library, a consortium, a site like Software
Heritage) keeps copies of archives so that they survive their owners' servers.

- It mirrors whole archives, or chosen objects of them, byte for byte; an
  archive mirrored entirely lists the copy in the `mirrors` of its discovery
  document, so that clients find it when the original fails (section 6.4).
- Since every collection pins its members by digest, any copy whose bytes
  match is as good as the original: integrity comes from the pin, not from
  the place. Verifiers check mirrors exactly as originals.
- Zenodo deposits (appendix A) and timestamps (section 13.2) are further
  witnesses that a version existed, with these bytes, at a date.

```
osheaf mirror https://example.org/papers/ kpz-uniqueness
osheaf verify --remote      # checks members on their mirrors when an archive fails
```

### An archive that moves

An author moves her archive to a new domain. Its archive identifier (a `tag:`
URI) does not change; collections pinned it with the base URL of the time,
and clients that cannot reach it there try the mirrors. Pins stay valid,
because they fix bytes, not addresses.

## Selections

### An overlay journal

A journal whose papers are kept by their authors (on arXiv, or in their own
archives) accepts, after review, a particular version of each paper.

- An issue is a **selection**: each member pins the revision set the editors
  vetted, usually the accepted version.
- The authors' later versions are not in the issue: they have not been
  reviewed. A correction accepted by the editors adds a revision to the set,
  as a new version of the issue, recorded in its inventory as the editors'
  act.
- To make sure what it vetted stays available, the journal keeps an
  **accepted copy** of each vetted revision, as a document of its own archive:
  exactly the files of that version, byte for byte, with the source and its
  pin recorded. Only the copied revision needs a licence allowing
  redistribution; a paper whose first preprint was under a restrictive
  licence can be accepted in a later, openly licensed version. Later versions
  of the accepted copy (corrections, notices, a withdrawal) are the editors'
  acts; the authors' archive cannot change them.

```
osheaf accept https://authors.example.org/ network-discrimination --version v2 --stage VoR \
  --agreement "the journal's publication terms"
osheaf collection sync --from issue-7.yaml        # type: selection, the vetted revisions
```

### A journal that publishes its own version

A journal typesets the accepted paper in its own layout, gives it a DOI, and
publishes it under its licence, with the authors' agreement.

- The journal's version of record is a document of the journal's archive,
  not a version of the authors' document (section 7.3): it has the journal as
  `publisher`, `stage` `VoR`, the journal's `rightsList`, the authors'
  agreement in `object.json`, and relations to the authors' versions
  (`IsVersionOf`, `IsIdenticalTo` the DOI it registered).
- The authors' preprint is linked to it by a description-only version of their
  own document (`IsVersionOf` the article's DOI, section 8.1), if they want.
- The journal's issues are selections of its own documents, or archive
  collections of them: the journal's own documents change only by its own
  acts in either case.

### A digest, a reading list, a curated bibliography

A researcher publishes a list of recommended papers on a topic, from any
archives.

- The list is a **selection**: each member pins the revision she read and
  recommends. A later version of a paper enters the list only if she adds it,
  after reading it.
- Nothing is copied, so no permission is needed; the members' cached
  citations keep the list readable if an archive disappears.
- A selection may contain collections: a digest of digests, or of journal
  issues, each pinned in the version vetted.

### A review journal (like Mathematical Reviews or zbMATH Open)

A review journal publishes short reviews of papers published elsewhere.

- Each review is a document of the review journal's archive, written by a
  reviewer, with `relatedIdentifiers` `Reviews` pointing to the reviewed
  paper (its DOI, or the URL of the object version reviewed).
- The reviewed papers form a **selection**: each member pins exactly the
  revision that was reviewed. When a paper gets a new version, the review stays
  attached to the reviewed revision, and the selection does not move; a new
  review of the new version adds a revision to the set, by the editors' act.
- Reviews and the selection are kept by the review journal, so the record of
  what was reviewed, and in which version, is fixed and checkable even if the
  papers' archives change.

### Proceedings, special issues, volumes

Proceedings of a conference are a selection of the talks' papers, each vetted
in the version presented; a volume is a selection whose members are its
issues (collections), each pinned in the version published. A special issue
of a journal is a selection of the journal's own documents, or of accepted
copies.

## What happens when ...

| Event | Archive collection (an archive, a mirror) | Selection (a journal, a digest) |
|---|---|---|
| the authors deposit a new version | it is followed (with `follow`): a new collection version pins the new head | nothing changes; the curator may vet it and add it to the revision set |
| the authors add a notice or a description | it is followed, like any new version | not vetted; presentations may show it, saying where it comes from |
| the authors withdraw the document | it is followed: the withdrawn document stays, with its notice | the vetted revisions stay; the curator decides (a notice of its own, a withdrawal of its accepted copy) |
| the editors correct a vetted version | not applicable | a new revision in the set, or a new version of the accepted copy: the editors' act, in the selection's history |
| the member's archive moves | the pin stays valid; clients try the mirrors | the same |
| the member's archive disappears | members are fetched from mirrors, Zenodo or snapshots; the pin decides | the accepted copy keeps the vetted revision; references keep their cached citations |
| a version's licence forbids redistribution | the object cannot be mirrored, only referenced | the revision cannot be copied, only referenced (unless the authors agree) |
