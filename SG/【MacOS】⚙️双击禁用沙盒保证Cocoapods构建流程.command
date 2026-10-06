#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️双击禁用沙盒保证Cocoapods构建流程.command
# - 核心用途：双击禁用沙盒保证Cocoapods构建流程。
# - 影响范围：脚本所在工程或指定目标中的文件。
# - 运行提示：先阅读自述并按回车确认，按 Ctrl+C 取消。
JOBS_COMMAND_ENTRY_ARG0="$0"
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
  printf '%s\n' '【MacOS】⚙️双击禁用沙盒保证Cocoapods构建流程.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击禁用沙盒保证Cocoapods构建流程。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：脚本所在工程或指定目标中的文件。' | jobs_intro_style body
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
  0="$JOBS_COMMAND_ENTRY_ARG0"

print_green()  { echo "\033[0;32m$1\033[0m"; }
print_red()    { echo "\033[0;31m$1\033[0m"; }
print_yellow() { echo "\033[0;33m$1\033[0m"; }

print_green "🛠️ 脚本功能："
echo "1️⃣ 自动识别 Flutter 或原生 iOS 工程"
echo "2️⃣ 自动定位 Xcode 工程（.xcodeproj）文件"
echo "3️⃣ 修改 ENABLE_USER_SCRIPT_SANDBOXING = NO，防止 CocoaPods 构建失败"
echo ""

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
XCODEPROJ=""

# 尝试自动识别 Flutter / iOS 工程路径
if [[ -d "$SCRIPT_DIR/ios" && -d "$SCRIPT_DIR/lib" ]]; then
  print_green "📦 检测到 Flutter 工程，进入 ios 子目录查找 Xcode 工程..."
  PROJECT_DIR="$SCRIPT_DIR/ios"
else
  print_green "📱 尝试在当前目录查找原生 iOS 工程..."
  PROJECT_DIR="$SCRIPT_DIR"
fi

# 自动寻找 .xcodeproj
XCODEPROJ=$(find "$PROJECT_DIR" -maxdepth 1 -name "*.xcodeproj" | head -n 1)

# 如果找不到，就让用户手动拖入
if [[ -z "$XCODEPROJ" ]]; then
  print_red "❌ 未自动找到 .xcodeproj 文件"
  echo ""
  read "?👉 请手动拖入你的 .xcodeproj 工程文件，然后按回车：" XCODEPROJ
  XCODEPROJ=${XCODEPROJ%\"}
  XCODEPROJ=${XCODEPROJ#\"}
fi

# 校验路径有效性
PBXPROJ_PATH="$XCODEPROJ/project.pbxproj"
if [[ ! -f "$PBXPROJ_PATH" ]]; then
  print_red "❌ 找不到 project.pbxproj 文件，请确认路径正确"
  exit 1
fi

print_yellow "📂 目标工程：$XCODEPROJ"
print_green  "🔍 正在查找 ENABLE_USER_SCRIPT_SANDBOXING 设置..."

# ✅ 若已存在，则替换为 NO
grep -q "ENABLE_USER_SCRIPT_SANDBOXING" "$PBXPROJ_PATH"
if [[ $? -eq 0 ]]; then
  print_green "✅ 已找到 ENABLE_USER_SCRIPT_SANDBOXING，正在替换为 NO..."
  sed -i '' 's/ENABLE_USER_SCRIPT_SANDBOXING = YES;/ENABLE_USER_SCRIPT_SANDBOXING = NO;/g' "$PBXPROJ_PATH"
  sed -i '' 's/ENABLE_USER_SCRIPT_SANDBOXING = YES/ENABLE_USER_SCRIPT_SANDBOXING = NO/g' "$PBXPROJ_PATH"
else
  print_green "➕ 未显式设置，添加 ENABLE_USER_SCRIPT_SANDBOXING = NO 到所有 buildSettings..."
  sed -i '' '/buildSettings = {/a\
\        ENABLE_USER_SCRIPT_SANDBOXING = NO;
' "$PBXPROJ_PATH"
fi

print_green "🎉 修改完成！已将 ENABLE_USER_SCRIPT_SANDBOXING 设置为 NO"
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
