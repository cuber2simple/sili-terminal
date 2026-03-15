#!/bin/bash
# Sili Terminal - Yazi Slide-in Overlay
# 用 tmux popup 在主功能区域上方弹出 yazi 文件浏览器
# 快捷键: Alt-f
# 再按 Alt-f 或 q 退出 popup，恢复原始布局

SESSION="${1:-claude-dev}"

# popup 尺寸: 宽 80%, 高 90%
tmux display-popup \
    -E \
    -w "80%" \
    -h "90%" \
    -d "#{pane_current_path}" \
    -T " 📂 Yazi File Browser " \
    -b "rounded" \
    "yazi"
