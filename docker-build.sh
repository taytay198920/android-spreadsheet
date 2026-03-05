#!/bin/bash

echo "🐳 使用Docker构建Android APK"
echo "============================"

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    echo "👉 安装指南：https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ Docker检测通过"

# 创建构建目录
mkdir -p build-output

# 构建Docker镜像
echo "🔨 构建Docker镜像..."
docker build -t flutter-build .

# 运行容器并复制APK文件
echo "🚀 运行构建..."
docker run --rm -v $(pwd)/build-output:/app/build/app/outputs/flutter-apk flutter-build

# 检查构建结果
if [ -f "build-output/app-release.apk" ]; then
    echo ""
    echo "🎉 构建成功！"
    echo "📱 APK文件位置：$(pwd)/build-output/app-release.apk"
    echo ""
    echo "📏 文件大小：$(du -h build-output/app-release.apk | cut -f1)"
    echo ""
    echo "📋 安装说明："
    echo "1. 将APK文件复制到Android手机"
    echo "2. 在手机设置中允许'未知来源应用安装'"
    echo "3. 点击APK文件安装"
    echo "4. 打开应用开始使用"
else
    echo "❌ 构建失败，未找到APK文件"
    exit 1
fi