#!/usr/bin/env bash
# common-sense installer. Detects Claude Code, Wizard, Codex, and Pi and
# installs into whichever it finds. Safe to re-run.
#
#   curl -fsSL https://raw.githubusercontent.com/teddytennant/common-sense/main/install.sh | bash
#
# Env:
#   COMMON_SENSE_SRC=/path/to/checkout
#   COMMON_SENSE_TARGET=claude|wizard|codex|pi|both|all
#     default: all, whichever are present
set -euo pipefail

SRC="${COMMON_SENSE_SRC:-}"
TARGET="${COMMON_SENSE_TARGET:-all}"
CLONE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/common-sense"

say()   { printf '  %s\n' "$*"; }
head_() { printf '\n%s\n' "$*"; }
die()   { printf '\ncommon-sense: %s\n' "$*" >&2; exit 1; }

want() {
  case "$TARGET" in
    all|both) return 0 ;;
    "$1") return 0 ;;
    *) return 1 ;;
  esac
}

copy_skill() {
  local dest="$1"
  mkdir -p "$dest"
  cp "$SKILL_SRC" "$dest/SKILL.md"
  say "wrote $dest/SKILL.md"
}

head_ "common-sense installer"

# --- source ------------------------------------------------------------------
if [ -z "$SRC" ]; then
  if [ -f "$(dirname "$0")/skills/common-sense/SKILL.md" ]; then
    SRC="$(cd "$(dirname "$0")" && pwd)"
  else
    command -v git >/dev/null 2>&1 || die "git is required to fetch the skill"
    say "fetching common-sense into $CLONE_DIR"
    if [ -d "$CLONE_DIR/.git" ]; then
      git -C "$CLONE_DIR" pull --ff-only --quiet
    else
      mkdir -p "$(dirname "$CLONE_DIR")"
      git clone --depth 1 --quiet https://github.com/teddytennant/common-sense "$CLONE_DIR"
    fi
    SRC="$CLONE_DIR"
  fi
fi

SKILL_SRC="$SRC/skills/common-sense/SKILL.md"
[ -f "$SKILL_SRC" ] || die "not a common-sense checkout: $SRC"
say "source: $SRC"

installed_any=0

# --- Claude Code -------------------------------------------------------------
if want claude; then
  if command -v claude >/dev/null 2>&1; then
    head_ "Claude Code"
    if [ -f "$SRC/.claude-plugin/marketplace.json" ]; then
      claude plugin marketplace add "$SRC" >/dev/null 2>&1 \
        || claude plugin marketplace update common-sense >/dev/null 2>&1 || true
      if claude plugin install common-sense@common-sense >/dev/null 2>&1; then
        say "installed plugin common-sense@common-sense"
      else
        say "plugin already installed, or install needs a restart"
      fi
    fi
    copy_skill "$HOME/.claude/skills/common-sense"
    installed_any=1
  else
    say "claude not on PATH, skipping Claude Code plugin install"
  fi
fi

# --- Wizard ------------------------------------------------------------------
if want wizard; then
  if command -v wizard >/dev/null 2>&1 || [ -d "${WIZARD_HOME:-$HOME/.wizard}" ]; then
    head_ "Wizard"
    if [ -x "$SRC/plugins/common-sense/wizard/install.sh" ] || [ -f "$SRC/plugins/common-sense/wizard/install.sh" ]; then
      bash "$SRC/plugins/common-sense/wizard/install.sh" | sed 's/^/  /'
    else
      copy_skill "${WIZARD_HOME:-$HOME/.wizard}/skills/common-sense"
    fi
    installed_any=1
  else
    say "wizard not found, skipping Wizard install"
  fi
fi

# --- Codex -------------------------------------------------------------------
if want codex; then
  if command -v codex >/dev/null 2>&1 || [ -d "$HOME/.codex" ]; then
    head_ "Codex"
    copy_skill "$HOME/.codex/skills/common-sense"
    copy_skill "$HOME/.agents/skills/common-sense"
    installed_any=1
  else
    say "codex not found, skipping Codex install"
  fi
fi

# --- Pi ----------------------------------------------------------------------
if want pi; then
  if command -v pi >/dev/null 2>&1 || [ -d "$HOME/.pi" ]; then
    head_ "Pi"
    copy_skill "$HOME/.pi/agent/skills/common-sense"
    copy_skill "$HOME/.agents/skills/common-sense"
    installed_any=1
  else
    say "pi not found, skipping Pi install"
  fi
fi

# --- neither / fallback ------------------------------------------------------
if [ "$installed_any" -eq 0 ]; then
  head_ "No target agent found on PATH"
  say "installing into the paths most tools read anyway"
  copy_skill "$HOME/.claude/skills/common-sense"
  copy_skill "$HOME/.agents/skills/common-sense"
  installed_any=1
fi

head_ "Done. Restart the agent, or run /reload in Wizard."
printf '\n'
