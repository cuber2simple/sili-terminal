#!/bin/bash
# Sili Terminal - Open a NEW Ghostty window with specified layout
# Usage: dup [layout-name]
# Default: hacker
#
# Examples:
#   dup              -> new Ghostty window with hacker layout
#   dup claude-dev   -> new Ghostty window with claude-dev layout
#   dup codex-dev    -> new Ghostty window with codex-dev layout

LAYOUT="${1:-hacker}"

open -na Ghostty.app --args -e zellij --layout "$LAYOUT"
