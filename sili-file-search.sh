#!/bin/bash
# Sili Terminal - File Search (fzf + bat preview → vim 编辑)
# Alt-s 弹出，模糊搜索当前项目文件
# Enter → vim 打开编辑，退出后回到搜索
# Ctrl-y → 复制路径到剪贴板
# Ctrl-o → 复制预览内容到剪贴板
# Esc → 关闭

cd "${1:-.}" || exit

while true; do
  FILE=$(fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv --exclude __pycache__ |
    fzf \
      --height=100% \
      --layout=reverse \
      --border=rounded \
      --prompt=" Search: " \
      --header="Enter=vim │ Ctrl-y=copy path │ Ctrl-o=copy content │ Esc=close" \
      --preview="bat --color=always --style=numbers,header --line-range=:300 {}" \
      --preview-window="right:60%:wrap" \
      --bind="ctrl-y:execute-silent(echo -n {} | pbcopy)+abort" \
      --bind="ctrl-o:execute-silent(cat {} | pbcopy)+abort")

  [ -z "$FILE" ] && break
  vim -c 'set mouse=' "$FILE"
done
