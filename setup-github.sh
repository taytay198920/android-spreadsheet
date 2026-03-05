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

# 检查是否已经是git仓库
if [ -d ".git" ]; then
    echo "📁 Git仓库已存在，更新代码..."
    git add .
    git commit -m "修复GitHub Actions构建问题" || echo "没有更改或已提交"
else
    echo "📁 初始化Git仓库..."
    git init
    git add .
    git commit -m "初始提交: 简易安卓表格应用"
fi

echo ""
echo "📋 当前状态："
git status

echo ""
echo "🔗 请按以下步骤操作："
echo ""
echo "1. 访问 https://github.com"
echo "2. 登录你的GitHub账号"
echo "3. 如果你还没有仓库，请创建："
echo "   - 点击右上角 '+' → 'New repository'"
echo "   - 仓库名: android-spreadsheet"
echo "   - 描述: 一个简单的Android表格应用"
echo "   - 选择: Public (公开)"
echo "   - 不要勾选 'Initialize this repository with...'"
echo "   - 点击 'Create repository'"
echo ""
echo "4. 如果你已有仓库，直接进行下一步"
echo ""
echo "5. 设置远程仓库（如果还没设置）："
echo "   git remote add origin https://github.com/你的用户名/android-spreadsheet.git"
echo ""
echo "6. 推送代码到GitHub："
echo "   git push -u origin main"
echo ""
echo "7. 如果遇到错误，先设置分支："
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "8. 完成后，访问：https://github.com/你的用户名/android-spreadsheet/actions"
echo ""
echo "9. 使用新的工作流："
echo "   - 你应该能看到 'Build Android APK (稳定版)'"
echo "   - 点击 'Run workflow'"
echo "   - 等待构建完成（约5-10分钟）"
echo ""
echo "10. 构建成功后下载 'spreadsheet-app-release'"

echo ""
echo "📱 重要更新："
echo "- 已修复Flutter版本检测问题"
echo "- 使用手动安装Flutter的稳定版本"
echo "- 工作流文件名：build-apk-stable.yml"

echo ""
echo "🚨 如果之前构建失败："
echo "1. 删除旧的GitHub仓库（可选）"
echo "2. 创建新仓库重新推送"
echo "3. 使用新的稳定版工作流"

echo ""
read -p "按回车键继续查看当前git配置，或按Ctrl+C退出..."
echo ""
echo "当前远程仓库："
git remote -v
echo ""
echo "当前分支："
git branch -a