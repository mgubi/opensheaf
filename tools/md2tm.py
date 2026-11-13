#!/usr/bin/env python3
"""Convert the OpenSheaf specification from Markdown to a TeXmacs document.

    tools/md2tm.py [--map FILE.md=FILE.tm ...] input.md output.tm

`--map` turns links to Markdown files that are converted too into links to
their TeXmacs versions (exported to HTML, they become links to the pages).

Handles the subset of Markdown used by spec.md:

- `# Title` (first line): the page title; the first paragraph, if it is in
  *italics*, becomes the abstract;
- `## Section`, `### Subsection`;
- paragraphs; lists with `- ` and nested lists indented by two spaces;
  a paragraph after a nested list is indented by two spaces;
- fenced code blocks (three backticks);
- inline `code`, **bold**, *italic* and [text](target) links.

The output uses the `notes` style of the author's website with the package
`notes-meta.ts` of this repository. Strings are written for TeXmacs files:
`<`, `>`, `|` and backslashes are escaped, leading and repeated spaces in
code are made explicit, and the file is written in Latin-1 (the
specification is kept in ASCII).
"""

import re
import sys


def esc(t):
    table = {'\\': '\\\\', '<': '\\<less\\>', '>': '\\<gtr\\>', '|': '\\|'}
    return ''.join(table.get(c, c) for c in t)


def emphasis(p):
    p = re.sub(r'\*\*(.+?)\*\*', r'<strong|\1>', p)
    p = re.sub(r'(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])', r'<em|\1>', p)
    return p


LINK_MAP = {}   # Markdown target -> TeXmacs target (set by --map)


def code_and_emphasis(t):
    out = []
    for i, part in enumerate(re.split(r'`([^`]*)`', t)):
        out.append(f'<verbatim|{esc(part)}>' if i % 2 else emphasis(esc(part)))
    return ''.join(out)


def inline(t):
    # links first: their text may contain `code`
    pieces = re.split(r'\[([^\]]+)\]\(([^)\s]+)\)', t)
    out = []
    for k in range(0, len(pieces), 3):
        out.append(code_and_emphasis(pieces[k]))
        if k + 2 < len(pieces):
            target = pieces[k + 2]
            base, _, anchor = target.partition('#')
            if base in LINK_MAP:
                target = LINK_MAP[base] + ('#' + anchor if anchor else '')
            out.append(f'<hlink|{code_and_emphasis(pieces[k + 1])}|{esc(target)}>')
    return ''.join(out)


def code_line(c):
    if not c.strip():
        return ''
    n = len(c) - len(c.lstrip(' '))
    rest = re.sub(r' {2,}', lambda m: ' ' + '\\ ' * (len(m.group()) - 1),
                  esc(c.lstrip(' ')))
    return '    ' + '\\ ' * n + rest


def convert(md):
    lines = md.split('\n')
    if not lines or not lines[0].startswith('# '):
        sys.exit('spec.md must start with "# Title"')
    title = lines[0][2:].strip()
    i = 1
    while i < len(lines) and not lines[i].strip():
        i += 1
    abstract = None
    if i < len(lines) and lines[i].startswith('*') and not lines[i].startswith('**'):
        para = []
        while i < len(lines) and lines[i].strip():
            para.append(lines[i].strip())
            i += 1
        text = ' '.join(para)
        abstract = text[1:-1] if text.endswith('*') else text

    blocks = []
    while i < len(lines):
        l = lines[i]
        if not l.strip():
            i += 1
            continue
        if l.startswith('```'):
            j = i + 1
            code = []
            while j < len(lines) and not lines[j].startswith('```'):
                code.append(lines[j])
                j += 1
            body = '\n\n'.join(code_line(c) for c in code)
            blocks.append('  <\\verbatim-code>\n' + body + '\n  </verbatim-code>')
            i = j + 1
            continue
        if l.startswith('### '):
            blocks.append(f'  <subsection*|{inline(l[4:])}>')
            i += 1
            continue
        if l.startswith('## '):
            blocks.append(f'  <section*|{inline(l[3:])}>')
            i += 1
            continue
        if l.startswith('- '):
            items = []  # [text, [subitems], text after the sub-list]
            while i < len(lines) and (lines[i].startswith('- ') or lines[i].startswith('  ')):
                ln = lines[i]
                if ln.startswith('- '):
                    items.append([ln[2:], [], ''])
                elif ln.startswith('  - '):
                    items[-1][1].append(ln[4:])
                elif items[-1][1] and ln.startswith('    '):
                    items[-1][1][-1] += ' ' + ln.strip()
                elif items[-1][1]:
                    items[-1][2] += ' ' + ln.strip()
                else:
                    items[-1][0] += ' ' + ln.strip()
                i += 1

            def render(text, subs, after):
                out = '    <item>' + inline(text)
                if subs:
                    out += ('\n\n    <\\itemize>\n'
                            + '\n\n'.join('      <item>' + inline(x) for x in subs)
                            + '\n    </itemize>')
                if after.strip():
                    out += '\n\n    ' + inline(after.strip())
                return out

            body = '\n\n'.join(render(*it) for it in items)
            blocks.append('  <\\itemize>\n' + body + '\n  </itemize>')
            continue
        para = []
        while (i < len(lines) and lines[i].strip()
               and not re.match(r'(#{1,3} |- |```)', lines[i])):
            para.append(lines[i].strip())
            i += 1
        blocks.append('  ' + inline(' '.join(para)))

    head = ('<TeXmacs|2.1.5>\n\n<style|<tuple|notes|notes-meta>>\n\n<\\body>\n'
            '  <notes-header>\n\n'
            f'  <chapter*|{inline(title)}>\n\n')
    if abstract:
        head += f'  <notes-abstract|{inline(abstract)}>\n\n'
    tail = ('\n</body>\n\n<\\initial>\n  <\\collection>\n'
            '    <associate|page-medium|paper>\n  </collection>\n</initial>\n')
    return head + '\n\n'.join(blocks) + '\n' + tail


def main():
    args = sys.argv[1:]
    while args and args[0] == '--map':
        src, _, dst = args[1].partition('=')
        LINK_MAP[src] = dst
        args = args[2:]
    if len(args) != 2:
        sys.exit(__doc__)
    sys.argv[1:] = args
    md = open(sys.argv[1], encoding='utf-8').read()
    try:
        md.encode('latin-1')
    except UnicodeEncodeError as e:
        sys.exit(f'{sys.argv[1]}: keep the specification in ASCII ({e})')
    with open(sys.argv[2], 'w', encoding='latin-1', newline='') as f:
        f.write(convert(md))


if __name__ == '__main__':
    main()
