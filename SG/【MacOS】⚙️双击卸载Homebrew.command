#!/bin/sh

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
echo "" | jobs_intro_style body
echo "====================================================================" | jobs_intro_style title
echo "🧨 脚本功能说明：" | jobs_intro_style title
echo "✅ 完整卸载 Homebrew（包括 Intel/M 系统安装路径）" | jobs_intro_style body
echo "✅ 删除所有 Homebrew 缓存、软件、配置路径" | jobs_intro_style body
echo "✅ 修复残留 Git HEAD 错误问题" | jobs_intro_style body
echo "====================================================================" | jobs_intro_style title
echo "" | jobs_intro_style body

read -p "⚠️ 确定要卸载 Homebrew？请输入 yes 开始执行：" confirm

if [[ "$confirm" != "yes" ]]; then
  echo "❎ 已取消卸载操作"
  exit 0
fi

echo "🧨 正在卸载 Homebrew..."

# 1. 尝试 untap & 清理
brew untap homebrew/core || true
brew cleanup || true

# 2. 官方卸载脚本（HEAD 版）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# 3. 手动删除常见路径（Intel 和 M 系）
sudo rm -rf /usr/local/Caskroom/
sudo rm -rf /usr/local/Frameworks/
sudo rm -rf /usr/local/Homebrew/
sudo rm -rf /usr/local/bin/
sudo rm -rf /usr/local/etc/
sudo rm -rf /usr/local/include/
sudo rm -rf /usr/local/lib/
sudo rm -rf /usr/local/opt/
sudo rm -rf /usr/local/sbin/
sudo rm -rf /usr/local/share/
sudo rm -rf /usr/local/var/
sudo rm -rf /opt/homebrew/

# 4. 修复 fatal: Could not resolve HEAD 错误
brew_repo=$(brew --repo homebrew/core 2>/dev/null)
if [[ -n "$brew_repo" ]]; then
  sudo rm -rf "$brew_repo"
fi

echo ""
echo "✅ Homebrew 已彻底卸载完成"
