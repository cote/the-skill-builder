---
name: the-skill-builder
description: Scaffolds a new standalone Claude Code /Agent skill. Use when asked to make a new skill, start a new skill, modify existing skill, or scaffold a skill repo.
license: MIT
compatibility: Requires bash and zip.
metadata:
  author: cote
  version: "1.0"
---

# The Skill Builder

Scaffolds a new skill repo using the standalone layout, and applies the policy in [POLICY.md](POLICY.md) on every create-or-modify.

## When to use

When the user asks to "make a new skill", "scaffold a skill", "start a new skill called X", or "change/update/modify the skill," or similar.

## Naming convention

"Machine name" means **machine-friendly name** — the lowercase-hyphenated identifier safe to use in file paths, frontmatter, and shell variables.

Each skill has three names. They all derive from a single machine name:

| Name | Form | Example |
|------|------|---------|
| Machine name | lowercase, hyphens | `the-summarizer` |
| Repo dir | `skill-<machine-name>` | `skill-the-summarizer` |
| Inner skill dir | `src/<machine-name>` | `src/the-summarizer` |
| Display name (H1, prose) | Title Case | `The Summarizer` |
| Frontmatter `name:` | machine name | `the-summarizer` |
| Package name (XDG component) | machine name with hyphens → underscores | `the_summarizer` |

The display name doesn't have to match the machine name 1:1 — it's prose for humans. The machine name is what every file path, frontmatter field, and XDG namespace component uses.

When in doubt, ask: "What's the machine name?" and derive everything else from it.

## What you produce

```
skill-<machine-name>/
  .gitignore
  README.md
  CHANGELOG.md
  build.sh                      ← combined build + zip + install
  src/<machine-name>/
    SKILL.md                    ← from references/SKILL_MD_TEMPLATE.md
    scripts/                    ← optional, empty unless the skill needs CLI work
    references/                 ← static docs the skill reads as background
  target/                       ← build output (gitignored)
```

Prompt and template files live **next to SKILL.md**, not in `references/`:

- `NAME_<DOMAIN>_PROMPT.md` — a behavior variant (e.g. `DEFAULT_SUMMARY_PROMPT.md`, `SHORT_SUMMARY_PROMPT.md`). The skill picks one by matching the user's request to the `NAME` part.
- `NAME_<DOMAIN>_TEMPLATE.md` — a source-specific pre-processing recipe (e.g. `YOUTUBE_SUMMARY_TEMPLATE.md`). Runs before a prompt is applied.

`references/` is reserved for static docs (specs, examples) the skill reads as background context, not behavior the skill picks among.

## Steps to scaffold

1. **Pick the machine name and display name.** Machine name: lowercase, hyphens. Display name: prose, Title Case.

2. **Create the layout.** Make the dirs above. Empty `target/` is fine — `build.sh` populates it.

3. **Write `.gitignore`** — copy `references/GITIGNORE_TEMPLATE`. It covers build output, OS cruft, editor files, and the standard set of secret/credential filenames (`.env`, `*.key`, `*.pem`, SSH keys, cloud creds). Add language-specific lines if needed.

4. **Write `README.md`** — display name as H1, description, install command, usage examples.

5. **Write `CHANGELOG.md`** — one `## 1.0 - YYYY-MM-DD` entry noting the initial scaffold.

6. **Write `build.sh`** — copy the template from `references/BUILD_SH_TEMPLATE.sh`, replacing `SKILL_NAME` with the machine name. `chmod u+x build.sh`.

7. **Write `src/<machine-name>/SKILL.md`** — copy the template from `references/SKILL_MD_TEMPLATE.md`. Set frontmatter `name:` to the machine name, the H1 to the display name, and the XDG namespace to `io.cote.ai.skill.<package-name>` (see below).

8. **Check POLICY.md.** Walk the policy and confirm each item passes. Apply to any scaffold *and* to any later edit of a skill.

9. **Git init** the repo and make an initial commit ("Scaffold <machine-name> skill").

10. **Smoke test** by running `./build.sh --no-install` — confirms the build path works without touching `~/.claude/skills/`.

11. **Deploy** by running `./build.sh` (no flag). It copies `target/<machine-name>/` into `$SKILL_INSTALL_DIR` (defaults to `~/.claude/skills/`), making the skill immediately discoverable by Claude Code. Set `SKILL_INSTALL_DIR` in the environment to deploy somewhere else.

## Modifying an existing skill

When editing a skill (yours or someone else's), re-walk POLICY.md before you finish. The policy applies on every change, not just on creation.

## Conventions captured

### Combined build.sh

One script at the repo root does build + zip + install. Pass `--no-install` to skip the install copy.

The deployable unit is the **directory** `target/<machine-name>/`. The zip is produced as `target/<machine-name>.zip` for distribution but isn't used by the local install path.

### XDG namespace

All four tiers use `io.cote.ai.skill.<package-name>`:

| What | Location |
|------|----------|
| Config | `~/.config/io.cote.ai.skill.<package-name>/` |
| Data | `~/.local/share/io.cote.ai.skill.<package-name>/` |
| State | `~/.local/state/io.cote.ai.skill.<package-name>/` |
| Cache | `~/.cache/io.cote.ai.skill.<package-name>/` |

`<package-name>` is the machine name with hyphens converted to underscores, so the full namespace is a valid reverse-DNS / Java package identifier. Example: machine name `the-summarizer` → package name `the_summarizer` → `io.cote.ai.skill.the_summarizer`.

The default reverse-DNS prefix is `io.cote.ai.skill.` but the user can override it (e.g. `com.acme.skill.`, `dev.example.skills.`). If they don't say, use the default.

Don't collapse state into cache.

### SKILL.md frontmatter

Required fields: `name`, `description`. Recommended: `compatibility`, `metadata` (with `author` and `version`). Stick to the Agent Skills spec — no invented fields.

The `description` is the discovery mechanism. State what the skill does **and when to use it**. Include trigger phrases the user is likely to say.

### Prompt and template files

For skills whose behavior is "pick a prompt and run it":

- Put the variants alongside `SKILL.md` as `NAME_<DOMAIN>_PROMPT.md`.
- SKILL.md's "Actions" section explains the matching rule (case-insensitive match on `NAME`, fallback to `DEFAULT`, user's inline prompt wins).
- Source-specific pre-processing (YouTube transcript fetch, PDF text extract) goes in `NAME_<DOMAIN>_TEMPLATE.md` files alongside the prompts.

## Templates

See `references/`:

- `BUILD_SH_TEMPLATE.sh` — the combined build/zip/install script.
- `SKILL_MD_TEMPLATE.md` — the frontmatter + sections starter.
- `GITIGNORE_TEMPLATE` — the starting `.gitignore`, with build output, OS cruft, editor files, and a wide net of secret/credential patterns.

## Policy

See [POLICY.md](POLICY.md) — required walkthrough on every create or modify.
