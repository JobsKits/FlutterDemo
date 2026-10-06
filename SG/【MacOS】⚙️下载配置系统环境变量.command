#!/bin/zsh

# ✅ 彩色输出函数
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
print_green() { echo "\033[1;32m$1\033[0m"; }
print_yellow() { echo "\033[1;33m$1\033[0m"; }
print_red() { echo "\033[1;31m$1\033[0m"; }

# ✅ 功能说明
SCRIPT_NAME=$(basename "$0" .command)
print_green "🛠️ 脚本功能：" | jobs_intro_style title
print_green "1️⃣ 自动打开 GitHub 项目：https://github.com/295060456/MacEnvVarConfig" | jobs_intro_style body
print_green "2️⃣ 克隆仓库到本脚本同级目录中，文件夹名称与脚本文件同名：$SCRIPT_NAME" | jobs_intro_style body
echo "" | jobs_intro_style body
read "?👉 按下回车键开始执行，或按 Ctrl+C 取消..."

# ✅ 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ✅ 判断目标目录是否已存在
TARGET_DIR="$SCRIPT_DIR/$SCRIPT_NAME"
if [[ -d "$TARGET_DIR" ]]; then
    print_yellow "⚠️ 目录已存在：$TARGET_DIR"
    print_yellow "❓ 是否要删除已有目录并重新 clone？(y/n)"
    read -r answer
    if [[ "$answer" == "y" ]]; then
        rm -rf "$TARGET_DIR"
        print_green "✅ 已删除旧目录"
    else
        print_red "❌ 操作已取消。"
        exit 1
    fi
fi

# ✅ 克隆仓库
print_green "📥 开始克隆..."
git clone https://github.com/295060456/MacEnvVarConfig.git "$TARGET_DIR"

# ✅ 克隆结果判断
if [[ $? -eq 0 ]]; then
    print_green "🎉 克隆成功！路径：$TARGET_DIR"
else
    print_red "❌ 克隆失败，请检查网络连接或 GitHub 可访问性。"
fi
