# The Skill Builder

A Claude Code skill that scaffolds a new standalone skill: `src/`/`target/` layout, a root `build.sh` that builds + zips + installs, and SKILL.md with XDG paths and prompt/template variant conventions. Also bundles a POLICY.md that every new or modified skill must pass.

## Install

### Option A: download the release zip

Grab [`dist/the-skill-builder.zip`](dist/the-skill-builder.zip) and unzip it into `~/.claude/skills/`:

```bash
curl -L -o the-skill-builder.zip https://github.com/<user>/the-skill-builder/raw/main/dist/the-skill-builder.zip
unzip -d ~/.claude/skills/ the-skill-builder.zip
```

### Option B: clone and build

```bash
./build.sh
```

Builds `target/the-skill-builder/`, zips it, and copies to `$SKILL_INSTALL_DIR` (defaults to `~/.claude/skills/`).

Flags:

- `--no-install` — stop after the zip.
- `--package` — also copy the zip to `dist/the-skill-builder.zip` and emit a CycloneDX SBOM at `dist/the-skill-builder.cdx.json` (tracked release artifacts).

## Releasing

To cut a new release (e.g. `1.1`):

1. Bump `metadata.version` in `src/the-skill-builder/SKILL.md`.
2. Add a `## 1.1 - YYYY-MM-DD` entry to `CHANGELOG.md`.
3. Build the artifacts: `./build.sh --package`
4. Commit, tag, and push:

   ```bash
   git add -A
   git commit -m "Release v1.1"
   git tag v1.1
   git push origin main
   git push origin v1.1
   ```

5. Create the GitHub release with both artifacts attached:

   ```bash
   gh release create v1.1 dist/the-skill-builder.zip dist/the-skill-builder.cdx.json \
       --title "v1.1" --notes "See CHANGELOG.md for details."
   ```

## Supply chain

Each release ships with a CycloneDX 1.6 SBOM at `dist/the-skill-builder.cdx.json`. Validate it with:

```bash
cyclonedx-cli validate --input-file dist/the-skill-builder.cdx.json
```

(`brew install cyclonedx-cli` if you don't have it.)

## Naming convention

| Name | Form | Example |
|------|------|---------|
| Machine name | lowercase, hyphens | `the-summarizer` |
| Repo dir | `skill-<machine-name>` | `skill-the-summarizer` |
| Inner skill dir | `src/<machine-name>` | `src/the-summarizer` |
| Display name | Title Case prose | `The Summarizer` |

See `src/the-skill-builder/SKILL.md` for the full set of conventions and `src/the-skill-builder/POLICY.md` for the policy walkthrough.
