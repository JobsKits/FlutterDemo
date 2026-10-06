#! /bin/sh
# 脚本自述：
# - 脚本名称：【MacOS】openSysConfigFile.command
# - 核心用途：打开用户 Shell 配置文件。
# - 影响范围：本机开发工具或用户环境配置；本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】openSysConfigFile.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：打开用户 Shell 配置文件。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机开发工具或用户环境配置；本机应用、模拟器或终端窗口。' | jobs_intro_style body
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
open ~/.bash_profile
open ~/.bashrc
open ~/.zshrc

# ~/.bash_profile、
# ~/.bashrc
# ~/.zshrc 是不同的 shell 配置文件，每个文件的优先级和作用取决于你使用的 shell 类型以及你在启动 shell 时的方式
# 以下是对它们的优先级和作用的详细说明：

# Bash Shell
# ~/.bash_profile
# 这是一个用户级的启动文件，当以登录方式启动 Bash shell 时（例如通过终端登录或者 SSH 登录时），Bash 会读取并执行 ~/.bash_profile 中的内容。
# 如果 ~/.bash_profile 不存在，Bash 会尝试读取 ~/.bash_login 或者 ~/.profile。

# ~/.bashrc
# 这是一个用户级的非登录 shell 启动文件，当启动一个非登录的 Bash shell 时（例如打开一个终端窗口或者执行一个新的 shell 命令时），Bash 会读取并执行 ~/.bashrc 中的内容。
# 通常在 ~/.bash_profile 中会有一行代码来手动加载 ~/.bashrc，以便确保登录 shell 和非登录 shell 都会执行 ~/.bashrc 中的配置。

# bash
# 复制下列代码
# if [ -f ~/.bashrc ]; then
#    source ~/.bashrc
# fi

# Zsh Shell
# ~/.zshrc
# 这是 Zsh 的配置文件，不论是登录 shell 还是非登录 shell，Zsh 启动时都会读取并执行 ~/.zshrc 中的内容。
# 对于 Zsh 而言，~/.zshrc 是主要的配置文件。

# 优先级总结
# 对于 Bash：
# 登录 shell：先执行 ~/.bash_profile，如果在 ~/.bash_profile 中有 source ~/.bashrc，则会接着执行 ~/.bashrc。
# 非登录 shell：只执行 ~/.bashrc。

# 对于 Zsh：
# 无论是登录 shell 还是非登录 shell，都只执行 ~/.zshrc。
# 根据你使用的 shell 类型和启动方式，这些文件的优先级和作用会有所不同。
# 对于大多数桌面用户来说，通常会配置 ~/.bashrc 或者 ~/.zshrc 来设置常用的环境变量和别名，而 ~/.bash_profile 则用来进行一些需要在登录时执行的初始化操作。
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
