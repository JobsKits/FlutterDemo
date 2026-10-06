#!/bin/zsh

# ✅ 彩色输出函数
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
_color_echo() {
  local color="$1"
  local message="$2"
  case "$color" in
    green)  echo "\033[32m${message}\033[0m" ;;
    red)    echo "\033[31m${message}\033[0m" ;;
    blue)   echo "\033[34m${message}\033[0m" ;;
    yellow) echo "\033[33m${message}\033[0m" ;;
    *)      echo "$message" ;;
  esac
}

# ✅ 显示脚本功能说明并等待用户确认
_color_echo green "🛠️ 脚本功能：" | jobs_intro_style title
_color_echo green "1️⃣ 自动清理无效模拟器（无法启动的）。" | jobs_intro_style body
_color_echo green "2️⃣ 获取所有可用的 iPhone 机型和 iOS 系统版本，组合供用户选择。" | jobs_intro_style body
_color_echo green "3️⃣ 创建指定设备+系统组合的模拟器，自动命名并启动。" | jobs_intro_style body
_color_echo green "🧩 模拟器名称格式：iPhone 15（实际名称）| iOS 版本 - 构建号 | 创建时间（仅用于显示）" | jobs_intro_style body
echo "" | jobs_intro_style body
read "?👉 按下回车键继续执行，或按 Ctrl+C 取消..."

# ✅ 检查 Homebrew
check_and_install_brew() {
  if ! command -v brew &>/dev/null; then
    _color_echo red "🍺 未检测到 Homebrew，正在自动安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    _color_echo green "✅ Homebrew 安装完成"
    export PATH="/opt/homebrew/bin:$PATH"
  else
    _color_echo green "✅ Homebrew 已安装"
  fi
}

# ✅ 检查 fzf
check_and_install_fzf() {
  if ! command -v fzf &>/dev/null; then
    _color_echo blue "🔧 正在安装 fzf..."
    brew install fzf
  else
    _color_echo green "✅ fzf 已安装"
  fi
}

# ✅ 自动清理无效模拟器
clean_invalid_simulators() {
  _color_echo blue "🧹 正在清理无效模拟器（无法 boot）..."
  boot_fail_ids=$(xcrun simctl list devices | grep -i "unavailable" | grep -oE '[A-F0-9\-]{36}')
  for id in $boot_fail_ids; do
    _color_echo yellow "🗑️ 删除无效模拟器 ID: $id"
    xcrun simctl delete "$id"
  done
  _color_echo green "✅ 无效模拟器清理完成"
}

# ✅ 初始化
check_and_install_brew
check_and_install_fzf
clean_invalid_simulators

# 📦 获取设备类型和系统
_color_echo blue "📦 获取可用设备类型..."
device_types=("${(@f)$(xcrun simctl list devicetypes | grep 'iPhone' | sed -E 's/^(.*) \((.*)\)/\2|\1/')}")

_color_echo blue "📦 获取可用 iOS 运行时..."
runtimes=("${(@f)$(xcrun simctl list runtimes | grep 'iOS' | grep -v 'unavailable' | grep -v '(null)' | sed -E 's/^(.*) \((.*)\) - (.*)/\3|\1 (\2)/')}")

# 🧩 组合设备+系统
combos=()
for d in "${device_types[@]}"; do
  for r in "${runtimes[@]}"; do
    combos+=("${d}+${r}")
  done
done

# 🎯 用户选择
selected=$(printf "%s\n" "${combos[@]}" | awk -F'[|+]' '{printf "%-30s | %-30s [%s + %s]\n", $2, $4, $1, $3}' | tac | fzf --height=30% --reverse --border --prompt=" 选择要创建的模拟器: ")

# ⛏️ 提取 ID
device_type_id=$(echo "$selected" | sed -E 's/.*\[(.*) \+ (.*)\]/\1/')
runtime_id=$(echo "$selected" | sed -E 's/.*\[(.*) \+ (.*)\]/\2/')

# ✅ 手动提取干净的字段
device_label=$(echo "$selected" | cut -d '[' -f1 | awk '{$1=$1};1')
device_name=$(echo "$device_label" | cut -d '|' -f1 | awk '{$1=$1};1')
version=$(echo "$device_label" | sed -E 's/.*iOS ([0-9.]+).*/\1/')
build=$(echo "$device_label" | sed -E 's/.*- ([0-9A-Z]+)\).*/\1/')
current_time=$(date "+%Y.%m.%d %H:%M")

# 🧱 命名与输出
sim_name="$device_name"
pretty_sim_name="$device_name | iOS $version - $build | $current_time"
_color_echo blue "🛠️ 创建模拟器: $pretty_sim_name"

# 🛑 关闭模拟器
_color_echo yellow "🛑 正在关闭所有运行中的模拟器..."
xcrun simctl shutdown all

# 🚀 创建模拟器
sim_id=$(xcrun simctl create "$sim_name" "$device_type_id" "$runtime_id")
if [ -z "$sim_id" ]; then
  _color_echo red "❌ 创建失败，请检查设备/系统是否有效"
  exit 1
fi

# 启动模拟器
open -a Simulator
sleep 2
_color_echo blue "🚀 正在启动模拟器..."
xcrun simctl boot "$sim_id" 2>/tmp/sim_boot_log.txt

if grep -q "Unable to boot device because it cannot be located on disk" /tmp/sim_boot_log.txt; then
  _color_echo red "❌ 启动失败：runtime 文件丢失，将自动清理该模拟器..."
  xcrun simctl delete "$sim_id"
  _color_echo yellow "🗑️ 模拟器 $pretty_sim_name 已被删除（ID: $sim_id）"
  exit 1
fi

_color_echo green "✅ 模拟器 $pretty_sim_name 已成功启动（ID: $sim_id）"
