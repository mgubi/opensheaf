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
  [<hlink|specification|opensheaf-specification-0.1.tm>] [<hlink|use
  cases|use-cases.tm>] [<hlink|FAQ|faq.tm>]
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

  <\active*>
    <\src-comment>
      Alert boxes, from GitHub's alert syntax in the Markdown sources (\<gtr\>
      [!WARNING], [!NOTE], [!IMPORTANT]): a box with a coloured rule on
      its left in TeXmacs (os-alert-box: a one-row table, since the
      padded-framed macro is not defined in TeXmacs 2.1), with the colours
      of the web, where it is a div of class os-alert (with the kind as a
      second class).
    </src-comment>
  </active*>

  <assign|os-alert-box|<macro|rule|paper|body|<surround|<vspace*|0.5fn>|<vspace|0.5fn>|<tformat|<twith|table-width|1par>|<twith|table-hmode|exact>|<twith|table-block|yes>|<cwith|1|1|1|1|cell-width|4pt>|<cwith|1|1|1|1|cell-hmode|exact>|<cwith|1|1|1|1|cell-lsep|0pt>|<cwith|1|1|1|1|cell-rsep|0pt>|<cwith|1|1|1|1|cell-background|<arg|rule>>|<cwith|1|1|2|2|cell-hyphen|t>|<cwith|1|1|2|2|cell-hpart|1>|<cwith|1|1|2|2|cell-background|<arg|paper>>|<cwith|1|1|2|2|cell-lsep|1em>|<cwith|1|1|2|2|cell-rsep|1em>|<cwith|1|1|2|2|cell-tsep|0.6em>|<cwith|1|1|2|2|cell-bsep|0.6em>|<table|<row|<cell|>|<\cell>
    <arg|body>
  </cell>>>>>>>

  <assign|os-alert|<macro|kind|label|body|<if|<equal|<arg|kind>|note>|<os-alert-box|#2f6db5|#eef5fd|<with|color|#1c3554|<with|font-series|bold|<arg|label>>
  <arg|body>>>|<os-alert-box|#d08a1c|#fff7e8|<with|color|#3a2a0f|<with|font-series|bold|color|#8a4b00|<arg|label>>
  <arg|body>>>>>>

  <assign|tmhtml-os-alert|<macro|kind|label|body|<html-div-class|os-alert
  os-<arg|kind>|<html-class|os-alert-label|<arg|label>> <arg|body>>>>

  <\active*>
    <\src-comment>
      Technical terms where they are defined (\<less\>dfn\<gtr\> in the
      Markdown sources): in bold, like the run-in labels; exported to HTML
      as dfn elements, styled the same way by resources/opensheaf.css.
    </src-comment>
  </active*>

  <assign|dfn|<macro|body|<strong|<arg|body>>>>

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
