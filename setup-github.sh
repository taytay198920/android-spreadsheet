#!/bin/bash

echo "🚀 GitHub Actions APK构建 - 设置脚本"
echo "==================================="

# 检查git
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装，请先安装Git"
    echo "Ubuntu/Debian: sudo apt-get install git"
    echo "macOS: brew install git"
    exit 1
fi

echo "✅ Git检测通过"
echo "Git版本：$(git --version)"

# 初始化git仓库
echo ""
echo "📁 初始化Git仓库..."
git init
git add .
git commit -m "初始提交: 简易安卓表格应用"

echo ""
echo "📋 提交内容："
git status

echo ""
echo "🔗 请按以下步骤操作："
echo ""
echo "1. 访问 https://github.com"
echo "2. 登录你的GitHub账号"
echo "3. 点击右上角 '+' → 'New repository'"
echo "4. 仓库名: android-spreadsheet"
echo "5. 描述: 一个简单的Android表格应用"
echo "6. 选择: Public (公开)"
echo "7. 不要勾选 'Initialize this repository with...'"
echo "8. 点击 'Create repository'"
echo ""
echo "9. 创建后，GitHub会显示推送命令，看起来像："
echo "   git remote add origin https://github.com/你的用户名/android-spreadsheet.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "10. 复制并执行这些命令"
echo ""
echo "11. 完成后，访问：https://github.com/你的用户名/android-spreadsheet/actions"
echo "12. 等待构建完成（约5-10分钟）"
echo "13. 构建成功后下载APK文件"

echo ""
echo "📱 构建成功后："
echo "1. 点击 'Actions' 标签"
echo "2. 点击最新构建"
echo "3. 在 'Artifacts' 部分下载 'android-spreadsheet-apk'"
echo "4. 将APK文件传输到Android手机安装"

echo ""
echo "⚠️ 注意："
echo "- 第一次构建可能需要授权，点击 'I understand...'"
echo "- 构建过程完全自动化，无需人工干预"
echo "- 每次推送代码到main分支都会自动构建新APK"

echo ""
read -p "按回车键查看git状态，或按Ctrl+C退出..."