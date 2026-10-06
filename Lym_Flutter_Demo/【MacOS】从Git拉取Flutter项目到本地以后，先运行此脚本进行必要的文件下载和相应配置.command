#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】从Git拉取Flutter项目到本地以后，先运行此脚本进行必要的文件下载和相应配置.command
# - 核心用途：从Git拉取Flutter项目到本地以后，先运行此脚本进行必要的文件下载和相应配置。
# - 影响范围：本机开发工具或用户环境配置；脚本指定文件或缓存的删除 / 清理；脚本所在工程或指定目标中的文件。
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
  printf '%s\n' '【MacOS】从Git拉取Flutter项目到本地以后，先运行此脚本进行必要的文件下载和相应配置.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：从Git拉取Flutter项目到本地以后，先运行此脚本进行必要的文件下载和相应配置。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机开发工具或用户环境配置；脚本指定文件或缓存的删除 / 清理；脚本所在工程或指定目标中的文件。' | jobs_intro_style body
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

# 检查并添加行到./bash_profile
add_line_if_not_exists_bash_profile() {
    local line=$1
    if ! grep -qF "$line" ~/.bash_profile; then
        echo '' >> ~/.bash_profile # 写入之前，先进行提行
        echo "$line" >> ~/.bash_profile
        print "添加到.bash_profile：" "$line"
    else
        print ".bash_profile中已存在" "$line"
    fi
}
# 检查并添加行到./bashrc
add_line_if_not_exists_bashrc() {
    local line=$1
    if ! grep -qF "$line" ~/.bashrc; then
        echo '' >> ~/.bashrc # 写入之前，先进行提行
        echo "$line" >> ~/.bashrc
        print "添加到.bashrc：" "$line"
    else
        print ".bashrc中已存在" "$line"
    fi
}
# 检查并添加行到./zshrc
add_line_if_not_exists_zshrc() {
    local line=$1
    if ! grep -qF "$line" ~/.zshrc; then
        echo '' >> ~/.zshrc # 写入之前，先进行提行
        echo "$line" >> ~/.zshrc
        print "添加到.zshrc：" "$line"
    else
        print ".zshrc中已存在" "$line"
    fi
}
# 获取当前脚本文件的目录
current_directory=$(dirname "$(readlink -f "$0")")
cd $current_directory
# 检查是否已安装 FVM
if ! command -v fvm &> /dev/null; then
    echo "FVM is not installed. Installing now..."
    # 安装 FVM
    dart pub global activate fvm
    # 将 FVM 添加到 PATH
    add_line_if_not_exists_bash_profile 'export PATH="$PATH":"$HOME/.pub-cache/bin"'
    add_line_if_not_exists_bashrc 'export PATH="$PATH":"$HOME/.pub-cache/bin"'
    add_line_if_not_exists_zshrc 'export PATH="$PATH":"$HOME/.pub-cache/bin"'
    
    source ~/.bashrc
    source ~/.zshrc
    source ~/.bash_profile

    echo "FVM installed successfully."
else
    echo "FVM is already installed."
fi
# 下载最新的fvm稳定版
fvm install stable
fvm install 3.19.6
# 此项目里面用的flutter的SDK版本，固定死就是3.19.6
fvm use 3.19.6
# 使用最新的fvm稳定版
#fvm use stable

# 环境自检
flutter doctor -v
# 列出可用版本
fvm releases
# 验证 Flutter 和 Dart 版本
fvm flutter --version
# 缓存清理
fvm flutter clean
# 更新依赖
fvm flutter pub get
# 预下载必要的工具
fvm flutter precache --all-platforms
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
