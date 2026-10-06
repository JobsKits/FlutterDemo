#!/bin/zsh
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
clear
# 🧭 强制切换到脚本所在目录
cd "$(dirname "$0")"

echo "" | jobs_intro_style body
echo "📦 脚本用途：修复 Flutter 项目中 import 语句中被 URI 编码的中文路径（如 %E9%AB%98%E4%BB%BF）" | jobs_intro_style body
echo "" | jobs_intro_style body
echo "📁 判断 Flutter 项目根目录的依据：" | jobs_intro_style title
echo "   ✅ 当前目录下存在 pubspec.yaml" | jobs_intro_style body
echo "   ✅ 当前目录下存在 lib/ 文件夹" | jobs_intro_style body
echo "" | jobs_intro_style body
echo "🔧 本脚本将自动执行以下步骤：" | jobs_intro_style title
echo "1️⃣ 检测 Flutter 项目根目录（只要 pubspec.yaml 和 lib 文件夹存在即可）" | jobs_intro_style body
echo "2️⃣ 自动识别 Flutter 命令（优先使用 FVM）" | jobs_intro_style body
echo "3️⃣ 自检并升级依赖工具（brew / perl / URI::Escape）" | jobs_intro_style body
echo "4️⃣ 替换所有 Dart 文件中 URI 编码路径为中文路径" | jobs_intro_style body
echo "5️⃣ 所有修改文件备份至 .import_backup/" | jobs_intro_style body
echo "6️⃣ 自动在备份目录中生成 README.txt 说明" | jobs_intro_style body
echo "7️⃣ 最后询问是否执行 flutter analyze" | jobs_intro_style body
echo "8️⃣ 最后询问是否执行 flutter upgrade" | jobs_intro_style body
echo "" | jobs_intro_style body
echo "🔑 按下回车开始执行..." | jobs_intro_style body
read

# ✅ 判断是否为 Flutter 项目根目录
is_flutter_project_root() {
  [[ -f "pubspec.yaml" && -d "lib" ]]
}

until is_flutter_project_root; do
  echo "❌ 当前目录不是 Flutter 项目根目录（缺 pubspec.yaml 或 lib/ 文件夹）"
  read "?📂 请输入 Flutter 项目根目录路径：" proj_path
  cd "$proj_path" 2>/dev/null || {
    echo "❌ 路径无效：$proj_path"
    continue
  }
done

# ✅ 自动识别 flutter 命令
if command -v fvm &>/dev/null && [[ -x ".fvm/flutter_sdk/bin/flutter" ]]; then
  echo "🧭 检测到 FVM，使用 fvm flutter"
  FLUTTER_CMD=".fvm/flutter_sdk/bin/flutter"
else
  echo "🧭 使用全局 flutter"
  FLUTTER_CMD="flutter"
fi

# ✅ 自检并升级 brew
echo "🔄 更新 brew..."
if ! command -v brew &>/dev/null; then
  echo "❌ 未检测到 Homebrew，正在安装..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update && brew upgrade && brew cleanup

# ✅ Perl 自检
# 检查是否通过 brew 安装 Perl（忽略系统自带 Perl）
if ! brew list perl &>/dev/null; then
  echo "📦 未检测到 Homebrew 安装的 Perl，正在安装..."
  brew install perl || {
    echo "❌ Perl 安装失败，请检查网络或换用国内镜像。"
    exit 1
  }
else
  echo "🔄 检测到 Perl 已安装，正在升级..."
  brew upgrade perl
fi

# ✅ URI::Escape 自检
if ! perl -MURI::Escape -e 1 &>/dev/null; then
  echo "📦 安装 Perl 模块 URI::Escape..."
  cpan install URI::Escape || {
    echo "❌ 安装 URI::Escape 失败，请检查 Perl 配置"
    exit 1
  }
fi

# ✅ 替换 import 路径
echo ""
echo "🔍 正在扫描 Dart 文件..."
BACKUP_DIR=".import_backup"
mkdir -p "$BACKUP_DIR"

find . -name "*.dart" | while read -r file; do
  if grep -q "import 'package:[^']*%[0-9A-Fa-f]\{2\}" "$file"; then
    echo "🔧 修复 import：$file"
    cp "$file" "$BACKUP_DIR/$(basename "$file")"
    perl -i -pe 'use URI::Escape; s|(import\s+\'package:[^']*)|uri_unescape($1)|ge' "$file"
  fi
done

# ✅ 写入说明
cat > "$BACKUP_DIR/README.txt" <<EOF
该目录包含被替换前的 Dart 文件备份。
路径替换时间：$(date)
EOF

echo ""
echo "✅ 所有 import 路径修复完成"
echo "📦 备份文件位置：$(pwd)/$BACKUP_DIR"

# ✅ 分析
echo ""
read "?🔍 是否现在运行 $FLUTTER_CMD analyze 进行分析？（回车执行，Ctrl+C 跳过）"
$FLUTTER_CMD analyze

# ✅ 升级提示
echo ""
read "?⬆️ 是否执行 $FLUTTER_CMD upgrade 升级 Flutter？（回车执行，Ctrl+C 跳过）"
$FLUTTER_CMD upgrade
