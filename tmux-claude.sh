#!/bin/bash
# Sili Terminal - Claude Dev Workspace (tmux)
# ┌─────────────────────────────────────┐
# │        CLAUDE CODE (全屏)            │
# │   Alt-s → 文件搜索    Alt-g → git   │
# │   Alt-d → 临时终端    Alt-f → yazi  │
# └─────────────────────────────────────┘
SESSION="claude-dev"

# 已有 session → 直接 attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec tmux attach -t "$SESSION"
fi

# 新建全屏 Claude Code session
tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION" 'ccd' C-m
exec tmux attach -t "$SESSION"
