#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️双击安装CocoaPods.command
# - 核心用途：双击安装CocoaPods。
# - 影响范围：Git 工作区、子模块或仓库状态；本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。
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
  printf '%s\n' '【MacOS】⚙️双击安装CocoaPods.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击安装CocoaPods。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：Git 工作区、子模块或仓库状态；本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。' | jobs_intro_style body
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

### ✅ 全局变量定义
START_TIME=$(date +%s)
LOG_FILE="$HOME/Desktop/Jobs_Installer_$(date +%Y%m%d_%H%M%S).log"
typeset -g HOMEBREW_PATH_M_SERIES="/opt/homebrew"
typeset -g HOMEBREW_PATH_X86="/usr/local"
typeset -g CONFIG_FILES=(".zshrc" ".bash_profile")
typeset -g FZF_PROMPT='👉 请选择操作：'

### ✅ 通用输出方法（带日志记录）
log()  { echo -e "$1" | tee -a "$LOG_FILE" }
info() { log "\033[1;32m$1\033[0m" }
warn() { log "\033[1;33m$1\033[0m" }
err()  { log "\033[1;31m$1\033[0m" }

### ✅ 打印 LOGO
print_logo() {
  info "======================="
  info "     Jobs Installer    "
  info "======================="
}

### ✅ 执行耗时
print_duration() {
  END_TIME=$(date +%s)
  DURATION=$((END_TIME - START_TIME))
  info "⚙️ 脚本总耗时：${DURATION}s"
}

### ✅ 判断芯片架构（ARM64 / x86_64）
get_cpu_arch() {
  [[ $(uname -m) == "arm64" ]] && echo "arm64" || echo "x86_64"
}

### ✅ fzf选择菜单
fzf_select() {
  printf "%s\n" "$@" | fzf --prompt="$FZF_PROMPT" --height=15 --reverse
}

### ✅ 备份配置文件
backup_configs() {
  for file in "$HOME/.zshrc" "$HOME/.bash_profile"; do
    [ -f "$file" ] && cp "$file" "$file.bak"
  done
  info "📦 已备份配置文件到 .bak"
}

### ✅ 安装 Homebrew（自动架构判断）
install_homebrew() {
  arch=$(get_cpu_arch)
  if ! command -v brew &>/dev/null; then
    info "🍺 安装 Homebrew ($arch)..."
    if [[ "$arch" == "arm64" ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    info "✅ Homebrew 安装完成"
  else
    info "✅ Homebrew 已安装"
  fi
}

### ✅ 安装 fzf（交互选择）
install_fzf() {
  if ! command -v fzf &>/dev/null; then
    method=$(fzf_select "通过 Homebrew 安装" "通过 Git 安装")
    case $method in
      *Homebrew*) brew install fzf;;
      *Git*)
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all
        ;;
      *) err "❌ 取消安装 fzf";;
    esac
  else
    info "✅ fzf 已安装"
  fi
}

### ✅ 安装 Ruby（fzf交互 + 多选项）
install_ruby() {
  method=$(fzf_select "通过 Homebrew 安装 Ruby" "通过 Rbenv 安装 Ruby" "通过 RVM 安装 Ruby")
  case $method in
    *Homebrew*)
      brew install ruby
      echo 'export PATH="$(brew --prefix ruby)/bin:$PATH"' >> ~/.zshrc
      ;;
    *Rbenv*)
      brew install rbenv ruby-build
      echo 'eval "$(rbenv init -)"' >> ~/.zshrc
      eval "$(rbenv init -)"
      rbenv install 3.3.0
      rbenv global 3.3.0
      ;;
    *RVM*)
      \curl -sSL https://get.rvm.io | bash -s stable --ruby
      source ~/.rvm/scripts/rvm
      ;;
    *) err "❌ 未选择安装 Ruby";;
  esac
}

### ✅ 设置 Ruby 镜像源（根据 IP 自动判断）
set_gem_source() {
  COUNTRY=$(curl -s https://ipinfo.io | jq -r '.country')
  if [[ "$COUNTRY" == "CN" ]]; then
    gem sources --remove https://rubygems.org/ 2>/dev/null
    gem sources --add https://gems.ruby-china.com/
    info "🇨🇳 使用 Ruby 中国镜像"
  else
    gem sources --remove https://gems.ruby-china.com/ 2>/dev/null
    gem sources --add https://rubygems.org/
    info "🌐 使用默认 Ruby 镜像"
  fi
  gem sources -l | tee -a "$LOG_FILE"
}

### ✅ 安装 CocoaPods（fzf选择 gem/brew）
install_cocoapods() {
  method=$(fzf_select "通过 gem 安装 CocoaPods" "通过 Homebrew 安装 CocoaPods")
  case $method in
    *gem*)
      sudo gem install cocoapods
      ;;
    *Homebrew*)
      brew install cocoapods
      ;;
    *) err "❌ 未选择安装方式";;
  esac
  pod setup
  info "✅ CocoaPods 安装完成"
  pod --version | tee -a "$LOG_FILE"
}

### ✅ 主流程
main() {
  print_logo
  backup_configs
  install_homebrew
  install_fzf
  install_ruby
  set_gem_source
  install_cocoapods
  print_duration
  info "🎉 所有步骤已完成，安装日志已保存：$LOG_FILE"
}

main
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
