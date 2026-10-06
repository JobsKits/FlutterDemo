#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️双击配置系统开发环境变量（bash_profile）.command
# - 核心用途：双击配置系统开发环境变量（bash_profile）。
# - 影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】⚙️双击配置系统开发环境变量（bash_profile）.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击配置系统开发环境变量（bash_profile）。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。' | jobs_intro_style body
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

# ✅ 彩色打印函数
print_success() { echo "\033[1;32m✅ $1\033[0m"; }
print_info()    { echo "\033[1;34m📘 $1\033[0m"; }
print_warn()    { echo "\033[1;33m⚠️ $1\033[0m"; }
print_error()   { echo "\033[1;31m❌ $1\033[0m"; }

# ✅ 选择写入配置文件
print_info "📝 请选择你要写入的配置文件（默认写入 ~/.bash_profile）："
echo "1️⃣ ~/.bash_profile"
echo "2️⃣ ~/.bashrc"
echo "3️⃣ ~/.zshrc"
echo "4️⃣ ~/.oh-my-zsh/oh-my-zsh.sh"
read "?👉 输入序号选择（回车默认 ~/.bash_profile）：" profile_choice

case $profile_choice in
  2) PROFILE_FILE="$HOME/.bashrc";;
  3) PROFILE_FILE="$HOME/.zshrc";;
  4) PROFILE_FILE="$HOME/.oh-my-zsh/oh-my-zsh.sh";;
  *) PROFILE_FILE="$HOME/.bash_profile";;
esac

print_info "📄 当前配置文件：$PROFILE_FILE"
touch "$PROFILE_FILE"

# ✅ 显示功能说明
print_info "🛠️ 本脚本支持添加以下环境变量配置（可多选）："
echo ""
echo " 1️⃣ Rbenv / Ruby"
echo " 2️⃣ Curl"
echo " 3️⃣ VSCode"
echo " 4️⃣ Flutter"
echo " 5️⃣ Android SDK"
echo " 6️⃣ FVM"
echo " 7️⃣ JDK / OpenJDK / SDKMAN"
echo " 8️⃣ Gradle"
echo " 9️⃣ pipx"
echo " 🔟 终端默认路径定位 ~/Desktop"
echo ""
print_warn "💡 默认直接回车 = 全选；否则请输入多个编号，用空格分隔"

selected=()
while true; do
  read "?👉 请输入你想添加的编号（回车=全选）: " input
  if [[ -z "$input" ]]; then
    selected=(1 2 3 4 5 6 7 8 9 10)
    break
  else
    selected+=($input)
    print_info "当前选择：${selected[*]}"
    read "?👉 是否继续添加更多编号？回车结束，输入更多编号继续：" more
    [[ -n "$more" ]] && selected+=($more) || break
  fi
done

selected=($(echo "${selected[@]}" | tr ' ' '\n' | sort -n | uniq))

# ✅ 检查并安装依赖
install_brew_package_if_needed() {
  local pkg=$1
  if ! brew list --formula | grep -q "^${pkg}$"; then
    print_warn "🍺 未安装 $pkg，正在安装..."
    brew install "$pkg"
    print_success "$pkg 安装完成"
  else
    print_info "$pkg 已安装"
  fi
}
install_brew_package_if_needed ruby
install_brew_package_if_needed curl

# ✅ 添加配置块函数
append_block_if_not_exists() {
  local id=$1
  local header="$2"
  shift 2
  local block=("$@")

  if [[ " ${selected[@]} " =~ " ${id} " ]]; then
    if ! grep -Fq "$header" "$PROFILE_FILE"; then
      if [[ -s "$PROFILE_FILE" ]]; then echo "" >> "$PROFILE_FILE"; fi
      echo "$header" >> "$PROFILE_FILE"
      for line in "${block[@]}"; do echo "$line" >> "$PROFILE_FILE"; done
      print_success "已添加：$header"
    else
      print_info "📌 已存在：$header"
    fi
  fi
}

# ✅ 实际配置项
append_block_if_not_exists 1 "# 配置 Rbenv.ruby 环境变量" \
  'export PATH="$HOME/.rbenv/bin:$PATH"' \
  'eval "$(rbenv init -)"' \
  '# 配置 Ruby 环境变量（Homebrew 安装）' \
  'export PATH="/usr/local/opt/ruby/bin:$PATH"' \
  'export LDFLAGS="-L/usr/local/opt/ruby/lib"' \
  'export CPPFLAGS="-I/usr/local/opt/ruby/include"' \
  'export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"'

append_block_if_not_exists 2 "# 配置 Curl 环境变量（Homebrew 安装）" \
  'export PATH="/usr/local/opt/curl/bin:$PATH"' \
  'export LDFLAGS="-L/usr/local/opt/curl/lib"' \
  'export CPPFLAGS="-I/usr/local/opt/curl/include"' \
  'export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"'

append_block_if_not_exists 3 "# 配置 VSCode 环境变量" \
  'export PATH="$PATH":/usr/local/bin' \
  'export PATH="$PATH":/usr/local/bin/code'

append_block_if_not_exists 4 "# 配置 Flutter 环境变量" \
  '# 这里的路径请根据你本机SDK修改' \
  'export PATH="$PATH:`pwd`/flutter/bin"' \
  'export PATH=$HOME/Documents/GitHub.Jobs/Flutter.SDK/Flutter.SDK.last/bin:$PATH' \
  '# Flutter 镜像设置' \
  'export PUB_HOSTED_URL=https://pub.dartlang.org' \
  'export FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com'

append_block_if_not_exists 5 "# 配置 Android SDK 环境变量" \
  'export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk' \
  'export PATH=${PATH}:${ANDROID_SDK_ROOT}/platform-tools' \
  'export PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin' \
  'export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$PATH'

append_block_if_not_exists 6 "# 配置 FVM 环境变量" \
  'export PATH="$HOME/.pub-cache/bin:$PATH"' \
  'flutter() { fvm flutter "$@"; }'

append_block_if_not_exists 7 "# 配置 JDK / OpenJDK / SDKMAN" \
  'export JAVA_HOME=$(/usr/libexec/java_home)' \
  'export PATH=$JAVA_HOME/bin:$PATH' \
  'export SDKMAN_DIR="$HOME/.sdkman"' \
  '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' \
  '#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!'

append_block_if_not_exists 8 "# 配置 Gradle 环境变量" \
  'export PATH="$HOME/Documents/Gradle/gradle-8.7/bin:$PATH"'

append_block_if_not_exists 9 "# 配置 pipx 环境变量" \
  'export PATH="$PATH:$HOME/.local/bin"'

append_block_if_not_exists 10 "# 每次打开终端默认进入桌面目录" \
  'cd ~/Desktop'

# ✅ 打开配置文件
open "$PROFILE_FILE"

# ✅ 尝试重新加载
print_info "🔄 重新加载 $PROFILE_FILE"
[[ -s "$PROFILE_FILE" ]] && source "$PROFILE_FILE" || print_warn "⚠️ 配置文件为空，跳过 source"
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
