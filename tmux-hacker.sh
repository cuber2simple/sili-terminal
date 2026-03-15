#!/bin/bash
# Sili Terminal - Hacker Workspace (tmux)
# ┌─────────────────────────────────────┐
# │        CLAUDE CODE (全屏)            │
# │                                      │
# │   Alt-s → 文件搜索 (fzf + preview)  │
# │   Alt-t → 临时终端                   │
# │   Alt-g → lazygit                    │
# │   Alt-q → 退出 session               │
# └─────────────────────────────────────┘

DIR="${1:-$(pwd)}"
DIR="$(cd "$DIR" 2>/dev/null && pwd)"
BASENAME="$(basename "$DIR")"
RAND="$(head -c4 /dev/urandom | xxd -p)"
SESSION="hacker-${BASENAME//[.:]/-}-${RAND}"

tmux new-session -d -s "$SESSION" -c "$DIR" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION" 'claude' C-m
exec tmux attach -t "$SESSION"
