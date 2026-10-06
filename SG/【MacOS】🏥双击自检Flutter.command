#!/bin/sh
# 脚本自述：
# - 脚本名称：【MacOS】🏥双击自检Flutter.command
# - 核心用途：双击自检Flutter。
# - 影响范围：脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。
# - 运行提示：先阅读自述并按回车确认，按 Ctrl+C 取消。
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
# 打印固定自述，确认后才进入原有脚本流程。
show_script_intro_and_wait() {
  printf '%s\n' '【MacOS】🏥双击自检Flutter.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击自检Flutter。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。' | jobs_intro_style body
  printf '%s\n' '3、运行策略：确认后执行原有流程；后续危险操作的确认保持原样。' | jobs_intro_style body
  printf '%s\n' '4、取消方式：按 Ctrl+C 终止；确认前不执行真实业务。' | jobs_intro_style body
  if [ ! -t 0 ]; then
    printf '%s\n' '当前没有可交互输入，请在终端中重新运行。' >&2
    exit 1
  fi
  printf '%s' '已了解脚本用途与影响，按回车继续；按 Ctrl+C 取消：'
  IFS= read -r jobs_intro_answer || exit 1
}
# 确认后执行原有业务，保留原来的参数、交互和退出策略。
jobs_run_original_script() {

# ANSI 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

print_title() {
    echo ""
    echo "${CYAN}🔹 $1${RESET}"
}

print_ok() {
    echo "${GREEN}✅ $1${RESET}"
}

print_warn() {
    echo "${YELLOW}⚠️ $1${RESET}"
}

print_error() {
    echo "${RED}❌ $1${RESET}"
}

print_value() {
    echo "${YELLOW}$1:${RESET} $2"
}

# 进入当前脚本所在目录
current_directory=$(cd "$(dirname "$0")"; pwd)
print_value "📂 当前脚本目录" "$current_directory"
cd "$current_directory" || exit 1

######################################
# 系统信息
######################################

print_title "系统基本信息"
print_value "系统版本" "$(sw_vers | grep ProductVersion | awk '{print $2}')"
print_value "Shell" "$SHELL"
print_value "当前用户" "$USER"

######################################
# Flutter & FVM
######################################

print_title "Flutter / FVM 信息"
if command -v fvm >/dev/null 2>&1; then
    print_ok "检测到 fvm"
    print_value "fvm 路径" "$(which fvm)"
    fvm flutter --version
else
    print_warn "未检测到 fvm，使用系统 flutter"
    flutter --version
fi

######################################
# Dart
######################################

print_title "Dart 信息"
if command -v dart >/dev/null 2>&1; then
    dart --version
else
    print_warn "未检测到 dart 命令"
fi

######################################
# Xcode
######################################

print_title "Xcode 信息"
if command -v xcodebuild >/dev/null 2>&1; then
    print_value "Xcode 版本" "$(xcodebuild -version | head -n 1)"
    print_value "Xcode 路径" "$(xcode-select -p)"
else
    print_error "未检测到 xcodebuild"
fi

######################################
# Java
######################################

print_title "Java 环境"
if command -v java >/dev/null 2>&1; then
    java -version 2>&1 | head -n 1
    print_value "JAVA_HOME" "${JAVA_HOME:-[未设置]}"
else
    print_error "未安装 Java"
fi

######################################
# Android SDK
######################################

print_title "Android SDK"
if [ -n "$ANDROID_SDK_ROOT" ]; then
    print_value "ANDROID_SDK_ROOT" "$ANDROID_SDK_ROOT"
    if [ -d "$ANDROID_SDK_ROOT" ]; then
        print_ok "SDK 目录存在"
        if [ -f "$ANDROID_SDK_ROOT/tools/bin/sdkmanager" ]; then
            "$ANDROID_SDK_ROOT/tools/bin/sdkmanager" --version
        elif [ -f "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" ]; then
            "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --version
        else
            print_warn "未找到 sdkmanager"
        fi
    else
        print_error "ANDROID_SDK_ROOT 路径不存在"
    fi
else
    print_warn "未设置 ANDROID_SDK_ROOT 环境变量"
fi

######################################
# 环境变量（格式化）
######################################

print_title "环境变量"

# 格式化 PATH：每行一个目录
echo "${YELLOW}PATH:${RESET}"
IFS=':' read -ra PATH_PARTS <<< "$PATH"
for p in "${PATH_PARTS[@]}"; do
    echo "  $p"
done

echo "${YELLOW}JAVA_HOME:${RESET}"
echo "  ${JAVA_HOME:-[未设置]}"

echo "${YELLOW}ANDROID_SDK_ROOT:${RESET}"
echo "  ${ANDROID_SDK_ROOT:-[未设置]}"

######################################
# 模拟器 & 设备
######################################

print_title "iOS 模拟器设备（Booted）"
xcrun simctl list devices | grep -E "Booted" || print_warn "暂无运行中的 iOS 模拟器"

print_title "Flutter 可用设备"
flutter devices

######################################
# flutter doctor
######################################

print_title "Flutter Doctor 输出"
if command -v fvm >/dev/null 2>&1; then
    fvm flutter doctor -v
    fvm flutter analyze
else
    flutter doctor -v
    flutter analyze
fi

echo ""
print_ok "🧩 环境检测完成"
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
