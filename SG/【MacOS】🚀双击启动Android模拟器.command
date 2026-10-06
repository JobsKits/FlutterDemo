#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】🚀双击启动Android模拟器.command
# - 核心用途：双击启动Android模拟器。
# - 影响范围：本机开发工具或用户环境配置；本机应用、模拟器或终端窗口。
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
  printf '%s\n' '【MacOS】🚀双击启动Android模拟器.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击启动Android模拟器。' | jobs_intro_style body
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
  0="$JOBS_COMMAND_ENTRY_ARG0"

# ✅ 设置 ANDROID_HOME 和 PATH（仅当前会话）
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

clear

# ✅ 路径定义
EMULATOR_DIR="$ANDROID_HOME/emulator"
SYSTEM_IMAGES_DIR="$ANDROID_HOME/system-images"
AVD_DIR="$HOME/.android/avd"
CMDLINE_TOOLS_BIN="$ANDROID_HOME/cmdline-tools/latest/bin"

# ✅ 路径检测函数
print_path_check() {
  local path="$1"
  local label="$2"
  if [[ -d "$path" || -x "$path" ]]; then
    echo "✅ $label：$path"
  else
    echo "❌ $label：未找到路径 $path"
  fi
}

# ✅ 打印说明 + 检查路径
echo ""
echo "=============================="
echo "📦 Android 模拟器工具脚本"
echo "=============================="
echo ""
echo "📁 模拟器目录结构说明："
echo "1️⃣ SDK 根目录         ：\$ANDROID_HOME → $ANDROID_HOME"
echo "2️⃣ 模拟器工具目录     ：\$ANDROID_HOME/emulator"
echo "3️⃣ 系统镜像目录       ：\$ANDROID_HOME/system-images/"
echo "4️⃣ 模拟器配置数据目录 ：~/.android/avd/"
echo ""
echo "📂 示例目录结构："
echo "~/.android/avd/"
echo "├── Pixel_5.avd/"
echo "│   ├── userdata-qemu.img"
echo "│   ├── config.ini"
echo "├── Pixel_5.ini"
echo ""
echo "~/Library/Android/sdk/"
echo "├── emulator/"
echo "├── system-images/"
echo "│   └── android-34/google_apis/x86_64/"
echo "├── platforms/"
echo ""
echo "🔍 正在检测关键路径..."
print_path_check "$ANDROID_HOME"             "SDK 根目录"
print_path_check "$EMULATOR_DIR"             "Emulator 工具目录"
print_path_check "$SYSTEM_IMAGES_DIR"        "系统镜像目录"
print_path_check "$AVD_DIR"                  "模拟器配置目录"
print_path_check "$CMDLINE_TOOLS_BIN"        "cmdline-tools/bin"
echo ""
echo "=============================="
echo "📦 脚本功能说明："
echo "✅ 自动安装 brew、fzf、模拟器相关工具"
echo "✅ 自动检测 emulator 是否可用"
echo "✅ 无模拟器时自动创建并启动（fzf 选择）"
echo "✅ 已有模拟器时支持 fzf 交互选择启动"
echo "=============================="
echo ""

read "?⏎ 按回车键继续执行，或按 Ctrl+C 退出..."

# ✅ 安装 brew（自动适配 M1/M2/Intel）
install_brew_if_needed() {
  if ! command -v brew &>/dev/null; then
    echo "🔍 未检测到 Homebrew，正在自动安装..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$(uname -m)" == "arm64" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  echo "✅ 已安装 Homebrew，尝试更新..."
  brew update && brew upgrade
}

# ✅ 安装/升级 fzf
install_or_upgrade_fzf() {
  if command -v fzf &>/dev/null; then
    echo "✅ fzf 已安装，尝试升级..."
    brew upgrade fzf || echo "⚠️ 升级失败，跳过"
  else
    echo "🔧 安装 fzf ..."
    brew install fzf || { echo "❌ 安装失败"; exit 1; }
  fi
}

# ✅ 检查 emulator
check_emulator() {
  if ! command -v emulator &>/dev/null; then
    echo "❌ 未找到 emulator 命令，请检查 \$ANDROID_HOME 是否正确配置"
    exit 1
  fi
}

# ✅ 检查 sdkmanager 和 avdmanager
check_sdk_tools() {
  if [[ ! -x "$CMDLINE_TOOLS_BIN/sdkmanager" || ! -x "$CMDLINE_TOOLS_BIN/avdmanager" ]]; then
    echo "❌ 缺少 sdkmanager 或 avdmanager"
    echo "👉 请从 https://developer.android.com/studio#cmdline 下载并解压至："
    echo "$ANDROID_HOME/cmdline-tools/latest/"
    exit 1
  fi
}

# ✅ 创建 AVD
create_avd_if_needed() {
  avds=($(emulator -list-avds))
  if [[ ${#avds[@]} -eq 0 ]]; then
    echo "⚠️ 本机无模拟器，准备创建..."

    selected=$(cat <<EOF | fzf --prompt="请选择要创建的模拟器："
Pixel 5 (pixel_5) + system-images;android-34;google_apis;x86_64
Pixel 4 (pixel_4) + system-images;android-33;google_apis;x86_64
Pixel 3 (pixel_3) + system-images;android-31;google_apis;x86_64
EOF
)

    if [[ -z "$selected" ]]; then
      echo "⚠️ 用户取消创建，退出"
      exit 0
    fi

    device_id=$(echo "$selected" | awk -F '[()]' '{print $2}')
    avd_label=$(echo "$selected" | cut -d '+' -f 1 | cut -d '(' -f 1 | xargs)
    avd_name=$(echo "$avd_label" | tr ' ' '_' | tr -cd '[:alnum:]_.-')
    image_id=$(echo "$selected" | cut -d '+' -f 2 | xargs)

    echo "📦 安装系统镜像：$image_id ..."
    yes | "$CMDLINE_TOOLS_BIN/sdkmanager" "$image_id"

    echo "🛠️ 创建模拟器：$avd_name ..."
    echo "no" | "$CMDLINE_TOOLS_BIN/avdmanager" create avd -n "$avd_name" -k "$image_id" --device "$device_id"

    echo "📂 打开模拟器目录：$AVD_DIR/$avd_name.avd/"
    open "$AVD_DIR/$avd_name.avd"

    echo "🚀 启动模拟器：$avd_name"
    emulator -avd "$avd_name" &

    sleep 5

    if ! pgrep -f "emulator.*$avd_name" >/dev/null; then
      echo "❌ 模拟器启动失败，请手动尝试：emulator -avd $avd_name"
    else
      echo "✅ 模拟器正在运行中：$avd_name"
    fi

    exit 0
  fi
}

# ✅ 启动已存在模拟器
start_avd() {
  avds=($(emulator -list-avds))
  selected=$(printf "%s\n" "${avds[@]}" | fzf --prompt="请选择要启动的模拟器：")
  if [[ -z "$selected" ]]; then
    echo "⚠️ 用户取消选择，退出"
    exit 0
  fi

  echo "🚀 启动模拟器：$selected"
  emulator -avd "$selected" &

  sleep 5
  if ! pgrep -f "emulator.*$selected" >/dev/null; then
    echo "❌ 启动失败，请手动执行：emulator -avd $selected"
  else
    echo "✅ 模拟器正在运行中：$selected"
  fi
}

# ✅ 主流程执行
install_brew_if_needed
install_or_upgrade_fzf
check_emulator
check_sdk_tools
create_avd_if_needed
start_avd
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
