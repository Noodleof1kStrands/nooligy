#!/usr/bin/env python3
"""Reject bind args that were rewritten as quoted lists or expressions.

A keybind args field is either a plain string or a Nix list. Encoding a list
or an expression as a quoted string still parses, but the generated mango
config then runs the literal text instead of the command.
"""

import argparse
import pathlib
import re
import sys

EXPRESSION_PREFIXES = ("config.", "desktop.", "ojuny.", "inputs.", "lib.")
ARGS_PATTERN = re.compile(r'\bargs\s*=\s*"((?:[^"\\]|\\.)*)"\s*;')


def check(root):
    path = pathlib.Path(root) / "modules/02-core/03-binds.nix"
    errors = []
    for number, line in enumerate(path.read_text().splitlines(), 1):
        match = ARGS_PATTERN.search(line)
        if match is None:
            continue
        value = match.group(1).strip()
        if value.startswith("["):
            errors.append(
                "{}:{}: args is a quoted list: {}".format(path, number, value)
            )
        elif value.startswith(EXPRESSION_PREFIXES):
            errors.append(
                "{}:{}: args is a quoted expression: {}".format(path, number, value)
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
