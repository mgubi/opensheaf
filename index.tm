<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|<image|resources/brand/opensheaf-logo.svg|0.5par|||>>

  OpenSheaf is an open format for archives of scholarly documents and for collections of them. Read the <hlink|specification|opensheaf-specification-0.1.tm> (version 0.1) and the <hlink|FAQ|faq.tm>, which explains its main choices. The site is <hlink|opensheaf.org|https://opensheaf.org> (also <verbatim|sheaf.pub>).

  <strong|Status:> version 0.1, a draft. It is experimental and may change in incompatible ways before version 1.0.

  <strong|Author:> <hlink|Massimiliano Gubinelli|https://mgubi.org/docs/main.html> (Mathematical Institute, University of Oxford).

  <strong|Source:> the specification and this site are kept in the GitHub repository <hlink|opensheaf/opensheaf|https://github.com/opensheaf/opensheaf>, which is also the place to discuss them (see below).

  <section*|Why>

  Scholarly documents now live in a few central places: preprint servers such as arXiv, publishers' platforms, institutional repositories. They work, but authors depend on them for something that could be much simpler, and what they keep is often only a PDF.

  OpenSheaf proposes a lean common format instead:

  <\itemize>
    <item><strong|Archives kept by their authors.> Anyone (a person, a group, an institution) can keep an archive of their documents as plain files on a static website. No server software, no central service, no permission needed.

    <item><strong|Sources, not only PDFs.> Each deposit keeps the sources of a document together with its PDF, so that the work can be read, checked and reused in the form in which it was written.

    <item><strong|Fixed, verifiable versions.> Every version of every document is fixed by content hashes and never changes once deposited. Corrections are new versions, and anyone can check the whole history from the files alone.

    <item><strong|Standards, not inventions.> Storage follows the Oxford Common File Layout (OCFL), used by research libraries for long-term preservation; description follows the DataCite metadata of DOIs. OpenSheaf only adds what these leave open.

    <item><strong|Collections that compose.> A collection, such as the papers of a seminar, an editorial selection or a reading list, is itself a versioned object pinning its members by digest, also across archives. Selections of collections compose without copying, as local pieces glue into a sheaf.

    <item><strong|Compatible with existing infrastructure.> Documents can also be on arXiv, get DOIs and be archived on Zenodo, and be found by Google Scholar; none of these is required.
  </itemize>

  <section*|The name>

  A <em|sheaf> is a bundle of papers, or of stalks of wheat tied together. In mathematics, a sheaf is the structure that attaches data to each part of a space so that local pieces, which agree where they overlap, glue into a whole. OpenSheaf works the same way: archives are kept and verified separately, each by its owner, and collections glue them together without copying, while every piece stays checkable on its own.

  <section*|Taking part>

  This repository is the place to discuss OpenSheaf and to propose changes:

  <\itemize>
    <item><strong|Questions and problems:> open an <hlink|issue|https://github.com/opensheaf/opensheaf/issues>, for instance when something in the specification is unclear, contradictory or hard to implement.

    <item><strong|Ideas and open-ended discussion:> use the <hlink|Discussions|https://github.com/opensheaf/opensheaf/discussions>.

    <item><strong|Amendments:> propose changes to the text as pull requests on <hlink|opensheaf-specification-0.1.md|opensheaf-specification-0.1.tm>, with an explanation of the motivation; larger changes are best discussed in an issue first.

    <item><strong|Implementations:> if you build an archive, a tool or a verifier for OpenSheaf, open an issue so that it can be added to the list below.
  </itemize>

  <section*|Implementations>

  <\itemize>
    <item><strong|Archives>

    <\itemize>
      <item><hlink|Papers of Massimiliano Gubinelli|https://mgubi.org/papers/> (repository <hlink|mgubi/papers|https://github.com/mgubi/papers>): the first OpenSheaf archive, following version 0.1, with TeXmacs sources, HTML versions and PDFs (profile <verbatim|texmacs>).
    </itemize>

    <item><strong|Tools:> <verbatim|tools/papers.py> in <hlink|mgubi/papers|https://github.com/mgubi/papers>, which deposits documents as OCFL objects with DataCite and provenance metadata, maintains a collection, writes the discovery document and the index, and verifies an archive (also with the JSON Schemas and the <verbatim|ocfl-py> validator).
  </itemize>

  <section*|Files>

  <\itemize>
    <item><hlink|<verbatim|opensheaf-specification-0.1.md>|opensheaf-specification-0.1.tm>: the specification, in Markdown, its only source.

    <item><hlink|<verbatim|FAQ.md>|faq.tm>: answers to common questions about the design.

    <item><verbatim|README.md>: this text, also the home page of the site.

    <item><verbatim|schemas/>: the JSON Schemas of the files defined by the specification (<verbatim|opensheaf.json>, <verbatim|provenance.json>, <verbatim|members.json>), also published at <verbatim|https://opensheaf.org/schemas/>.

    <item><verbatim|index.tm>/<verbatim|index.html>, <verbatim|opensheaf-specification-0.1.tm>/<verbatim|.html>, <verbatim|faq.tm>/<verbatim|faq.html>: the pages of the site, generated from the Markdown files (for TeXmacs and for the web); do not edit them.

    <item><verbatim|notes-meta.ts>: the TeXmacs style package of the page; <verbatim|resources/>: its stylesheets, scripts and fonts.

    <item><verbatim|resources/brand/>: the logo (dot mark and lettering), the symbol, the wordmark and the favicon, as self-contained SVG files (with PNG and PDF copies of the logo); see its README. The lettering is outlined from Geist Serif (SIL Open Font License).

    <item><verbatim|tools/build.py>: converts the Markdown files to TeXmacs (<verbatim|tools/md2tm.py>) and exports them to HTML with TeXmacs. It needs the <verbatim|notes> and <verbatim|max-html> TeXmacs plugins, linked in <verbatim|~/.TeXmacs/plugins>.

    <item><verbatim|CNAME>: the GitHub Pages custom domain, <verbatim|opensheaf.org>.
  </itemize>

  <section*|Licence>

  The text of the specification and of the FAQ is licensed under the <hlink|Creative Commons Attribution-ShareAlike 4.0 International licence|https://creativecommons.org/licenses/by-sa/4.0/> (CC BY-SA 4.0): it may be copied and adapted with attribution, and adapted versions must be shared under the same licence. The JSON Schemas in <verbatim|schemas/> are dedicated to the public domain under <hlink|CC0 1.0|https://creativecommons.org/publicdomain/zero/1.0/>, so that they can be embedded in any software. The tools and style files are licensed under the GNU General Public License, version 3 or later. The fonts in <verbatim|resources/fonts/> keep their own licence (SIL Open Font License).

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
