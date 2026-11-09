# 05 - Settings GUI limitations

`nix-settings-gui` reads `@option` comments from the source and binds each one
to the assignment directly below it. The assignment must be a direct attribute
binding in a module body, or in an attribute set that the module evaluates
directly.

This file is the authoritative rule. If a control does not appear, fix the
module shape. Do not change `nix-settings-gui` to accept a shape it documents
as unsupported.

## Annotated options must not live in a list of attribute sets

This is not a scanner bug. It is a documented limitation with a fixed rule:
annotated options belong in a plain attribute set, not in a list. Do not patch
the GUI, the scanner, or the parser to accept lists.

This fails and the controls will not appear:

```nix
config = lib.mkMerge [
  {
    # @option widget = "switch"; label = "Enable example";
    ojuny.example.enable = true;
  }
  (lib.mkIf active {
    services.example.enable = true;
  })
];
```

Any of these shapes fail for the same reason:

```nix
# A list literal of attribute sets.
config = [
  {
    # @option widget = "switch"; label = "Enable example";
    ojuny.example.enable = true;
  }
];

# A list produced by map, forEach or a generator.
config = map (name: {
  # @option widget = "switch"; label = name;
  ojuny.example.${name}.enable = true;
}) names;

# An optional attribute set produced by a function call.
config = lib.optionalAttrs active {
  # @option widget = "switch"; label = "Enable example";
  ojuny.example.enable = true;
};
```

The scanner sees a list of expressions, or a function call, not a sequence of
attribute bindings, so the annotated assignment is never collected.

This works:

```nix
# @option widget = "switch"; label = "Enable example";
ojuny.example.enable = true;

config = lib.mkIf active {
  services.example.enable = true;
};
```

`lib.mkIf` is fine. An annotated assignment may sit directly inside a
conditional attribute set. The annotation must be directly above the
assignment, inside the set:

```nix
config = lib.mkIf active {
  # @option widget = "switch"; label = "Service";
  services.example.enable = true;
};
```

Do not move options out of `lib.mkIf`. It is supported. Only lists and
function-call wrappers are the problem.

The rule is about the shape of the surrounding expression, not about the
function that gates it. `lib.mkMerge` is the common offender, but any list
literal, `map`, `forEach` or `lib.optionalAttrs` call that contains annotated
attribute sets has the same failure mode.

## The patch-authoring pattern

Use two modules when a patch has both GUI options and gated install logic.

The front module declares the options and the annotated defaults:

```nix
{ ... }:
{
  options.ojuny.patch.example.enable = lib.mkEnableOption "example";

  config = {
    # @option widget = "switch"; label = "Enable example";
    ojuny.patch.example.enable = false;

    # @option widget = "switch"; label = "Extra service";
    ojuny.patch.example.extra = false;
  };
}
```

The backend module contains only gated install logic and no annotated options:

```nix
{ config, lib, ... }:
{
  config = lib.mkIf config.ojuny.patch.example.enable {
    services.example.enable = true;
    services.example.extra = config.ojuny.patch.example.extra;
  };
}
```

If the gated logic must be conditional per option, use a second `lib.mkIf`
inside the backend module. Do not collect the gated logic into a list.

## Checklist before submitting a patch or module

1. Every `@option` comment sits directly above an assignment in a plain
   `config = { ... }` set or a `lib.mkIf`-wrapped set.
2. No `@option` appears inside `lib.mkMerge`, a list literal, `map`, `forEach`
   or `lib.optionalAttrs`.
3. Install logic that must be conditional lives in a backend module behind
   `lib.mkIf`.
4. Search the file for `mkMerge` before submitting. If it appears, check that
   no annotated option is inside it.
5. Open the settings page and confirm the control renders with its label,
   group, order and `visibleWhen` gate.

## Other limits

- The GUI edits the assignment's value span; it cannot create an option.
- Dynamic attribute names (`${...}`) are not addressable.
- A value wrapped in `let`, `with` or parentheses is peeled for editing; a
  value wrapped in a function call is not rewritten.
- The menu editor reads and writes only `desktop.ojuny.dankMenu.menu`. Rows a
  patch or module assigns to `desktop.ojuny.dankMenu.extraEntries` are merged at
  build time, do not appear in the editor, and are never removed by a GUI save.
- Custom widgets own their data. `facter` reads `07-system/facter.json`,
  `docker` reads and writes the container set, and neither resolves a Nix
  expression. Keep their attached assignments literal or in the shape the
  widget documents.
- Numeric controls must state their unit through `unit` or through the label.
  The settings check rejects a spin or slider that counts a quantity without
  one.
