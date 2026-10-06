#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️运行授权.command
# - 核心用途：运行授权。
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
  printf '%s\n' '【MacOS】⚙️运行授权.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：运行授权。' | jobs_intro_style body
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

# 打印函数
_JobsPrint() { echo -e "$1$2\033[0m"; }
_JobsPrint_Green() { _JobsPrint "\033[1;32m" "$1"; }
_JobsPrint_Red() { _JobsPrint "\033[1;31m" "$1"; }

# 当前脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo ""
echo "======================================================================"
_JobsPrint_Green "📂 请将需要授权执行权限的文件或目录拖入终端"
echo "👉 支持多个路径，路径可含空格，拖完按回车确认"
echo "👉 如果直接按回车：授权当前目录下所有 .command 文件"
echo "👉 如果输入 yes + 回车：递归授权当前目录下所有子目录中的 .command 文件"
echo "======================================================================"
echo ""

read -r "?📥 拖入路径或输入命令后回车：" input_paths

# === 1. 输入为空：只处理当前目录 ===
if [[ -z "$input_paths" ]]; then
  _JobsPrint_Green "📁 未输入路径，开始授权当前目录下的 .command 文件..."

  files=("$SCRIPT_DIR"/*.command(N))
  if [[ ${#files[@]} -eq 0 ]]; then
    _JobsPrint_Red "❌ 当前目录下没有 .command 文件，退出。"
    exit 1
  fi

  for file in "${files[@]}"; do
    chmod +x "$file" && \
    echo "✅ 授权成功：$file" || \
    _JobsPrint_Red "⚠️ 授权失败：$file"
  done

  echo ""
  _JobsPrint_Green "✅ 当前目录授权完毕！"
  read "?🔚 按回车退出..."
  exit 0
fi

# === 2. 输入为 yes：递归授权 ===
if [[ "$input_paths" == "yes" ]]; then
  echo ""
  _JobsPrint_Green "📂 正在递归查找并授权所有 .command 文件..."

  recursive_files=($(find "$SCRIPT_DIR" -type f -name "*.command"))
  if [[ ${#recursive_files[@]} -eq 0 ]]; then
    _JobsPrint_Red "❌ 没有找到任何 .command 文件，退出。"
    exit 1
  fi

  for file in "${recursive_files[@]}"; do
    chmod +x "$file" && \
    echo "✅ 授权成功：$file" || \
    _JobsPrint_Red "⚠️ 授权失败：$file"
  done

  echo ""
  _JobsPrint_Green "✅ 所有子目录授权完成！"
  read "?🔚 按回车退出..."
  exit 0
fi

# === 3. 拖入路径 ===
echo ""
_JobsPrint_Green "🔧 正在处理拖入的路径："

for raw_path in ${(z)input_paths}; do
  path=${raw_path:a}
  if [[ -e "$path" ]]; then
    chmod +x "$path" && \
    echo "✅ 添加执行权限成功：$path" || \
    _JobsPrint_Red "⚠️ 权限修改失败：$path"
  else
    _JobsPrint_Red "❌ 无效路径：$path"
  fi
done

echo ""
_JobsPrint_Green "🎉 所有路径处理完成！可双击或终端运行这些文件。"
read "?🔚 按回车退出..."
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
