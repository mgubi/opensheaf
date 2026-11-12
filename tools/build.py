#!/usr/bin/env python3
"""Export the OpenSheaf pages (index.tm, the specification) to HTML.

Runs TeXmacs headless with a private profile in texmacs_home/ (not
committed), whose plugins are those linked in ~/.TeXmacs/plugins: the
`notes` and `max-html` plugins of the author's website repository.

    tools/build.py            export index.tm to index.html
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
DOCS = ["index.tm"]


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
    cmd = (f"(begin (catch #t (lambda () {calls}) (lambda args (display \"SCHEME-ERROR \")"
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
    scratch = Path(tempfile.mkdtemp())
    calls = []
    for name in DOCS:
        doc = ROOT / name
        pdf = Path(args.pdf).resolve() if args.pdf and name == "index.tm" else scratch / "x.pdf"
        # a PDF export typesets the document first (references, links)
        calls.append(f'(let ((u (string->url "{doc}"))) (load-buffer u) (switch-to-buffer u)'
                     f' (export-buffer-main u (string->url "{pdf}") "pdf" (list :overwrite))'
                     f' (export-buffer-main u (string->url "{doc.with_suffix(".html")}")'
                     f' "html" (list :overwrite)))')
    run_texmacs(" ".join(calls))
    shutil.rmtree(scratch, ignore_errors=True)
    print("exported: " + ", ".join(d.replace(".tm", ".html") for d in DOCS))


if __name__ == "__main__":
    main()
