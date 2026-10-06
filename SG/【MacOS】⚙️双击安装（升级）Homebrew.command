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
echo "🧰 脚本功能说明：" | jobs_intro_style title
echo "✅ 如果未安装 Homebrew，则自动安装" | jobs_intro_style body
echo "✅ 如果已安装 Homebrew，则自动执行更新 upgrade" | jobs_intro_style body
echo "✅ 环境变量统一写入 ~/.bash_profile，不写入 zprofile" | jobs_intro_style body
echo "====================================================================" | jobs_intro_style title
echo "" | jobs_intro_style body

read -p "👉 请按下回车键继续执行，或按 Ctrl+C 取消..."

# 检查是否安装 Homebrew
if ! command -v brew &>/dev/null; then
    echo "🍺 未检测到 Homebrew，开始安装..."
    open https://brew.sh/

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 写入环境变量到 ~/.bash_profile（不写 zprofile）
    BREW_ENV=$(eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)")
    if ! grep -q "brew shellenv" "$HOME/.bash_profile"; then
        echo "$BREW_ENV" >> "$HOME/.bash_profile"
        echo "✅ 已写入环境变量到 ~/.bash_profile"
    fi

    eval "$BREW_ENV"
    source "$HOME/.bash_profile"

    open "$HOME/.bash_profile"
    echo "✅ Homebrew 安装成功"
else
    echo "✅ 检测到 Homebrew 已安装"
    echo "🔄 开始执行更新..."
    brew update
    brew upgrade
    brew doctor
    brew -v
    echo "✅ Homebrew 已更新完成"
fi

###############################################################################
# 📦 安装常用开发工具
###############################################################################

echo "📦 开始安装常用软件包和工具..."

brew install --cask cakebrew
brew install --cask launchrocket
brew install docker
brew install carthage
brew install php
brew install mysql
brew install tomcat
brew install maven
brew install java
brew install node
brew install nvm
brew install python3
brew install openssl
brew install wget
brew install heroku
brew install git
brew install autojump
brew install mongodb
brew install nginx
brew install iterm2
brew install xz
brew install pkg-config
brew install readline
brew install coreutils
brew install lrzsz
brew install clang-format
brew install git-flow
brew install curl
brew install ffmpeg
brew install watchman
brew install gnupg
brew install oclint
brew install yarn
brew install ruby

echo "✅ 所有软件安装完成"
