#!/bin/bash
# 脚本自述：
# - 脚本名称：【MacOS】清除Flutter.Cache文件夹.command
# - 核心用途：清除Flutter.Cache文件夹。
# - 影响范围：脚本指定文件或缓存的删除 / 清理；脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】清除Flutter.Cache文件夹.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：清除Flutter.Cache文件夹。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：脚本指定文件或缓存的删除 / 清理；脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。' | jobs_intro_style body
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

# 格式化打印输出
print() {
    local mainMessage=$1
    local subMessage=$2
    echo -e "\033[1m${mainMessage}\033[0m"
    echo -e "\033[31m${subMessage}\033[0m"
}

# 获取当前用户的主目录
USER_HOME=$HOME

# 获取cache文件夹路径并打开
Flutter_Cache_Path=$USER_HOME/Documents/GitHub/Flutter.SDK/flutter/bin/cache
print "Flutter.cache路径为：" "$Flutter_Cache_Path"
open $Flutter_Cache_Path

# 提示用户按回车键继续删除
read -r -p "按回车键继续删除，输入其他内容退出..."

# 检查用户输入是否为空（回车键）
if [[ ! $REPLY ]]; then
    # 删除 cache 文件夹下的所有文件
    rm -rf $Flutter_Cache_Path/*
    echo "删除成功！"
else
    echo "未删除任何文件。"
fi
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
