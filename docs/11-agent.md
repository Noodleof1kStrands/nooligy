# 11 - Agentic Ojuny

Ojuny can be maintained through two OpenCode agents installed by the
`patch-ojuny-agent` registry patch. The agents are optional. The base image
installs neither agent nor the patch.

The purpose is to make Ojuny agentic without giving an agent unrestricted
control of the machine. The agent works on the Nix flake, where every change is
a normal Git diff that can be reviewed, validated and reverted. Imperative
changes to the running system stay outside the default profile.

## The two agents

### `ojuny-agent`

`ojuny-agent` is the maintenance agent. It can:

- Read the flake, the documentation and the `ojuny` CLI.
- Propose a settings change and apply it only after explicit approval.
- Edit files only inside the Ojuny flake.
- Validate the edit before telling the user to rebuild.
- Show the diff, revert a change, and sync the flake Git.
- Resolve merge conflicts with approval instead of guessing.

It cannot rebuild, activate a generation, use `sudo`, install packages, or
change services. It cannot edit generated hardware, account or secret files.
Runtime `ojuny` commands are denied by default. The patch has an optional
`Allow runtime actions` switch that turns mutating `ojuny` commands into
approval-gated commands. Even then, `sudo`, rebuilds and package changes stay
denied.

### `ojuny-assist`

`ojuny-assist` is the read-only explainer. It answers questions about Ojuny, the
settings menu, patches, the flake and the `ojuny` CLI. It can read files and run
read-only diagnostics. It cannot edit, sync, revert, lock, rebuild, or mutate
anything. If the user asks for a change, it explains the exact setting or file
and points to `ojuny-agent` or the settings GUI.

## The safety boundary

The boundary is the flake:

- An edit must be a normal file change inside the flake.
- The change can be shown with `git diff`.
- The change can be validated with `nix flake check` and a host evaluation.
- The change can be reverted with Git or with the agent CLI.
- The user owns the rebuild.

OpenCode V2 path-scoped permissions enforce the edit boundary. The agent's
`edit` permission is deny by default and ask only inside the flake root. The
generated files are denied even inside the flake. `ojuny-assist` denies `edit`
entirely.

The agent never gets unrestricted shell access. The default is ask. Read-only
commands are allowed, and destructive commands such as `sudo`, `rm`,
`nixos-rebuild`, `nix build`, `systemctl start`, and raw `git push`, `merge` or
`reset` are denied. The agent CLI is the only path for flake Git mutations.

## The `ojuny-agent-cli`

The CLI is installed with the patch. It is read-only by default.

Read-only commands:

```sh
ojuny-agent-cli guide
ojuny-agent-cli status
ojuny-agent-cli settings list
ojuny-agent-cli settings show <page>
ojuny-agent-cli patches list
ojuny-agent-cli patches show <id>
ojuny-agent-cli diagnose
ojuny-agent-cli docs
ojuny-agent-cli diff
ojuny-agent-cli validate
ojuny-agent-cli sync --status
ojuny-agent-cli sync --dry-run
```

Mutating commands require `--yes`:

```sh
ojuny-agent-cli sync
ojuny-agent-cli sync --continue
ojuny-agent-cli sync --abort
ojuny-agent-cli revert <path>
ojuny-agent-cli revert --all
ojuny-agent-cli lock
```

Mutating commands never accept `--flake`. They always use the configured Ojuny
flake, so the CLI cannot be pointed at another repository. The CLI never pushes
and never rewrites history.

## Editing a setting

1. The user asks for a change.
2. The agent finds the page with `ojuny-agent-cli settings show <page>`.
3. The agent reads the module and the governing documents.
4. The agent proposes the file, line, old value, new value and validation plan.
5. The user approves the edit.
6. The agent applies the edit inside the flake.
7. The agent runs `ojuny-agent-cli validate`.
8. If validation fails, the agent fixes the change with a new approval or
   reverts it.
9. If validation passes, the agent shows `ojuny-agent-cli diff`.
10. The user rebuilds.

The agent does not rebuild. A failed build is recovered through the normal NixOS
generation rollback described in `07-lifecycle.md`.

Choose **Allow once** for an edit. **Allow always** saves a durable allow rule
for that path and removes the per-change approval prompt for later edits.

## Git sync and conflicts

`ojuny-agent-cli sync --status` shows the branch, upstream, ahead and behind
counts, dirty state, merge state and backup refs. `sync --dry-run` prints the
planned steps.

A real sync requires a clean worktree and `--yes`. The CLI creates a backup ref,
fetches, then fast-forwards or prepares a no-commit merge. If there are no
conflicts, it validates before `sync --continue` commits. If there are
conflicts, it stops and reports the conflicted files.

The agent never guesses a conflict resolution. It explains both sides, proposes
a resolution, asks for approval, edits the conflicted files, validates, and then
runs `sync --continue`. `sync --abort` aborts an in-progress merge.
`flake.lock` conflicts are resolved deliberately and regenerated with
`ojuny-agent-cli lock`.

## Validation

`ojuny-agent-cli validate` runs:

- `git diff --check` for whitespace errors.
- `nix-instantiate --parse` for changed `.nix` files.
- `nixfmt --check` for changed `.nix` files.
- `scripts/check-baseline.sh` when present, otherwise
  `nix flake check --no-build`.
- A host configuration evaluation.

It does not build the system, switch generations, or change services. The
contributor gate remains `sh scripts/check-baseline.sh`.

## Documentation and AGENTS.md

The patch's CLI `guide` command and the two agent prompts share one guide. The
agents also load the flake `AGENTS.md` when it exists.

`AGENTS.md` is the repository contributor guide. It is a separate scheduled
task and is not created by this patch. Until it lands, the embedded guide is the
source of truth for the agents.

The registry metadata is the install and removal reference. This page is the
user-facing explanation.

## Limits

- The agents require `patch-development` and its OpenCode agent.
- The patch does not enable the development patch or OpenCode.
- The agents do not replace the settings GUI. Both edit the same modules.
- The agents do not push. Push remains a manual Git action.
- The agents do not rebuild. The user runs the rebuild.
- The registry patch copies one module, so the CLI and guide are embedded in
  that module rather than installed as separate files.
