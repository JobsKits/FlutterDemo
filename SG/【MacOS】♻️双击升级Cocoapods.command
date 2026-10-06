#!/bin/zsh

# ✅ 打印颜色信息函数
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
print_green()  { echo "\033[0;32m$1\033[0m"; }
print_yellow() { echo "\033[0;33m$1\033[0m"; }
print_red()    { echo "\033[0;31m$1\033[0m"; }

# ✅ 打印脚本用途
print_usage() {
  print_green "🛠️ 脚本用途：" | jobs_intro_style title
  print_green "1️⃣ 检查当前 Ruby 与 gem 环境" | jobs_intro_style body
  print_green "2️⃣ 检查已安装的 CocoaPods 版本" | jobs_intro_style body
  print_green "3️⃣ 如果不是最新版本，则卸载所有旧版本并安装最新版本" | jobs_intro_style body
  print_green "4️⃣ 打印当前 pod 命令路径，验证环境配置正确" | jobs_intro_style body
  echo "" | jobs_intro_style body
  read "?👉 按下回车继续执行，或按 Ctrl+C 取消..."
}

# ✅ 检查当前 pod 版本
check_current_pod_version() {
  if command -v pod &>/dev/null; then
    CURRENT_VERSION=$(pod --version)
    print_green "当前 pod 版本: $CURRENT_VERSION"
  else
    print_red "未检测到 pod 命令，可能未安装或路径异常。"
    CURRENT_VERSION="none"
  fi
}

# ✅ 获取最新版本
get_latest_version() {
  LATEST_VERSION=$(gem list -r ^cocoapods$ | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)
  print_green "可用最新版本: $LATEST_VERSION"
}

# ✅ 检查当前 Ruby 和 gem 环境
check_ruby_env() {
  RUBY_PATH=$(rbenv which ruby 2>/dev/null)
  GEM_HOME=$(gem env home)
  print_yellow "当前使用的 Ruby 路径: $RUBY_PATH"
  print_yellow "当前使用的 gem 安装路径: $GEM_HOME"
}

# ✅ 清除所有已安装的 CocoaPods
remove_all_cocoapods() {
  print_yellow "卸载所有已安装的 CocoaPods..."
  gem list --local cocoapods | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | while read -r ver; do
    print_yellow "正在卸载版本: $ver"
    sudo gem uninstall cocoapods -v "$ver" -aIx
  done
}

# ✅ 安装最新版本 CocoaPods 到当前 Ruby
install_latest_cocoapods() {
  print_yellow "正在安装最新版本 CocoaPods $LATEST_VERSION ..."
  sudo gem install cocoapods -v "$LATEST_VERSION"
}

# ✅ 刷新缓存 & shim
refresh_env() {
  print_yellow "刷新环境缓存..."
  hash -r
  if command -v rbenv &>/dev/null; then
    print_yellow "检测到 rbenv，正在刷新 shim..."
    rbenv rehash
  fi
}

# ✅ 查看 pod 命令路径
check_pod_location() {
  POD_PATH=$(which pod)
  print_green "当前 pod 命令路径: $POD_PATH"
}

# ✅ 主流程
main() {
  print_usage

  print_green "🚀 CocoaPods 最终升级脚本开始执行..."

  check_ruby_env
  check_current_pod_version
  get_latest_version

  if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    print_green "✅ 已是最新版本，无需升级。"
  else
    remove_all_cocoapods
    install_latest_cocoapods
    refresh_env
    check_current_pod_version
    print_green "🎉 升级完成，当前 pod 版本: $(pod --version)"
  fi

  check_pod_location
}

main
