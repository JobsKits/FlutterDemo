#!/bin/zsh

# ========== 用户须知 ==========
# 仅渲染自述：标题红色加粗，编号正文蓝色常规字重；非彩色终端输出纯文本。
jobs_intro_style() {
  local intro_color=0
  if [ -t 1 ] && [ -n "${TERM:-}" ] && [ "${TERM:-}" != dumb ] &&
     [ -z "${NO_COLOR+x}" ] && [ "${PLAIN_OUTPUT:-0}" != 1 ] &&
     [ "${IS_SOURCETREE_RUNTIME:-0}" != 1 ]; then
    intro_color=1
  fi
  /usr/bin/awk -v color="$intro_color" -v role="${1:-body}" '
    BEGIN { esc = sprintf("%c", 27) }
    {
      gsub(esc "\\[[0-9;]*m", "")
      gsub(/\\(033|e|x1[bB])\[[0-9;]*m/, "")
      if (!color || $0 ~ /^[[:space:]]*$/) { print; next }
      numbered = ($0 ~ /^[[:space:]➤ℹ🔹✔⚠]*([0-9]+[、.)）]|[0-9]+️⃣|[-•])/)
      heading = ($0 ~ /^[[:space:]]*#{1,6}[[:space:]]/ || $0 ~ /[：:][[:space:]]*$/ || $0 ~ /^[[:space:]]*[=━─-]{3}/)
      title = (!numbered && (role == "title" || heading))
      if (role == "auto" && !seen && !numbered) title = 1
      if ($0 !~ /^[[:space:]]*[=━─-]+[[:space:]]*$/) seen = 1
      printf "%s%s%s\n", esc (title ? "[1;31m" : "[0;34m"), $0, esc "[0m"
    }
  '
}
echo "
📦 本脚本用于切换当前 macOS 用户默认 Shell

🛠️ 操作流程：
1️⃣ 检查并安装 fzf
2️⃣ 列出所有可用 shell（来自 /etc/shells）
3️⃣ 让你通过 fzf 选择目标 shell
4️⃣ 自动设置为默认登录 shell（chsh -s）
" | jobs_intro_style auto
read "k?🔑 按回车开始执行..."

# ========== 自检 fzf ==========
if ! command -v fzf >/dev/null 2>&1; then
    echo "⚠️ fzf 未安装，正在用 Homebrew 安装..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "❌ Homebrew 未安装，无法继续，请手动安装 Homebrew 后重试"
        exit 1
    fi
    brew install fzf
fi

# ========== 获取所有可用 shell ==========
available_shells=($(cat /etc/shells | grep -E "^/"))

if [[ ${#available_shells[@]} -eq 0 ]]; then
    echo "❌ 无法读取可用 shell"
    exit 1
fi

# ========== fzf 选择 ==========
echo "🎯 请选择你要切换的默认 shell："
selected_shell=$(printf "%s\n" "${available_shells[@]}" | fzf --prompt="Shell ➜ ")

if [[ -z "$selected_shell" ]]; then
    echo "❌ 未选择 shell，操作取消"
    exit 1
fi

# ========== 执行切换 ==========
echo "🔧 正在切换默认 shell 为：$selected_shell"
chsh -s "$selected_shell"

# ========== 显示当前状态 ==========
echo "✅ 当前默认 shell 已更新为："
dscl . -read ~/ UserShell

echo "🎉 操作完成，建议重新打开终端以生效"
