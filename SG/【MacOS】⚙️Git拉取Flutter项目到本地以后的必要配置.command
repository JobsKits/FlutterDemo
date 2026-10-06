#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️Git拉取Flutter项目到本地以后的必要配置.command
# - 核心用途：Git拉取Flutter项目到本地以后的必要配置。
# - 影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。
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
  printf '%s\n' '【MacOS】⚙️Git拉取Flutter项目到本地以后的必要配置.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：Git拉取Flutter项目到本地以后的必要配置。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。' | jobs_intro_style body
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

# 给输出加点颜色
green()  { print "\033[0;32m$1\033[0m"; }
yellow() { print "\033[0;33m$1\033[0m"; }

# 通用函数：检查并添加行到某个配置文件
add_line_if_not_exists() {
    local file=$1
    local line=$2
    [[ -f $file ]] || touch $file
    if ! grep -qF "$line" "$file"; then
        echo '' >> "$file"
        echo "$line" >> "$file"
        green "✅ 添加到 ${file##*/}：$line"
    else
        yellow "⚠️  ${file##*/} 中已存在：$line"
    fi
}

# macOS 不支持 readlink -f，改用以下兼容方式
current_directory=$(cd "$(dirname "$0")"; pwd)
cd "$current_directory"

# 检查 FVM 是否已安装
if ! command -v fvm &> /dev/null; then
    echo "📦 FVM 未安装，开始安装..."

    dart pub global activate fvm

    add_line_if_not_exists ~/.bash_profile 'export PATH="$PATH:$HOME/.pub-cache/bin"'
    add_line_if_not_exists ~/.bashrc 'export PATH="$PATH:$HOME/.pub-cache/bin"'
    add_line_if_not_exists ~/.zshrc 'export PATH="$PATH:$HOME/.pub-cache/bin"'

    [[ -f ~/.bash_profile ]] && source ~/.bash_profile
    [[ -f ~/.bashrc ]] && source ~/.bashrc
    [[ -f ~/.zshrc ]] && source ~/.zshrc

    green "✅ FVM 安装完成"
else
    green "✅ FVM 已安装"
fi

# 安装并使用 flutter SDK
# 下载最新的fvm稳定版
fvm install stable
#fvm install 3.7.12
# 此项目里面用的flutter的SDK版本，固定死就是3.7.12
#fvm use 3.7.12
# 使用最新的fvm稳定版
fvm use stable

# 检查环境
fvm flutter doctor -v
fvm flutter --version
fvm flutter pub get
fvm flutter precache
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
