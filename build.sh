#!/bin/bash
# Assemble target/the-skill-builder/, zip it, install into $SKILL_INSTALL_DIR
# (default: ~/.claude/skills), and optionally copy the zip to dist/ as a
# committed release artifact.
#
# Flags (combinable, any order):
#   --no-install   Skip the install step.
#   --package      Copy the zip to dist/<machine-name>.zip (the tracked
#                  release artifact people can download directly).
set -euo pipefail

SKILL_NAME="the-skill-builder"
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/src/$SKILL_NAME"
TARGET_DIR="$ROOT/target"
TARGET="$TARGET_DIR/$SKILL_NAME"
ZIP="$TARGET_DIR/$SKILL_NAME.zip"
DIST_DIR="$ROOT/dist"
DIST_ZIP="$DIST_DIR/$SKILL_NAME.zip"
DEST_ROOT="${SKILL_INSTALL_DIR:-$HOME/.claude/skills}"
DEST="$DEST_ROOT/$SKILL_NAME"

INSTALL=true
PACKAGE=false
for arg in "$@"; do
    case "$arg" in
        --no-install) INSTALL=false ;;
        --package)    PACKAGE=true ;;
        *) echo "Unknown flag: $arg" >&2; exit 2 ;;
    esac
done

[[ -d "$SRC" ]] || { echo "Error: $SRC missing" >&2; exit 1; }

rm -rf "$TARGET" "$ZIP"
mkdir -p "$TARGET_DIR"
cp -R "$SRC" "$TARGET"

find "$TARGET" \( -name '.DS_Store' -o -name '._*' \) -delete 2>/dev/null || true

if [[ -d "$TARGET/scripts" ]]; then
    find "$TARGET/scripts" -type f -exec chmod u+x {} \;
fi

(cd "$TARGET_DIR" && zip -qr "$SKILL_NAME.zip" "$SKILL_NAME")

echo "Built: $TARGET"
echo "Zipped: $ZIP"

if $PACKAGE; then
    mkdir -p "$DIST_DIR"
    cp "$ZIP" "$DIST_ZIP"
    echo "Packaged: $DIST_ZIP"

    SBOM="$DIST_DIR/$SKILL_NAME.cdx.json"
    ZIP_SHA="$(shasum -a 256 "$DIST_ZIP" | awk '{print $1}')"
    TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    UUID="$(uuidgen | tr 'A-Z' 'a-z')"
    cat > "$SBOM" <<EOF
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "serialNumber": "urn:uuid:$UUID",
  "version": 1,
  "metadata": {
    "timestamp": "$TS",
    "tools": [
      { "vendor": "the-skill-builder", "name": "build.sh", "version": "1.0" }
    ],
    "component": {
      "type": "application",
      "bom-ref": "pkg:generic/$SKILL_NAME@1.0",
      "name": "$SKILL_NAME",
      "version": "1.0",
      "description": "Claude Code skill: scaffold a new standalone skill.",
      "licenses": [ { "license": { "id": "MIT" } } ],
      "authors": [ { "name": "Michael Cote" } ],
      "hashes": [ { "alg": "SHA-256", "content": "$ZIP_SHA" } ]
    }
  },
  "components": []
}
EOF
    echo "SBOM:     $SBOM"
fi

if $INSTALL; then
    mkdir -p "$DEST_ROOT"
    rm -rf "$DEST"
    cp -R "$TARGET" "$DEST"
    echo "Installed: $DEST"
fi
