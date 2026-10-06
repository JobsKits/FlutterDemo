#!/bin/zsh

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
set -euo pipefail

# ✅ 彩色输出
print_green()  { echo -e "\033[1;32m$1\033[0m"; }
print_red()    { echo -e "\033[1;31m$1\033[0m"; }
print_yellow() { echo -e "\033[1;33m$1\033[0m"; }

print_green "🛠️ 脚本功能：" | jobs_intro_style title
print_green "1️⃣ 自动安装 Homebrew（写入 ~/.bash_profile）" | jobs_intro_style body
print_green "2️⃣ 自动安装 fzf（如未安装）" | jobs_intro_style body
print_green "3️⃣ 提供 Flutter 清理维护交互式功能菜单" | jobs_intro_style body
echo "" | jobs_intro_style body
read "?👉 按下回车键继续执行，或按 Ctrl+C 取消..."

# ✅ 自动安装 Homebrew（支持 Intel 与 Apple Silicon，写入 ~/.bash_profile）
if ! command -v brew >/dev/null 2>&1; then
  print_yellow "📦 正在安装 Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # 写入环境变量到 ~/.bash_profile（无论架构）
  BREW_ENV=$(eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)")
  echo "$BREW_ENV" >> "$HOME/.bash_profile"
  eval "$BREW_ENV"

  print_green "✅ Homebrew 安装成功，并写入 ~/.bash_profile"
  source "$HOME/.bash_profile"
fi

# ✅ 安装 fzf
if ! command -v fzf >/dev/null 2>&1; then
  print_yellow "📦 正在安装 fzf..."
  brew install fzf
  print_green "✅ fzf 安装完成"
fi

# ✅ fzf 菜单
CHOICE=$(cat <<EOF | fzf --prompt="📌 请选择要执行的功能：" --height=15 --border --reverse
仅刷新 Flutter 依赖包
清除 Flutter 缓存 (bin/cache)
清理项目 + 刷新依赖
清除 Android 缓存 (.gradle)
清除 Flutter Pub 缓存 (.pub-cache)
清除 iOS 缓存 (Pods 等)
卸载 Flutter 环境
EOF
)

[[ -z "$CHOICE" ]] && print_red "❌ 已取消操作" && exit 0

print_green "▶️ 正在执行：$CHOICE"

case "$CHOICE" in
"仅刷新 Flutter 依赖包")
  fvm flutter pub get
  ;;

"清除 Flutter 缓存 (bin/cache)")
  path="$HOME/Documents/GitHub/Flutter.SDK/flutter/bin/cache"
  open "$path"
  read "?按回车清除缓存，其他键跳过："
  [[ -z "$REPLY" ]] && rm -rf "$path"/* && print_green "✅ Flutter 缓存清除完成" || echo "🚫 跳过"
  ;;

"清理项目 + 刷新依赖")
  fvm flutter clean
  rm -rf .idea .dart_tool
  fvm flutter precache --ios
  fvm flutter pub get
  fvm dart fix --apply
  fvm flutter upgrade
  fvm flutter pub upgrade --major-versions
  print_green "✅ 项目清理和依赖更新完成"
  ;;

"清除 Android 缓存 (.gradle)")
  rm -rf "$HOME/.gradle"
  print_green "✅ Android 缓存清除完成"
  ;;

"清除 Flutter Pub 缓存 (.pub-cache)")
  open "$HOME/.pub-cache"
  read "?按回车清除 .pub-cache，其他键跳过："
  [[ -z "$REPLY" ]] && rm -rf "$HOME/.pub-cache"/* && print_green "✅ Pub 缓存清除完成" || echo "🚫 跳过"
  ;;

"清除 iOS 缓存 (Pods 等)")
  if [[ -f "pubspec.yaml" && -d ios ]]; then
    rm -rf ios/Pods ios/Podfile.lock ios/.symlinks ios/Flutter
    rm -rf .dart_tool build pubspec.lock
  elif [[ -f "Podfile" ]]; then
    rm -rf Pods Podfile.lock
  else
    print_red "未识别到 Flutter 或 iOS 工程结构"
    exit 1
  fi
  rm -rf ~/Library/Developer/Xcode/DerivedData/*
  print_green "✅ iOS 缓存清除完成"
  ;;

"卸载 Flutter 环境")
  read "?⚠️ 输入 yes 确认卸载 Flutter 环境："
  if [[ "$REPLY" == "yes" ]]; then
    sudo rm -f /usr/local/bin/flutter /usr/local/bin/dart /opt/homebrew/bin/flutter /opt/homebrew/bin/dart
    brew uninstall --force flutter dart 2>/dev/null || true
    rm -rf ~/.pub-cache ~/.dart ~/.flutter ~/.fvm ~/.dartserver ~/flutter ~/development/flutter
    rm -rf .dart_tool .fvm .packages pubspec.lock build/
    dart pub global deactivate fvm 2>/dev/null || true
    sed -i '' '/\.pub-cache\/bin/d' "$HOME/.bash_profile"
    sed -i '' '/flutter() { fvm flutter/d' "$HOME/.bash_profile"
    source "$HOME/.bash_profile" 2>/dev/null || true
    print_green "✅ Flutter 环境已彻底卸载"
  else
    print_red "❌ 已取消卸载操作"
  fi
  ;;
esac

echo ""
print_green "🎉 所有操作执行完毕！"
