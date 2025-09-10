@echo off
REM 获取当前脚本所在目录
setlocal
set script_dir=%~dp0
cd /d %script_dir%
cd ..
set rootPath=%cd%

dart "%rootPath%\bin\theme.bin.dart"
dart format "%rootPath%\lib\theme\base.theme.dart"
dart format "%rootPath%\lib\theme\theme.custom.dart"
endlocal
