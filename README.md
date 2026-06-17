# skill-builder

A skill that scaffolds a new standalone Claude Code skill: `src/`/`target/` layout, a root `build.sh` that builds + zips + installs, and SKILL.md with XDG paths and prompt/template variant conventions.

## Install

```bash
./build.sh
```

Builds `target/skill-builder/`, zips it, and copies to `$SKILL_INSTALL_DIR` (defaults to `~/.claude/skills/`). Pass `--no-install` to stop after the zip.
