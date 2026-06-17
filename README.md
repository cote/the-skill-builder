# The Skill Builder

A Claude Code skill that scaffolds a new standalone skill: `src/`/`target/` layout, a root `build.sh` that builds + zips + installs, and SKILL.md with XDG paths and prompt/template variant conventions. Also bundles a POLICY.md that every new or modified skill must pass.

## Install

```bash
./build.sh
```

Builds `target/the-skill-builder/`, zips it, and copies to `$SKILL_INSTALL_DIR` (defaults to `~/.claude/skills/`). Pass `--no-install` to stop after the zip.

## Naming convention

| Name | Form | Example |
|------|------|---------|
| Machine name | lowercase, hyphens | `the-summarizer` |
| Repo dir | `skill-<machine-name>` | `skill-the-summarizer` |
| Inner skill dir | `src/<machine-name>` | `src/the-summarizer` |
| Display name | Title Case prose | `The Summarizer` |

See `src/the-skill-builder/SKILL.md` for the full set of conventions and `src/the-skill-builder/POLICY.md` for the policy walkthrough.
