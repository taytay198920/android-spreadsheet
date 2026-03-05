#!/bin/bash

echo "📱 简易表格应用 - 运行脚本"
echo "========================"

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "👉 安装指南：https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter环境检测通过"
echo "当前Flutter版本：$(flutter --version | head -1)"

# 检查依赖
echo ""
echo "📦 安装依赖..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ 依赖安装完成"
else
    echo "❌ 依赖安装失败"
    exit 1
fi

# 显示可用设备
echo ""
echo "📱 可用设备："
flutter devices

echo ""
echo "🚀 运行选项："
echo "1. 在Web浏览器中运行"
echo "2. 在Android设备/模拟器运行"
echo "3. 检查代码格式"
echo "4. 构建APK文件"
echo "5. 退出"

read -p "请选择 (1-5): " choice

case $choice in
    1)
        echo "🌐 在Chrome中启动Web版本..."
        flutter run -d chrome
        ;;
    2)
        echo "🤖 在Android设备运行..."
        flutter run
        ;;
    3)
        echo "🔍 代码格式检查..."
        flutter analyze
        flutter format --set-exit-if-changed lib/
        ;;
    4)
        echo "📦 构建Android APK..."
        flutter build apk --release
        echo "✅ APK文件位置：build/app/outputs/flutter-apk/app-release.apk"
        ;;
    5)
        echo "👋 再见！"
        exit 0
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac