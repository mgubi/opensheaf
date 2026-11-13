<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|OpenSheaf: use cases>

  How the <hlink|specification|opensheaf-specification-0.1.tm> adapts to the people and institutions that keep and select scholarly documents. It is non-normative: where it and the specification differ, the specification holds. Commands of the reference tools, <hlink|opensheaf-py|https://github.com/opensheaf/opensheaf-py> (<verbatim|osheaf>), are given as illustrations; any tool following the specification will do.

  Three roles recur:

  <\itemize>
    <item><strong|authors> make documents and their versions;

    <item><strong|archives> keep documents, every version, impartially: an author's own archive, an institution's repository, an independent storage site;

    <item><strong|selections> vet particular versions (revisions) of documents: a journal, a digest, a review journal, a reading list, proceedings.
  </itemize>

  Archives list what they keep in <strong|archive collections>, which pin objects whole and may follow them as they grow; selections are the other kind of collection of section 10, which pins revision sets and changes only by an act of its curator. Copies are of two kinds too: a <strong|mirror> copies a whole object (an archive keeping another archive's objects), an <strong|accepted copy> takes one vetted revision into the selection's own archive. Collections and copies only concern documents kept in OpenSheaf archives: a paper that exists only on arXiv or on a publisher's site is first deposited in an archive (for instance imported from arXiv into its author's archive) before it can be pinned.

  <section*|Authors>

  <subsection*|A researcher's own archive>

  A mathematician keeps an archive of her papers on her website (the first archive, <hlink|mgubi.org/papers|https://mgubi.org/papers/>, is one).

  <\itemize>
    <item>Each paper is a document object; each version of the paper, a document version, numbered by the archive from 1 without gaps. Versions imported from arXiv keep arXiv's label (<verbatim|v3>) in <verbatim|external>.

    <item>A version that arXiv keeps only as a PDF is deposited without sources (<verbatim|sourcesMissing>); when she finds the sources, they complete that same version (section 7.3).

    <item>A draft or a submitted manuscript found later is deposited in its place in the history (<verbatim|history>), without renumbering what exists; versions never public at the time carry a <verbatim|Created> date, and their <verbatim|Available> date is the date of their deposit.

    <item>An erratum is a notice about a version; a retraction is a withdrawal. Both are description-only versions: nothing deposited changes.

    <item>The archive's main collection is an <strong|archive collection> of her own documents, following them: the index shows the current version of each.

    <item>DOIs come from the Zenodo binding (appendix A): a concept DOI for each document and a DOI for each document version. A version deposited out of order becomes a separate Zenodo record, and notices are not uploaded, since the files of a published Zenodo record are fixed.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # deposit a new paper: its LaTeX source, the files it includes, and the PDF

    osheaf deposit kpz-uniqueness paper.tex \\

    \ \ --pdf paper.pdf \\

    \ \ --extra-source refs.bib \\

    \ \ --extra-source figures/fixed-point.pdf=figures/fixed-point.pdf \\

    \ \ --title "Uniqueness of the KPZ fixed point" \\

    \ \ --author "Doe, Jane\|University of Example" \\

    \ \ --rights cc-by-4.0 \\

    \ \ --stage AO



    # a second version, revised after the referees' comments (the title and

    # the authors are given again for each version)

    osheaf deposit kpz-uniqueness paper.tex \\

    \ \ --pdf paper.pdf \\

    \ \ --extra-source refs.bib \\

    \ \ --extra-source figures/fixed-point.pdf=figures/fixed-point.pdf \\

    \ \ --title "Uniqueness of the KPZ fixed point" \\

    \ \ --author "Doe, Jane\|University of Example" \\

    \ \ --changes "Corrected the proof of Lemma 3; new appendix." \\

    \ \ --stage AM



    # an erratum about version 1, which stays as it was deposited

    osheaf notice kpz-uniqueness \\

    \ \ --about 1 \\

    \ \ --text "Lemma 3 is wrong as stated; corrected in version 2."



    # papers on arXiv: download them (downloads/ is created; identifiers.json

    # in it maps arXiv identifiers to object identifiers), then import the new

    # versions of papers already in the archive

    osheaf arxiv fetch downloads --refresh

    osheaf arxiv import downloads --update



    # update the main collection and the website, then check everything

    osheaf collect

    osheaf index

    osheaf verify
  </verbatim-code>
  </html-div-class>

  <subsection*|Co-authors in different archives>

  Two co-authors each keep an archive; their joint paper is deposited once, in one of them. The other lists it in a collection of her own archive (for instance "papers with my students") as a member of another archive. In an <strong|archive collection> with <verbatim|follow>, each time she updates the collection (<verbatim|osheaf collect>) it pins her co-author's newest version; nothing is copied, and no permission is needed. Her member entry can list <verbatim|mirrors> of the co-author's archive (section 10.2), so that readers still reach the paper when that archive is down. If she wants the paper in her archive too, and the licences of all its versions allow redistribution, she can <strong|mirror> it: a byte-for-byte copy of the whole object, which stays the co-author's object (<verbatim|mirrorOf>).

  <subsection*|A research group, a seminar, lecture notes>

  A group keeps one archive for its members' papers, theses and slides, or each researcher keeps her own and the group keeps an archive collection whose members are documents of those archives. Lecture notes and slides are documents like papers (<verbatim|resourceTypeGeneral> <verbatim|Text>, with <verbatim|resourceType> "Lecture notes" or "Slides"); notes revised every year are versions of one document, or separate documents when an edition is a different work (a new title, a different course).

  <section*|Archives>

  <subsection*|An institutional repository>

  A university keeps an archive of its members' work.

  <\itemize>
    <item>Members may deposit directly in the institution's archive, whose main collection is an archive collection of its documents, perhaps with one archive collection per department.

    <item>Or members keep their own archives, and the institution <strong|mirrors> their documents: each mirror is a whole copy, every version, kept up to date by copying new versions, and listed with <verbatim|mirrorOf> in the institution's discovery document. Mirroring is allowed only when the licences of all the versions copied allow redistribution (section 10.4). Many papers imported from arXiv carry arXiv's default licence, which does not; the institution then only references them, or asks the authors to deposit openly licensed versions.

    <item>The institution is impartial: it keeps what its members deposit. It does not vet versions; that is what selections do.
  </itemize>

  <subsection*|An independent storage site>

  A preservation service (a library, a consortium) keeps copies of archives so that they survive their owners' servers.

  <\itemize>
    <item>It mirrors whole archives, or chosen objects of them, byte for byte. An archive mirrored entirely can list the copy in the <verbatim|mirrors> of its discovery document, which helps as long as that document can be reached; collections that should survive an archive's disappearance list mirrors in their members' entries (section 10.2), which clients try when the archive fails (section 6.4).

    <item>Since every collection pins its members by digest, any copy whose bytes match is as good as the original: integrity comes from the pin, not from the place. Verifiers check mirrors exactly as originals.

    <item>Further witnesses that a version existed, with these bytes, at a date: signatures and timestamps (section 13.2), made by the authors or by others; a snapshot of the archive's git repository by Software Heritage, cited by its SWHID (section 8.1); and Zenodo deposits (appendix A), which keep the content files, though without the inventory a Zenodo record cannot be checked against a pin.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # copy an object of another archive, byte for byte, with all its versions

    osheaf mirror https://example.org/papers/ kpz-uniqueness



    # list it in a collection of the archive, so that the website shows it and

    # verify checks it (preserved.yaml below; "mirror: yes" copies and lists

    # in one step)

    osheaf collection sync preserved --from preserved.yaml



    # write the discovery document and the website, then check the archive;

    # members of other archives are checked too, on their mirrors when their

    # own archive does not answer

    osheaf index

    osheaf verify --remote
  </verbatim-code>
  </html-div-class>

  <\html-div-class|language-yaml>
  <\verbatim-code>
    id: preserved

    title: Papers preserved by the library

    members:

    \ \ - archive: https://example.org/papers/

    \ \ \ \ id: kpz-uniqueness

    \ \ \ \ mirror: yes
  </verbatim-code>
  </html-div-class>

  <subsection*|An archive that moves>

  An author moves her archive to a new domain. Its archive identifier (a <verbatim|tag:> URI) does not change. Collections recorded the base URL of the time (<verbatim|archiveUrl>): readers still reach the archive through HTTP redirects from the old address, which she should keep as long as she can, or through the mirrors listed in member entries; curators update <verbatim|archiveUrl> in a new version of their collections. Pins stay valid, because they fix bytes, not addresses.

  <section*|Selections>

  <subsection*|An overlay journal>

  A journal whose papers are kept by their authors in OpenSheaf archives (a paper only on arXiv is first imported into an archive, its author's or the journal's, with arXiv recorded as its source) accepts, after review, a particular version of each paper.

  <\itemize>
    <item>An issue is a <strong|selection>: each member pins the revision set the editors vetted, usually the accepted version.

    <item>The authors' later versions are not in the issue: they have not been reviewed. A correction accepted by the editors adds a revision to the set, as a new version of the issue, recorded in its inventory as the editors' act.

    <item>To make sure what it vetted stays available, the journal keeps an <strong|accepted copy> of each vetted revision, as a document of its own archive: exactly the files of that version, byte for byte, with the source and its pin recorded. Only the copied revision needs a licence allowing redistribution; a paper whose first preprint was under a restrictive licence can be accepted in a later, openly licensed version. Later versions of the accepted copy (corrections, notices, a withdrawal) are the editors' acts; the authors' archive cannot change them.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # keep an accepted copy of the version the editors vetted; --version names

    # the object version vetted (vN in the authors' storage), not the document

    # version

    osheaf accept https://authors.example.org/ network-discrimination \\

    \ \ --version v2 \\

    \ \ --stage VoR \\

    \ \ --agreement "the journal's publication terms"



    # list the issue (issue-7.yaml below). The reference tools do not yet write

    # selections (type and revisions, section 10.2): until they do, a

    # collection whose members each pin one object version is the nearest form.

    # Name the collection: without a name, sync replaces the main collection.

    osheaf collection sync issue-7 --from issue-7.yaml
  </verbatim-code>
  </html-div-class>

  <\html-div-class|language-yaml>
  <\verbatim-code>
    id: issue-7

    title: Issue 7

    members:

    \ \ - archive: "." \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ # the accepted copy, in the journal's archive

    \ \ \ \ id: network-discrimination

    \ \ \ \ version: v1
  </verbatim-code>
  </html-div-class>

  <subsection*|A journal that publishes its own version>

  A journal typesets the accepted paper in its own layout, gives it a DOI, and publishes it under its licence, with the authors' agreement.

  <\itemize>
    <item>The journal's version of record is a document of the journal's archive, not a version of the authors' document (section 7.3): it has the journal as <verbatim|publisher>, its DOI in <verbatim|doi>, <verbatim|stage> <verbatim|VoR>, the journal's <verbatim|rightsList>, the authors' agreement in <verbatim|object.json>, and a relation to the authors' version it was made from (<verbatim|IsVariantFormOf>: the same work in another form, section 8.1).

    <item>The authors' preprint is linked to it by a description-only version of their own document (<verbatim|IsVersionOf> the article's DOI, section 8.1), if they want.

    <item>The journal's issues are selections of its own documents, or archive collections of them: the journal's own documents change only by its own acts in either case.
  </itemize>

  <subsection*|A digest, a reading list, a curated bibliography>

  A researcher publishes a list of recommended papers on a topic, from any OpenSheaf archives.

  <\itemize>
    <item>The list is a <strong|selection>: each member pins the revision she read and recommends. A later version of a paper enters the list only if she adds it, after reading it.

    <item>Nothing is copied, so no permission is needed; the members' cached citations keep the list readable if an archive disappears.

    <item>A selection may contain collections: a digest of digests, or of journal issues, each pinned in the version vetted.
  </itemize>

  <subsection*|A review journal (like Mathematical Reviews or zbMATH Open)>

  A review journal publishes short reviews of papers published elsewhere.

  <\itemize>
    <item>Each review is a document of the review journal's archive (<verbatim|resourceTypeGeneral> <verbatim|PeerReview>), written by a reviewer, with <verbatim|relatedIdentifiers> <verbatim|Reviews> pointing to the reviewed paper (its DOI, or the URL of the object version reviewed).

    <item>Reviewed papers kept in OpenSheaf archives form a <strong|selection>: each member pins exactly the revision that was reviewed. When a paper gets a new version, the review stays attached to the reviewed revision, and the selection does not move; a new review of the new version adds a revision to the set, by the editors' act. Papers published only elsewhere (a publisher's site) are linked by the review's <verbatim|Reviews> relation alone.

    <item>Reviews and the selection are kept by the review journal, so the record of what was reviewed, and in which version, is fixed and checkable even if the papers' archives change.
  </itemize>

  <subsection*|Proceedings, special issues, volumes>

  Proceedings of a conference are a selection of the talks' papers, each vetted in the version presented; a volume is a selection whose members are its issues (collections), each pinned in the version published. A special issue of a journal is a selection of the journal's own documents, or of accepted copies.

  <section*|What happens when ...>

  <block|<tformat|<cwith|1|1|1|-1|font-series|bold>|<cwith|1|-1|1|-1|cell-valign|top>|<cwith|1|-1|1|-1|cell-hyphen|t>|<table|<row|<cell|Event>|<cell|Archive collection (an archive, a mirror)>|<cell|Selection (a journal, a digest)>>|<row|<cell|the authors deposit a new version>|<cell|it is followed (with <verbatim|follow>): the next collection version pins the new head>|<cell|nothing changes; the curator may vet it and add it to the revision set>>|<row|<cell|the authors add a notice or a description>|<cell|it is followed, like any new version>|<cell|not vetted; presentations may show it, saying where it comes from>>|<row|<cell|the authors withdraw the document>|<cell|it is followed: the withdrawn document stays, with its notice>|<cell|the vetted revisions stay, and presentations show the authors' withdrawal notice with the document (section 11.1); the curator decides what else (a notice of its own, a withdrawal of its accepted copy)>>|<row|<cell|the editors correct a vetted version>|<cell|not applicable>|<cell|a new revision in the set, or a new version of the accepted copy: the editors' act, in the selection's history>>|<row|<cell|a document is taken down (by law, or to erase personal data, section 16)>|<cell|the object is deleted and a tombstone stays; verifiers report the member as removed>|<cell|the same for the pinned revisions; an accepted copy is a document of the selection's archive, to which the takedown is applied separately>>|<row|<cell|the member's archive moves>|<cell|the pin stays valid; readers follow redirects or the mirrors listed in member entries>|<cell|the same>>|<row|<cell|the member's archive disappears>|<cell|members are fetched from mirrors, or any copy matching the pin; Zenodo deposits keep the files but cannot be checked against the pin>|<cell|the accepted copy keeps the vetted revision; references keep their cached citations>>|<row|<cell|a version's licence forbids redistribution>|<cell|the object cannot be mirrored, only referenced>|<cell|the revision cannot be copied, only referenced (unless the authors grant the right)>>>>>

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
