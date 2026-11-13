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
      The OpenSheaf look: the serif of the text for the headings, in bold, and a palette on a single hue: shades of
      blue from a tinted paper to deep ink.
    </src-comment>
  </active*>

  <assign|notes-heading|<macro|body|<with|font-family|rm|font-series|bold|color|#1c3554|<arg|body>>>>

  <assign|notes-title-color|#1c3554>

  <assign|notes-text-color|#212a36>

  <assign|notes-background-color|#f8fafc>

  <assign|color|#212a36>

  <assign|bg-color|#f8fafc>

  <assign|locus-color|#265082>

  <assign|visited-color|#476385>

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
