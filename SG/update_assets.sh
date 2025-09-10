#chmod +x update_assets.sh
#./update_assets.sh
#!/bin/bash

while true; do
  # 读取 Dart 文件中的配置数据
  project_number=$(grep -o "const String project_number = '[^']*';" lib/package_config.dart | awk -F"= '" '{print $2}' | tr -d " ';")

  # 配置 Git 用户名和密码
  git_username="padi2"
  git_password="123561"

  # 目标文件夹路径
  destination_assets="./assets"
  destination_l10n="./lib/l10n"
  destination_generated="./lib/generated"

  # 临时目录路径
  temp_dir="./temp_assets"

  # 如果临时目录已存在且不为空目录，则删除它
  if [ -d "$temp_dir" ] && [ "$(ls -A $temp_dir)" ]; then
    rm -rf $temp_dir
  fi

  # 克隆仓库到临时目录
  git clone -b project$project_number http://$git_username:$git_password@munuyk.com/sg-frontend/sg_flutter_assets.git $temp_dir

  # 复制 assets 文件
  if [ -d "$temp_dir/assets" ]; then
    cp -R $temp_dir/assets/* "$destination_assets"
  else
    echo "Temp assets directory not found."
    continue
  fi

  # 复制 l10n 文件
  if [ -d "$temp_dir/l10n" ]; then
    cp -R $temp_dir/l10n/* "$destination_l10n"
  else
    echo "Temp l10n directory not found."
    continue
  fi

  # 复制 generated 文件夹
  if [ -d "$temp_dir/generated" ]; then
    cp -R $temp_dir/generated/* "$destination_generated"
  else
    echo "Temp generated directory not found."
    continue
  fi

  # 删除临时目录
  rm -rf $temp_dir

  echo "Files copied successfully."

  # 在当前 Flutter 项目中执行 pub get
  source ~/.bash_profile

  flutter pub get

  if [ $? -eq 0 ]; then
    echo "Script executed successfully."
    exit 0
  else
    echo "Script execution failed. Retrying..."
  fi

  # 等待一段时间后重新执行
  sleep 30
done
