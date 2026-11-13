#!/usr/bin/env python3
"""Build the OpenSheaf pages from their Markdown sources.

README.md becomes the home page (index.tm, index.html), the specification
opensheaf-specification-0.1.md its own page, and FAQ.md the page faq.html.
tools/md2tm.py converts each Markdown file to TeXmacs, with links between the
Markdown files turned into links between the pages, and TeXmacs exports each
document to HTML. The .tm and .html files are generated: edit the Markdown
files only.

Runs TeXmacs headless with a private profile in texmacs_home/ (not
committed), whose plugins are those linked in ~/.TeXmacs/plugins: the
`notes` and `max-html` plugins of the author's website repository.

    tools/build.py            Markdown -> TeXmacs -> HTML, for every page
    tools/build.py --pdf F    also write a PDF of the specification to F
"""

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TM_HOME = ROOT / "texmacs_home"
USER_PLUGINS = Path(os.environ.get("TEXMACS_PLUGINS", Path.home() / ".TeXmacs/plugins"))
TM = os.environ.get("TEXMACS_BIN", "/Applications/TeXmacs.app/Contents/MacOS/TeXmacs")
# Markdown sources and the TeXmacs documents generated from them; TeXmacs
# exports each document to HTML next to it.
PAGES = {
    "README.md": "index.tm",                                        # home page
    "opensheaf-specification-0.1.md": "opensheaf-specification-0.1.tm",
    "FAQ.md": "faq.tm",
    "USE-CASES.md": "use-cases.tm",
}
SPEC = "opensheaf-specification-0.1.md"


def run_texmacs(calls):
    TM_HOME.mkdir(exist_ok=True)
    if not (TM_HOME / "plugins").exists():
        (TM_HOME / "plugins").symlink_to(USER_PLUGINS)
    for p in ("notes", "max-html"):
        if not (TM_HOME / "plugins" / p).exists():
            sys.exit(f"TeXmacs plugin {p} not found in {USER_PLUGINS}")
    env = dict(os.environ, LC_ALL="C.UTF-8", QT_QPA_PLATFORM="offscreen",
               TEXMACS_HOME_PATH=str(TM_HOME))
    if not (TM_HOME / "system" / "settings.scm").exists():
        # the first start sets the profile up and would discard preferences
        subprocess.run([TM, "-headless", "-x", "(quit-TeXmacs)"], env=env,
                       capture_output=True, timeout=600)
    (TM_HOME / "system" / "preferences.scm").write_text(
        '("texmacs->html:images" "off")\n'
        '("texmacs->html:mathjax" "on")\n'
        '("texmacs->html:mathml" "off")\n')
    # style-clear-cache: TeXmacs caches style environments in the profile,
    # so changes to the style packages would otherwise be ignored.
    cmd = (f"(begin (catch #t (lambda () (style-clear-cache) {calls}) (lambda args (display \"SCHEME-ERROR \")"
           f" (write args) (newline))) (quit-TeXmacs))")
    out = subprocess.run([TM, "-headless", "-x", cmd], env=env, capture_output=True,
                         text=True, errors="replace", timeout=1200)
    if "SCHEME-ERROR" in out.stdout + out.stderr:
        sys.exit(out.stdout + out.stderr)


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--pdf")
    args = p.parse_args()
    maps = []
    for md, tm in PAGES.items():
        maps += ["--map", f"{md}={tm}"]
    for md, tm in PAGES.items():
        subprocess.run([sys.executable, str(ROOT / "tools" / "md2tm.py"), *maps,
                        str(ROOT / md), str(ROOT / tm)], check=True)
    scratch = Path(tempfile.mkdtemp())
    calls = []
    for name in PAGES.values():
        doc = ROOT / name
        pdf = (Path(args.pdf).resolve() if args.pdf and name == PAGES[SPEC]
               else scratch / (doc.stem + ".pdf"))
        # a PDF export typesets the document first (references, links)
        calls.append(f'(let ((u (string->url "{doc}"))) (load-buffer u) (switch-to-buffer u)'
                     f' (export-buffer-main u (string->url "{pdf}") "pdf" (list :overwrite))'
                     f' (export-buffer-main u (string->url "{doc.with_suffix(".html")}")'
                     f' "html" (list :overwrite)))')
    run_texmacs(" ".join(calls))
    shutil.rmtree(scratch, ignore_errors=True)
    print("exported: " + ", ".join(t.replace(".tm", ".html") for t in PAGES.values()))


if __name__ == "__main__":
    main()
