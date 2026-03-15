#!/bin/bash
# Sili Terminal - Codex Workspace (tmux)
# ┌─────────────────────────────────────┐
# │          CODEX (全屏)                │
# │                                      │
# │   Alt-s → 文件搜索 (fzf + preview)  │
# │   Alt-t → 临时终端                   │
# │   Alt-g → lazygit                    │
# │   Alt-q → 退出 session               │
# └─────────────────────────────────────┘
SESSION="codex-dev"

# 如果旧 session 还在，先杀掉
tmux has-session -t "$SESSION" 2>/dev/null && tmux kill-session -t "$SESSION" 2>/dev/null

cleanup() { tmux kill-session -t "$SESSION" 2>/dev/null; }
trap cleanup EXIT HUP TERM

# 全屏 Codex
tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION" 'ccx' C-m
tmux attach -t "$SESSION"
