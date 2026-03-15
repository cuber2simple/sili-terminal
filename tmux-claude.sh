#!/bin/bash
# Sili Terminal - Claude Dev Workspace (tmux)
# ┌─────────────────────────────────────┐
# │        CLAUDE CODE (全屏)            │
# │   Alt-s → 文件搜索    Alt-g → git   │
# │   Alt-d → 临时终端    Alt-f → yazi  │
# └─────────────────────────────────────┘

# 每次启动新 session，支持同目录多实例并发开发
DIR="${1:-$(pwd)}"
DIR="$(cd "$DIR" 2>/dev/null && pwd)"
BASENAME="$(basename "$DIR")"
RAND="$(head -c4 /dev/urandom | xxd -p)"
SESSION="claude-${BASENAME//[.:]/-}-${RAND}"

# 新建全屏 Claude Code session
tmux new-session -d -s "$SESSION" -c "$DIR" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION" 'claude' C-m
exec tmux attach -t "$SESSION"
