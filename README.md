# skill-builder

A skill that knows how to scaffold a new skill following Coté's standalone-skill conventions: src/target layout, root `build.sh` that builds + zips + installs, XDG paths in the `io.cote.ai.skill.<name>` namespace, prompt/template variants alongside SKILL.md.

Self-contained. No PII scanning, no audit, no governance - just the layout and the build glue.

## Install

```bash
./build.sh
```

Builds `target/skill-builder/`, zips it, and copies to `$SKILL_INSTALL_DIR` (defaults to `~/.claude/skills/`). Pass `--no-install` to stop after the zip.
