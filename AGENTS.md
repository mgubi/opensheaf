# Working on this repository

This repository holds the OpenSheaf specification, its JSON Schemas, the FAQ,
the use cases and the site `https://opensheaf.org/` built from them. These
notes are for anyone, person or agent, changing it.

## Skills

- [`.agents/skills/opensheaf-spec/`](.agents/skills/opensheaf-spec/SKILL.md):
  the concepts of the specification, where each one is defined, and how to
  change the text. Read it before changing the specification, the schemas,
  the FAQ or the use cases.
- [`.agents/skills/opensheaf-style/`](.agents/skills/opensheaf-style/SKILL.md):
  the look of the site and the build of the pages. Read it before changing
  layout, typography, colours, brand assets, the converter or the style.

## Sources and build

- Edit only the Markdown sources: `README.md` (also the home page),
  `opensheaf-specification-0.1.md`, `FAQ.md`, `USE-CASES.md`; and the
  schemas in `schemas/`.
- Run `tools/build.py` after every change of a Markdown source, and commit
  the regenerated `.tm` and `.html` files with their sources. Never edit the
  `.tm` or `.html` files by hand. The build needs TeXmacs and its `notes` and
  `max-html` plugins (see the style skill).
- Keep the Markdown sources in ASCII: the converter writes Latin-1 and stops
  on other characters (write `...`, not an ellipsis, and `->`, not an
  arrow).
- Check that the schemas still parse (`python3 -c "import json; json.load(open(F))"`)
  after editing them.

## The specification is a draft

- Version 0.1 is a draft. Agreed changes go into 0.1 itself: no 0.2, no
  compatibility rules, no deprecated names; format names stay
  `opensheaf-object/0.1` and so on. Archives built with the draft are
  rebuilt when 0.1 is final.
- Each change of the specification gets a line in its changelog (section
  17), dated, and the date in the heading is updated.
- Open design questions are discussed in the
  [issues](https://github.com/opensheaf/opensheaf.github.io/issues), with the
  existing labels (`design` for open questions, `settled` once written into
  the specification, and topic labels such as `versions`, `collections`,
  `identifiers`, `decentralisation`, `applications`). Do not settle an open
  question in the text without agreement; state it as open, and point to its
  issue.
- The use cases and the FAQ are non-normative and must agree with the
  specification; where they describe something the specification does not
  yet support, they say so and point to the issue.

## Writing

- Plain, precise British English (licence, catalogue, organisation); short
  declarative sentences; no marketing tone.
- Terms: `<dfn>term</dfn>` where a term is defined (the terminology of the
  specification, terms introduced in the use cases), **bold** for other key
  uses, `code` for literal names, fields and values.
- Use the terms of the specification consistently (see the spec skill):
  catalogue and selection, mirror and accepted copy, document version and
  object version, pin, revision.
- Wrap Markdown paragraphs at about 78 columns, except in the specification,
  whose paragraphs are one line each.

## Related repositories

The [opensheaf](https://github.com/opensheaf) organisation also holds the
reference tools (`opensheaf-py`, the `osheaf` command), the Explorer, the
archive and collection templates, and test data. A change of the format
usually needs a change of the tools; the first archive,
[mgubi/papers](https://github.com/mgubi/papers), is where the tools are
developed against a real archive.
