#!/usr/bin/env python3
"""Reject settings controls that lose their unit or package search.

Numeric controls must name what they count either through `unit` or through a
unit or count word in the label. A packages control must stay a literal list,
not a `++` expression, because the GUI falls back to raw when it cannot scan the
list.
"""

import argparse
import pathlib
import re
import sys

OPTION_RE = re.compile(r"@option\b(.*?)(?:\*/|$)", re.S)
WIDGET_RE = re.compile(r'widget\s*=\s*"([^"]+)"')
UNIT_RE = re.compile(r"\bunit\s*=\s*\"", re.S)
LABEL_RE = re.compile(r'label\s*=\s*"([^"]*)"')
PACKAGES_EXPR_RE = re.compile(r"=\s*[^;]*\+\+[\s\S]*?;")

UNIT_WORDS = (
    "amount",
    "attempt",
    "byte",
    "column",
    "count",
    "day",
    "delay",
    "entry",
    "factor",
    "generation",
    "height",
    "hour",
    "index",
    "interval",
    "key",
    "minute",
    "number",
    "opacity",
    "percent",
    "port",
    "proportion",
    "ratio",
    "scale",
    "second",
    "size",
    "speed",
    "tag",
    "threshold",
    "timeout",
    "window",
    "width",
    " ms",
    " px",
    " s",
    " %",
)


def option_blocks(text):
    for match in OPTION_RE.finditer(text):
        start = match.start()
        line = text.count("\n", 0, start) + 1
        yield line, match.group(1)


def assignment_after(text, offset):
    rest = text[offset:]
    match = re.search(r"^\s*[^\n]*=", rest, re.M)
    if not match:
        return ""
    start = offset + match.start()
    end = text.find(";", start)
    if end < 0:
        return text[start:]
    return text[start : end + 1]


def check(root):
    root = pathlib.Path(root)
    errors = []
    for path in sorted((root / "modules").rglob("*.nix")):
        text = path.read_text()
        for line, body in option_blocks(text):
            widget = WIDGET_RE.search(body)
            if widget is None:
                continue
            kind = widget.group(1)
            label_match = LABEL_RE.search(body)
            label = label_match.group(1).lower() if label_match else ""
            if kind in {"spin", "slider"} and not UNIT_RE.search(body):
                if not any(word in label for word in UNIT_WORDS):
                    errors.append(
                        "{}:{}: {} control has no unit and its label does not name a unit or count: {}".format(
                            path, line, kind, label or "<no label>"
                        )
                    )
            if kind == "packages":
                offset = text.find(body) + len(body)
                assignment = assignment_after(text, offset)
                if PACKAGES_EXPR_RE.search(assignment):
                    errors.append(
                        "{}:{}: packages control is a ++ expression, not a plain list".format(
                            path, line
                        )
                    )
    return errors


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", required=True)
    args = parser.parse_args()
    errors = check(args.root)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
