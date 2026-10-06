#! /bin/sh
# 脚本自述：
# - 脚本名称：【MacOS】OSConfig.command
# - 核心用途：配置开发环境与用户 Shell 设置。
# - 影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件；本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】OSConfig.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：配置开发环境与用户 Shell 设置。' | jobs_intro_style body
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

# 格式化打印输出
print() {
    local mainMessage=$1
    local subMessage=$2
    echo "\033[1m${mainMessage}\033[0m"
    echo "\033[31m${subMessage}\033[0m"
}

# 获取当前脚本文件的目录
current_directory=$(dirname "$(readlink -f "$0")")
echo $current_directory

print "当前系统所使用的FLUTTER_STORAGE_BASE_URL为：" "$FLUTTER_STORAGE_BASE_URL"
print "当前系统所使用的PUB_HOSTED_URL为：" "$PUB_HOSTED_URL"

# 检查 ~/.bash_profile 文件是否存在，如果不存在则创建
if [ ! -f ~/.bash_profile ]; then
    touch ~/.bash_profile
    print "~/.bash_profile 文件" "已创建"
fi

# 检查并添加行到 ~/.bash_profile
add_line_if_not_exists_bash_profile() {
    local line=$1
    if ! grep -qF "$line" ~/.bash_profile; then
        echo '' >> ~/.bash_profile # 写入之前，先进行提行
        echo "$line" >> ~/.bash_profile
        print "添加到 ~/.bash_profile ：" "$line"
    else
        print "~/.bash_profile 中已存在" "$line"
    fi
}
# 检查并添加行到 ~/.zshrc
add_line_if_not_exists_zshrc() {
    local line=$1
    if ! grep -qF "$line" source ~/.zshrc; then
        echo '' >> ~/.zshrc # 写入之前，先进行提行
        echo "$line" >> source ~/.zshrc
        print "添加到 ~/.zshrc ：" "$line"
    else
        print "~/.zshrc 中已存在" "$line"
    fi
}
# 添加各行配置到 ~/.bash_profile
# 配置FVM环境
add_line_if_not_exists_bash_profile 'export PATH="$PATH":"$HOME/.pub-cache/bin"'
# 配置VSCode环境
add_line_if_not_exists_bash_profile 'export PATH="$PATH":/usr/local/bin'
add_line_if_not_exists_bash_profile 'export PATH="$PATH":/usr/local/bin/code'

# 添加 Android 环境变量配置
add_line_if_not_exists_bash_profile 'export ANDROID_HOME=/Users/jobs/Library/Android/sdk'
add_line_if_not_exists_bash_profile 'export PATH=${PATH}:${ANDROID_HOME}/platform-tools'
add_line_if_not_exists_bash_profile 'export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin'

# 添加 Flutter 环境变量配置
add_line_if_not_exists_bash_profile 'export PATH="$PATH:`pwd`/flutter/bin"'
add_line_if_not_exists_bash_profile '# 这里的路径即为Dart.Flutter.SDK名下的为bin目录（主要取决于你下载的SDK的绝对路径）'
add_line_if_not_exists_bash_profile 'export PATH=/Users/admin/Documents/Github/Flutter.sdk/Flutter.sdk_last/bin:$PATH'
add_line_if_not_exists_bash_profile '#【相关阅读：Flutter切换源】https://juejin.cn/post/7204285137047257148'
add_line_if_not_exists_bash_profile '# 防止域名在中国大陆互联网环境下的被屏蔽'
add_line_if_not_exists_bash_profile '# export PUB_HOSTED_URL=https://pub.flutter-io.cn # 告诉了 Dart.Flutter 和 Dart 的包管理器 pub 在执行 pub get 或 pub upgrade 命令时使用备用仓库而不是默认的官方仓库。'
add_line_if_not_exists_bash_profile '# Flutter官方正版源（温馨提示：海外IP访问大陆源，不开VPN会拉取失败）'
add_line_if_not_exists_bash_profile 'export PUB_HOSTED_URL=https://pub.dartlang.org'
add_line_if_not_exists_bash_profile '# FLUTTER_STORAGE_BASE_URL 告诉了 Dart.Flutter SDK 在需要下载二进制文件或工具时从备用存储库获取，而不是从默认的 Google 存储库获取。'
add_line_if_not_exists_bash_profile '# export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn # Flutter中国（七牛云）'
add_line_if_not_exists_bash_profile 'export FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com # Flutter官方的 Google Cloud 存储库地址'
# 配置终端打开的路径
add_line_if_not_exists_bash_profile 'cd ./Desktop'

# 检查并添加 # source ~/.bash_profile
if ! grep -qF '#source ~/.bash_profile' ~/.bash_profile; then
    echo '' >> ~/.bash_profile # 写入之前，先进行提行
    echo '#source ~/.bash_profile' >> ~/.bash_profile
    print "添加到.bash_profile：" '#source ~/.bash_profile'
else
    print ".bash_profile中已存在" '#source ~/.bash_profile'
fi

# 打开主目录和 .bash_profile 文件
open ~/
open ~/.bash_profile

add_line_if_not_exists_zshrc

# 重新加载 ~/.bash_profile
echo "重新加载 ~/.bash_profile"
source ~/.bash_profile
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
