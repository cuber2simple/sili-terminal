#!/usr/bin/env bash
# sili-tabs.sh — open one Ghostty tab per entry in ~/.ghostty/tabs.env
#
# Ghostty on macOS exposes no CLI/RPC to spawn tabs (unlike WezTerm), so this
# drives the GUI with System Events keystrokes. The controlling terminal needs
# macOS Accessibility permission — you'll be prompted once on first run
# (System Settings → Privacy & Security → Accessibility).
#
# Each entry becomes a tab: the command is pasted into that tab's interactive
# shell, so shell aliases (e.g. ccd) resolve natively; the tab title is set to
# NAME (best-effort — the running program may later change it).
#
# Usage:
#   sili-tabs                     # read ~/.ghostty/tabs.env
#   sili-tabs /path/to/tabs.env   # read a specific file
#   SILI_TABS_DRYRUN=1 sili-tabs  # print what would run, change nothing
#
# While it runs, don't touch the keyboard/mouse — keystrokes go to the
# frontmost window.
set -euo pipefail

ENV_FILE="${1:-$HOME/.ghostty/tabs.env}"
DRYRUN="${SILI_TABS_DRYRUN:-0}"

if [ ! -f "$ENV_FILE" ]; then
  echo "sili-tabs: file not found: $ENV_FILE" >&2
  exit 1
fi

# --- Parse tabs.env into parallel name/cmd arrays ---
names=()
cmds=()
while IFS= read -r line || [ -n "$line" ]; do
  line="${line#"${line%%[![:space:]]*}"}"   # strip leading whitespace
  [ -z "$line" ] && continue                # skip blank
  [ "${line:0:1}" = "#" ] && continue       # skip comment
  case "$line" in *=*) : ;; *) continue ;; esac
  name="${line%%=*}"
  val="${line#*=}"
  name="${name%"${name##*[![:space:]]}"}"   # strip trailing whitespace from name
  case "$val" in                            # strip one layer of surrounding quotes
    \"*\") val="${val#\"}"; val="${val%\"}" ;;
    \'*\') val="${val#\'}"; val="${val%\'}" ;;
  esac
  names+=("$name")
  cmds+=("$val")
done < "$ENV_FILE"

count=${#names[@]}
if [ "$count" -eq 0 ]; then
  echo "sili-tabs: no entries in $ENV_FILE" >&2
  exit 1
fi

# Line pasted into each tab: set the tab title (OSC 0), then run the command.
# The \033 / \007 must stay LITERAL here so the target shell's printf expands
# them when the line is pasted and executed (do NOT let bash interpret them).
build_runline() {
  local name="$1" cmd="$2" bs='\'
  printf '%s' "printf '${bs}033]0;${name}${bs}007'; ${cmd}"
}

if [ "$DRYRUN" = "1" ]; then
  echo "sili-tabs (dry run): $count tab(s) from $ENV_FILE"
  for i in "${!names[@]}"; do
    printf '  [%d] %-16s -> %s\n' "$((i + 1))" "${names[$i]}" "$(build_runline "${names[$i]}" "${cmds[$i]}")"
  done
  exit 0
fi

# --- Drive Ghostty via System Events ---
running="$(osascript -e 'application "Ghostty" is running' 2>/dev/null || echo false)"

open -a Ghostty
osascript -e 'tell application "Ghostty" to activate' >/dev/null 2>&1 || true
sleep 0.7

# If Ghostty was already running, its front window holds an existing session;
# open a fresh window so we start from a clean, known single tab.
if [ "$running" = "true" ]; then
  osascript -e 'tell application "System Events" to keystroke "n" using command down'
  sleep 0.6
fi

for i in "${!names[@]}"; do
  runline="$(build_runline "${names[$i]}" "${cmds[$i]}")"
  if [ "$i" -gt 0 ]; then
    osascript -e 'tell application "System Events" to keystroke "t" using command down'
    sleep 0.4
  fi
  printf '%s' "$runline" | pbcopy
  osascript -e 'tell application "System Events" to keystroke "v" using command down'
  sleep 0.15
  osascript -e 'tell application "System Events" to key code 36'   # Return
  sleep 0.25
done

echo "sili-tabs: opened $count tab(s)."
