#!/bin/zsh

# ✅ 打印绿色信息
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
print_green() {
  echo "\033[0;32m$1\033[0m"
}

# ✅ 显示脚本功能说明并等待用户确认
print_green "🛠️ 脚本功能：" | jobs_intro_style title
print_green "1️⃣ 自动判断当前目录是 iOS 工程还是 Flutter 工程。" | jobs_intro_style body
print_green "2️⃣ 对于 Apple Silicon 架构自动使用 Rosetta 兼容方式执行 pod install。" | jobs_intro_style body
print_green "3️⃣ 自动进入正确目录并执行 pod install --repo-update。" | jobs_intro_style body
print_green "📌 请确保已正确安装 CocoaPods。" | jobs_intro_style body
echo "" | jobs_intro_style body
read "?👉 按下回车键继续执行，或按 Ctrl+C 取消..."

# ✅ 打印信息函数
print_success() { echo "✅ $1"; }
print_info()    { echo "📘 $1"; }
print_error()   { echo "❌ $1"; }

# ✅ 获取脚本自身所在目录
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR" || exit 1
print_info "📌 当前起点路径: $BASE_DIR"

# ✅ 安装 pod 函数
install_pod() {
  local dir="$1"
  print_info "📁 进入目录: $dir"
  cd "$dir" || {
    print_error "❌ 无法进入目录: $dir"
    exit 1
  }

  local arch="$(uname -m)"
  print_info "🧠 当前架构: $arch"

  if [[ "$arch" == "arm64" ]]; then
    print_info "🍎 使用 Rosetta 执行 pod install"
    arch -x86_64 pod install --repo-update
  else
    print_info "💻 直接执行 pod install"
    pod install --repo-update
  fi

  print_success "🎉 Pod 安装完成"
}

# ✅ 主逻辑判断
if [[ -f "$BASE_DIR/Podfile" ]]; then
  print_info "📱 检测到 iOS 工程"
  install_pod "$BASE_DIR"
elif [[ -f "$BASE_DIR/pubspec.yaml" && -f "$BASE_DIR/ios/Podfile" ]]; then
  print_info "🧩 检测到 Flutter 工程，进入 ios 执行 pod install"
  install_pod "$BASE_DIR/ios"
else
  print_error "未找到 Podfile，无法继续"
  exit 1
fi
