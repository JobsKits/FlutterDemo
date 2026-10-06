#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️import =>package.command
# - 核心用途：import =>package。
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
  printf '%s\n' '【MacOS】⚙️import =>package.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：import =>package。' | jobs_intro_style body
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

# 设置颜色函数
function echo_red()   { echo "\033[31m$1\033[0m" }
function echo_green() { echo "\033[32m$1\033[0m" }
function echo_yellow(){ echo "\033[33m$1\033[0m" }

clear
echo "📦 本脚本用于自动将 Flutter 项目中所有相对路径 import 改为 package: 形式"
echo "🌟 示例：import '../../../../TestBase/JobsMaterialRunner.dart'"
echo "     👉 import 'package:xxx/TestBase/JobsMaterialRunner.dart';"
echo ""

# 🌀 无限循环，直到找到有效路径
while true; do
  echo_yellow "⏳ 请将 Flutter 项目目录拖入终端后回车："
  read -r PROJECT_PATH

  # 去掉路径中的引号和末尾空格
  PROJECT_PATH="${PROJECT_PATH%\"}"
  PROJECT_PATH="${PROJECT_PATH#\"}"
  PROJECT_PATH="${PROJECT_PATH:A}" # zsh 的绝对路径解析（无需 realpath）

  if [[ -f "$PROJECT_PATH/pubspec.yaml" ]]; then
    break
  else
    echo_red "❌ 错误：路径无效，未找到 pubspec.yaml，请重新拖入 Flutter 项目根目录"
    echo ""
  fi
done

# 自动获取包名
PACKAGE_NAME=$(grep "^name:" "$PROJECT_PATH/pubspec.yaml" | awk '{print $2}')

if [[ -z "$PACKAGE_NAME" ]]; then
  echo_red "❌ 无法从 pubspec.yaml 中提取项目名"
  exit 1
fi

echo_green "✅ 项目路径：$PROJECT_PATH"
echo_green "✅ 项目包名：$PACKAGE_NAME"
echo ""
echo_yellow "🚀 按下回车开始替换所有相对 import 为 package:$PACKAGE_NAME/... 格式"
read

echo "📁 开始处理 Dart 文件..."

# 查找并处理 dart 文件
find "$PROJECT_PATH" -name "*.dart" | while read -r dart_file; do
  sed -i '' -E "s#import\s+['\"](\.\.\/)+lib\/(.*)['\"]#import 'package:$PACKAGE_NAME/\2'#g" "$dart_file"
  sed -i '' -E "s#import\s+['\"](\.\.\/)+([^'\"]*)['\"]#import 'package:$PACKAGE_NAME\/\2'#g" "$dart_file"
done

echo_green "🎉 所有 import 路径已成功替换为 package:$PACKAGE_NAME/..."
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
