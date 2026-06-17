#!/bin/bash
# Assemble target/the-skill-builder/, zip it, and install into $SKILL_INSTALL_DIR
# (default: ~/.claude/skills). Pass --no-install to skip the install step.
set -euo pipefail

SKILL_NAME="the-skill-builder"
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/src/$SKILL_NAME"
TARGET_DIR="$ROOT/target"
TARGET="$TARGET_DIR/$SKILL_NAME"
ZIP="$TARGET_DIR/$SKILL_NAME.zip"
DEST_ROOT="${SKILL_INSTALL_DIR:-$HOME/.claude/skills}"
DEST="$DEST_ROOT/$SKILL_NAME"

INSTALL=true
[[ "${1:-}" == "--no-install" ]] && INSTALL=false

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

if $INSTALL; then
    mkdir -p "$DEST_ROOT"
    rm -rf "$DEST"
    cp -R "$TARGET" "$DEST"
    echo "Installed: $DEST"
fi
