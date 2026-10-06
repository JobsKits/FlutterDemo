#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】🔍查询Flutter依赖版本.command
# - 核心用途：查询Flutter依赖版本。
# - 影响范围：本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】🔍查询Flutter依赖版本.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：查询Flutter依赖版本。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机应用、模拟器或终端窗口。' | jobs_intro_style body
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

#######################################################################
# 🛠️ 脚本功能说明：
# 1️⃣ 自动判断脚本所在目录是否为 Flutter 项目根目录（含 pubspec.lock 和 pubspec.yaml）
# 2️⃣ 若不是，则提示用户拖入 Flutter 项目根目录路径
# 3️⃣ 支持同时查询多个依赖包，包名以空格分隔（支持多空格）
# 4️⃣ 自动读取 pubspec.lock 获取实际依赖版本号
# 5️⃣ 用户直接按回车则退出
# 6️⃣ 若全部依赖未找到则要求重新输入
# 7️⃣ 查询成功后延迟 2 秒并强制关闭当前终端窗口（不影响其他终端）
#######################################################################

# 清屏
clear

echo "📦 当前脚本用于查询 Flutter 项目中某个或多个依赖包的实际使用版本（来源：pubspec.lock）"
echo "📌 输入方式：支持多个依赖包名，用空格分隔。例如：camera dio firebase_core"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 判断是否为 Flutter 项目目录
if [[ -f "$SCRIPT_DIR/pubspec.lock" && -f "$SCRIPT_DIR/pubspec.yaml" ]]; then
  PROJECT_DIR="$SCRIPT_DIR"
  echo "✅ 已自动识别 Flutter 项目目录：$PROJECT_DIR"
else
  echo "⚠️ 未检测到 Flutter 项目，请将包含 pubspec.lock 的 Flutter 项目目录拖入终端后回车："
  read -r user_input
  user_input=${user_input//\"/}

  if [[ ! -d "$user_input" ]]; then
    echo "❌ 错误：路径无效"
    exit 1
  fi

  if [[ ! -f "$user_input/pubspec.lock" || ! -f "$user_input/pubspec.yaml" ]]; then
    echo "❌ 错误：该目录不是有效的 Flutter 项目根目录（缺少 pubspec.lock 或 pubspec.yaml）"
    exit 1
  fi

  PROJECT_DIR="$user_input"
fi

cd "$PROJECT_DIR" || exit 1
echo "📂 项目目录切换为：$PROJECT_DIR"
echo ""

# 主循环
while true; do
  read "?📦 请输入要查询的依赖包名（多个包用空格分隔，直接回车退出）： " package_line

  # 用户直接按回车，退出
  if [[ -z "$package_line" ]]; then
    echo "👋 已退出"
    sleep 1
    osascript <<EOF
tell application "Terminal"
  if front window exists then close front window
end tell
EOF
    exit 0
  fi

  package_list=(${(z)package_line}) # 转换为空格分隔的数组

  echo ""
  echo "🔍 查询结果："
  echo "──────────────────────────────────────────────"

  all_not_found=true
  for pkg in $package_list; do
    version=$(awk "/$pkg:/{found=1} found && /version: /{print \$2; exit}" pubspec.lock)
    if [[ -n "$version" ]]; then
      printf "✅ %-25s 版本：%s\n" "$pkg" "$version"
      all_not_found=false
    else
      printf "❌ %-25s 未找到或未集成\n" "$pkg"
    fi
  done

  echo "──────────────────────────────────────────────"

  if [[ "$all_not_found" == true ]]; then
    echo ""
    echo "⚠️ 没有任何有效的依赖，请重新输入（或直接回车退出）。"
    continue
  fi

  echo ""
  echo "✅ 查询完成，窗口将自动关闭..."
  sleep 2
  osascript <<EOF
tell application "Terminal"
  if front window exists then close front window
end tell
EOF
  exit 0
done
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
