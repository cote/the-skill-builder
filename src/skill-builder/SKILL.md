---
name: skill-builder
description: >
  Scaffolds a new standalone Claude Code skill: src/target layout, a root
  build.sh that builds + zips + installs, XDG paths under
  io.cote.ai.skill.<name>, and prompt/template variants alongside SKILL.md.
  Use when asked to make a new skill, start a new skill, or scaffold a skill repo.
compatibility: Requires bash and zip.
metadata:
  author: cote
  version: "1.0"
---

# skill-builder

Scaffolds a new skill repo using the standalone layout.

## When to use

When the user asks to "make a new skill", "scaffold a skill", "start a new skill called X", or similar.

## What you produce

```
skill-<name>/
  .gitignore
  README.md
  CHANGELOG.md
  build.sh                      ← combined build + zip + install
  src/<name>/
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

1. **Pick the name.** Lowercase, hyphens. Repo dir is `skill-<name>/`. Skill dir is `src/<name>/`.

2. **Create the layout.** Make the dirs above. Empty `target/` is fine — `build.sh` populates it.

3. **Write `.gitignore`** — at minimum: `.DS_Store`, `target/`.

4. **Write `README.md`** — description, install command, usage examples.

5. **Write `CHANGELOG.md`** — one `## 1.0 - YYYY-MM-DD` entry noting the initial scaffold.

6. **Write `build.sh`** — copy the template from `references/BUILD_SH_TEMPLATE.sh`, replacing `SKILL_NAME` with the actual skill name. `chmod u+x build.sh`.

7. **Write `src/<name>/SKILL.md`** — copy the template from `references/SKILL_MD_TEMPLATE.md` and fill in name, description, and the XDG namespace.

8. **Git init** the repo and make an initial commit ("Scaffold <name> skill").

9. **Smoke test** by running `./build.sh --no-install` — confirms the build path works without touching `~/.claude/skills/`.

## Conventions captured

### Combined build.sh

One script at the repo root does build + zip + install. Pass `--no-install` to skip the install copy.

The deployable unit is the **directory** `target/<name>/`. The zip is produced as `target/<name>.zip` for distribution but isn't used by the local install path.

### XDG namespace

All four tiers use `io.cote.ai.skill.<name>`:

| What | Location |
|------|----------|
| Config | `~/.config/io.cote.ai.skill.<name>/` |
| Data | `~/.local/share/io.cote.ai.skill.<name>/` |
| State | `~/.local/state/io.cote.ai.skill.<name>/` |
| Cache | `~/.cache/io.cote.ai.skill.<name>/` |

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
