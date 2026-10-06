#!/bin/zsh
# 脚本自述：
# - 脚本名称：【MacOS】⚙️双击安装FVM.command
# - 核心用途：双击安装FVM。
# - 影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。
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
  printf '%s\n' '【MacOS】⚙️双击安装FVM.command' | jobs_intro_style title
  printf '%s\n' '1、核心用途：双击安装FVM。' | jobs_intro_style body
  printf '%s\n' '2、影响范围：本机开发工具或用户环境配置；脚本所在工程或指定目标中的文件。' | jobs_intro_style body
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

# ========== 彩色输出 ==========
red()    { echo "\033[1;31m$1\033[0m"; }
green()  { echo "\033[1;32m$1\033[0m"; }
yellow() { echo "\033[1;33m$1\033[0m"; }

# ========== 📜 脚本说明 ==========
echo ""
echo "📦 本脚本将帮助你初始化 Flutter 项目环境（使用 FVM 管理）"
echo "🔍 自动检测工具 / 升级依赖 / 配置版本 / 安装 Flutter"
echo "📁 当前目录将被视为 Flutter 项目根目录"
echo ""

# ========== 获取 Flutter 项目目录 ==========
is_flutter_project() {
    [[ -f "$1/pubspec.yaml" && -d "$1/lib" ]]
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

if ! is_flutter_project "$SCRIPT_DIR"; then
    red "❌ 当前路径不是 Flutter 项目"
    while true; do
        echo ""
        echo "📁 请拖入一个 Flutter 项目文件夹，然后按回车："
        read "FLUTTER_DIR?路径："
        FLUTTER_DIR=${FLUTTER_DIR//\\//}
        FLUTTER_DIR=${FLUTTER_DIR//\"/}
        FLUTTER_DIR=$(eval "echo $FLUTTER_DIR")

        if is_flutter_project "$FLUTTER_DIR"; then
            cd "$FLUTTER_DIR"
            SCRIPT_DIR="$FLUTTER_DIR"
            green "✅ 成功进入 Flutter 项目：$SCRIPT_DIR"
            break
        else
            red "⚠️  无效路径，请确保包含 pubspec.yaml 和 lib/"
        fi
    done
fi

read "?⏳ 按【回车】继续，或 Ctrl+C 退出..."

# ========== 获取工具全称 ==========
get_tool_name() {
    case "$1" in
        brew) echo "Homebrew" ;;
        fzf) echo "fzf (模糊查找器)" ;;
        jq) echo "jq (JSON 解析工具)" ;;
        dart) echo "Dart SDK" ;;
        *) echo "$1" ;;
    esac
}

# ========== 检查/安装/升级 工具 ==========
check_install_tool() {
    local tool=$1
    local toolName=$(get_tool_name "$tool")
    if ! command -v $tool &>/dev/null; then
        yellow "🔧 未检测到 $toolName，准备安装..."
        case $tool in
            brew)
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
                ;;
            fzf|jq|dart)
                brew install "$tool"
                ;;
        esac
        if ! command -v $tool &>/dev/null; then
            red "❌ $toolName 安装失败，请手动处理"
            exit 1
        fi
        green "✅ $toolName 安装完成"
    else
        if [[ "$tool" == "brew" ]]; then
            green "✅ 已安装 $toolName，正在执行更新流程..."
            brew update && brew upgrade && brew cleanup
            green "✅ $toolName 更新完成"
        else
            green "✅ 已安装 $toolName，正在升级..."
            brew upgrade "$tool"
            green "✅ $toolName 升级完成"
        fi
    fi
}

# ========== 自检依赖 ==========
check_install_tool brew
check_install_tool fzf
check_install_tool jq
check_install_tool dart

# ========== 安装 FVM ==========
export PATH="$HOME/.pub-cache/bin:$PATH"
yellow "📦 安装/升级 FVM..."
dart pub global activate fvm

# ========== 读取或创建 flutterSdkVersion ==========
mkdir -p .fvm
CONFIG_FILE=".fvm/fvm_config.json"
CONFIGURED_VERSION=""
if [[ -f $CONFIG_FILE ]]; then
    CONFIGURED_VERSION=$(jq -r '.flutterSdkVersion // empty' $CONFIG_FILE)
    [[ -n $CONFIGURED_VERSION ]] && green "📄 当前配置版本：$CONFIGURED_VERSION"
fi

# ========== 获取 flutter 稳定版本 ==========
VERSIONS=$(fvm releases 2>/dev/null | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | awk -F'│' '
/stable/ && $2 ~ /[0-9]+\.[0-9]+\.[0-9]+/ {
    gsub(/ /, "", $2);
    gsub(/^v/, "", $2);
    print $2
}' | sort -V | uniq | tac)

# ========== 构建版本选择列表并标记当前 ==========
if [[ -n $CONFIGURED_VERSION ]]; then
    echo ""
    green "📄 当前配置版本：$CONFIGURED_VERSION"
    echo "⬇️ 请选择要使用的 Flutter 版本（当前版本已标记 ✅，回车保持当前）"
    CHOICES=$(echo "$VERSIONS" | sed "s/^$CONFIGURED_VERSION$/✅ $CONFIGURED_VERSION/")
else
    echo ""
    echo "⬇️ 可用 Flutter 稳定版本如下（回车默认选择最新）"
    CHOICES="$VERSIONS"
fi

# ========== fzf 选择版本 ==========
RAW_SELECTED_LINE=$(echo "$CHOICES" | \
  fzf --prompt="🎯 选择要使用的 Flutter 版本：" \
      --height=50% \
      --border \
      --ansi)

# 去除前缀并匹配版本号
SELECTED_VERSION=$(echo "$RAW_SELECTED_LINE" | sed 's/^✅ //' | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+$')

# ========== fallback 合理处理 ==========
if [[ -z "$SELECTED_VERSION" ]]; then
    if [[ -n $CONFIGURED_VERSION && "$CONFIGURED_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        SELECTED_VERSION=$CONFIGURED_VERSION
        yellow "📎 保持使用当前版本：$SELECTED_VERSION"
    else
        SELECTED_VERSION=$(echo "$VERSIONS" | head -n1)
        yellow "📎 未选择，默认使用最新版本：$SELECTED_VERSION"
    fi
fi

# ========== 写入配置 ==========
echo "{\"flutterSdkVersion\": \"$SELECTED_VERSION\"}" > "$CONFIG_FILE"
green "📝 已写入配置：$CONFIG_FILE"

# ========== 安装并切换版本 ==========
fvm install "$SELECTED_VERSION"
fvm use "$SELECTED_VERSION"

# ========== 写入 flutter 命令别名 ==========
if ! grep -q 'flutter()' ~/.zshrc; then
    echo '' >> ~/.zshrc
    echo 'flutter() { fvm flutter "$@"; }' >> ~/.zshrc
    green "✅ flutter 命令别名已写入 ~/.zshrc"
fi

# ========== 红色高亮打印版本信息 ==========
echo ""
red "=============================================="
red "🎉 当前 Flutter 版本：$(cd "$SCRIPT_DIR" && fvm flutter --version | head -n1)"
red "🎯 Dart 版本：$(cd "$SCRIPT_DIR" && fvm flutter --version | grep 'Dart')"
red "📦 FVM 路径：$(which fvm)"
red "📁 项目路径：$SCRIPT_DIR"
red "=============================================="
}
# 编排自述确认与原有业务。
main() {
  show_script_intro_and_wait # 展示用途与影响，并等待回车确认。
  jobs_run_original_script "$@" # 继续执行原有脚本流程。
}
main "$@"
