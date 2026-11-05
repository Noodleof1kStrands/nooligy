"""Minimal JS object-literal parser for DMS settings spec files."""
import re


class Func:
    def __init__(self, text):
        self.text = text

    def __repr__(self):
        return "<%s>" % self.text


TOKEN_RE = re.compile(r"""
    (?P<ws>\s+)
  | (?P<comment>//[^\n]*|/\*.*?\*/)
  | (?P<string>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')
  | (?P<number>-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)
  | (?P<ident>[A-Za-z_$][\w$]*(?:\.[A-Za-z_$][\w$]*)*)
  | (?P<punct>[{}\[\]:,()=+\-*/<>!?&|.])
""", re.S | re.X)


def tokenize(src):
    toks = []
    i = 0
    while i < len(src):
        m = TOKEN_RE.match(src, i)
        if not m:
            toks.append(("unk", src[i]))
            i += 1
            continue
        kind = m.lastgroup
        if kind not in ("ws", "comment"):
            toks.append((kind, m.group()))
        i = m.end()
    return toks


class Parser:
    def __init__(self, toks):
        self.t = toks
        self.i = 0

    def peek(self):
        return self.t[self.i] if self.i < len(self.t) else (None, None)

    def next(self):
        tok = self.peek()
        self.i += 1
        return tok

    def value(self):
        kind, val = self.next()
        if kind == "punct" and val == "{":
            return self.obj()
        if kind == "punct" and val == "[":
            return self.arr()
        if kind == "string":
            return unquote(val)
        if kind == "number":
            return float(val) if ("." in val or "e" in val.lower()) else int(val)
        if kind == "ident":
            if val == "true":
                return True
            if val == "false":
                return False
            if val == "null":
                return None
            # function call or bare identifier: consume balanced parens
            if self.peek() == ("punct", "("):
                depth = 0
                parts = [val]
                while True:
                    k, v = self.next()
                    if k is None:
                        break
                    parts.append(v)
                    if v == "(":
                        depth += 1
                    elif v == ")":
                        depth -= 1
                        if depth == 0:
                            break
                return Func("".join(parts))
            return Func(val)
        if kind == "punct" and val == "-":
            n = self.value()
            return -n if isinstance(n, (int, float)) else Func("-" + str(n))
        return Func(str(val))

    def arr(self):
        out = []
        while True:
            k, v = self.peek()
            if k is None:
                break
            if v == "]":
                self.next()
                break
            if v == ",":
                self.next()
                continue
            out.append(self.value())
        return out

    def obj(self):
        out = {}
        while True:
            kind, val = self.peek()
            if kind is None:
                break
            if val == "}":
                self.next()
                break
            if val == ",":
                self.next()
                continue
            key = None
            if kind in ("string", "ident"):
                key = unquote(val)
                self.next()
            elif kind == "number":
                key = val
                self.next()
            else:
                self.next()
                continue
            if self.peek() != ("punct", ":"):
                # shorthand or something odd
                continue
            self.next()
            out[key] = self.value()
        return out


def unquote(s):
    if s and s[0] in "\"'":
        body = s[1:-1]
        return body.encode().decode("unicode_escape")
    return s


def parse_object(src, start_marker):
    """Parse an object literal that begins at start_marker."""
    idx = src.index(start_marker) + len(start_marker)
    # find the opening brace
    idx = src.index("{", idx)
    toks = tokenize(src[idx:])
    return Parser(toks).value()
