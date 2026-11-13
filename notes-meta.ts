<TeXmacs|2.1.5>

<style|source>

<\body>
  <\active*>
    <\src-title>
      <src-package|notes-meta|1.0>

      <src-purpose|Site style for the pages of the OpenSheaf repository (the
      specification). Stylesheets and scripts are in
      resources/, given by relative paths, which work on the web server and
      from the file system.>

      <src-copyright|2026|Massimiliano Gubinelli>
    </src-title>
  </active*>

  <assign|notes-main-dir|https://mgubi.org/docs>

  <assign|notes-meta-name|papers>

  <\active*>
    <\src-comment>
      The header names the site and links to the first OpenSheaf archive.
    </src-comment>
  </active*>

  <assign|notes-header-links|<macro|[<hlink|OpenSheaf|index.tm>]
  [<hlink|specification|opensheaf-specification-0.1.tm>] [<hlink|FAQ|faq.tm>]
  [<hlink|first archive|https://mgubi.org/papers/>]>>

  <assign|notes-header-name|OpenSheaf>

  <\active*>
    <\src-comment>
      Reading layout: regular-weight serif headings, an upright abstract,
      compact paragraphs, and charcoal ink on warm off-white paper.
    </src-comment>
  </active*>

  <assign|notes-heading|<macro|body|<with|font-family|rm|font-series|medium|color|#292825|<arg|body>>>>

  <assign|notes-abstract|<macro|body|<with|font-family|rm|font-series|medium|font-shape|right|<arg|body>>>>

  <assign|par-sep|0.5fn>

  <assign|par-line-sep|0.2fn>

  <assign|notes-title-color|#292825>

  <assign|notes-text-color|#292825>

  <assign|notes-background-color|#faf9f6>

  <assign|color|#292825>

  <assign|bg-color|#faf9f6>

  <assign|locus-color|#292825>

  <assign|visited-color|#292825>

  <assign|html-title|OpenSheaf>

  <assign|html-head-favicon|resources/brand/favicon.svg>

  <assign|html-head-javascript-src|<tuple|resources/theme.js>>

  <assign|html-css|resources/notes-base.css>

  <assign|html-extra-css|<tuple|resources/opensheaf.css>>

  <assign|html-extra-javascript-src|<tuple|resources/highlight.pack.js|resources/notes-base.js>>
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
  </collection>
</initial>
