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
print_color() {
  local color="$1"
  local msg="$2"
  case "$color" in
    green)  echo "\033[32m$msg\033[0m" ;;
    red)    echo "\033[31m$msg\033[0m" ;;
    yellow) echo "\033[33m$msg\033[0m" ;;
    blue)   echo "\033[34m$msg\033[0m" ;;
    *)      echo "$msg" ;;
  esac
}

# ✅ 功能说明
print_color green "🛠️ 脚本功能：" | jobs_intro_style title
print_color green "1️⃣ 自动查找 Xcode 项目的 .app 文件" | jobs_intro_style body
print_color green "2️⃣ 复制 .app 至 Payload 并打包成 .ipa" | jobs_intro_style body
print_color green "📦 输出文件保存在桌面上" | jobs_intro_style body
echo "" | jobs_intro_style body
read "?👉 按下回车键继续执行，或按 Ctrl+C 取消..."

# ✅ 当前目录
CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
print_color blue "📂 当前目录: $CURRENT_DIR"

# ✅ 查找 .xcodeproj
PROJECT_FILES=($(find "$CURRENT_DIR" -maxdepth 1 -name "*.xcodeproj"))
if [[ ${#PROJECT_FILES[@]} -eq 0 ]]; then
  print_color red "❌ 未找到 .xcodeproj 文件，请确保在项目目录下运行"
  exit 1
elif [[ ${#PROJECT_FILES[@]} -gt 1 ]]; then
  print_color red "❌ 检测到多个 .xcodeproj 文件，请确保目录下仅有一个"
  for file in "${PROJECT_FILES[@]}"; do print_color yellow "⚠️ $file"; done
  exit 1
fi

# ✅ 项目名
PROJECT_NAME=$(basename "${PROJECT_FILES[1]}" .xcodeproj)
print_color green "✅ 发现 Xcode 项目: $PROJECT_NAME"

# ✅ 当前用户
USER_NAME=$(whoami)

# ✅ 查找最新 .app 路径
DERIVED_BASE="/Users/$USER_NAME/Library/Developer/Xcode/DerivedData"
APP_DIR=$(ls -td "$DERIVED_BASE/${PROJECT_NAME}-"*/Build/Products/Debug-iphoneos/*.app 2>/dev/null | head -n 1)

if [[ ! -d "$APP_DIR" ]]; then
  print_color red "❌ 未找到 .app 文件，请确认 Xcode 已构建成功"
  exit 1
fi

print_color green "✅ 找到 .app 文件: $APP_DIR"

# ✅ 准备 Payload 目录
DESKTOP_PATH="/Users/$USER_NAME/Desktop"
PAYLOAD_PATH="$DESKTOP_PATH/Payload"
IPA_PATH="$DESKTOP_PATH/$PROJECT_NAME.ipa"

if [[ -d "$PAYLOAD_PATH" ]]; then
  print_color yellow "⚠️ 已存在 Payload 目录，正在删除..."
  rm -rf "$PAYLOAD_PATH"
fi

mkdir -p "$PAYLOAD_PATH"
print_color green "✅ 创建 Payload 文件夹"

# ✅ 复制 .app
cp -R "$APP_DIR" "$PAYLOAD_PATH"
print_color green "✅ 复制 .app 到 Payload"

# ✅ 打包 .ipa
cd "$DESKTOP_PATH" || exit 1
zip -qr "$PROJECT_NAME.ipa" Payload
rm -rf "$PAYLOAD_PATH"
print_color green "✅ 打包完成: $IPA_PATH"
