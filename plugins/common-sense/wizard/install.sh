#!/usr/bin/env bash
# Install common-sense for Wizard: the skill and one slash command. Idempotent.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"   # .../plugins/common-sense/wizard
PLUGIN_DIR="$(cd "$HERE/.." && pwd)"    # .../plugins/common-sense
WZ="${WIZARD_HOME:-$HOME/.wizard}"

mkdir -p "$WZ/skills/common-sense" "$WZ/commands"

# Wizard reads ~/.wizard/skills/<name>/SKILL.md with the same frontmatter
# convention Claude Code uses, so the skill copies over unchanged.
cp "$PLUGIN_DIR/skills/common-sense/SKILL.md" "$WZ/skills/common-sense/SKILL.md"
cp "$HERE/common-sense.md" "$WZ/commands/common-sense.md"

echo "Installed common-sense for Wizard:"
echo "  skill   -> $WZ/skills/common-sense/SKILL.md"
echo "  command -> /common-sense"
echo
echo "Run /reload in Wizard (or restart) to activate."
