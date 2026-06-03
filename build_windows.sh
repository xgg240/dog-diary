#!/bin/bash
# Windows 端 build 脚本 - 你 Windows 上跑
# 用法：把这个脚本放项目根目录，双击或在 Git Bash / WSL 里跑

set -e

echo "=== 1. 装依赖 ==="
flutter pub get

echo "=== 2. 重新生成 drift ==="
dart run build_runner build --delete-conflicting-outputs

echo "=== 3. 编译 Windows ==="
flutter build windows --debug

echo ""
echo "=== ✅ 完成 ==="
echo "产物路径: build\\windows\\x64\\runner\\Debug\\dog_diary.exe"
echo "双击即可运行"
echo ""
echo "=== Release 版本（更小更快）==="
echo "flutter build windows --release"
echo "产物: build\\windows\\x64\\runner\\Release\\dog_diary.exe"
