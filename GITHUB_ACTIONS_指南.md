# 📱 GitHub Actions APK构建 - 完整指南

## 🎯 目标
通过GitHub Actions自动构建Android APK，无需本地开发环境。

## 📋 准备工作

### 1. 注册GitHub账号
- 访问 [github.com](https://github.com)
- 点击 "Sign up" 注册新账号
- 验证邮箱

### 2. 检查当前项目文件
项目已包含所有必要文件：
- ✅ Flutter代码 (`lib/` 目录)
- ✅ 配置文件 (`pubspec.yaml`)
- ✅ GitHub Actions配置 (`.github/workflows/build-apk.yml`)
- ✅ 忽略文件 (`.gitignore`)
- ✅ 许可证 (LICENSE)
- ✅ 文档 (README.md)

## 🚀 部署步骤

### 第一步：初始化Git仓库
```bash
# 进入项目目录
cd /root/.openclaw/workspace/android_spreadsheet

# 运行设置脚本
./setup-github.sh
```

脚本会显示详细步骤，按提示操作即可。

### 第二步：创建GitHub仓库
1. 登录GitHub
2. 点击右上角 **"+"** → **"New repository"**
3. 填写仓库信息：
   - **Repository name**: `android-spreadsheet`
   - **Description**: `一个简单的Android表格应用`
   - **Public** (选择公开)
   - **不要勾选** "Initialize this repository with README"
4. 点击 **"Create repository"**

### 第三步：推送代码到GitHub
创建仓库后，GitHub会显示推送命令，类似：
```bash
git remote add origin https://github.com/你的用户名/android-spreadsheet.git
git branch -M main
git push -u origin main
```

复制并执行这些命令。

### 第四步：触发构建
1. 访问你的仓库：`https://github.com/你的用户名/android-spreadsheet`
2. 点击顶部 **"Actions"** 标签
3. GitHub可能会提示授权，点击 **"I understand my workflows, go ahead and enable them"**
4. 等待约5-10分钟，构建会自动开始

## 📥 下载APK

### 构建成功后：
1. 返回 **"Actions"** 页面
2. 点击最新的工作流运行
3. 向下滚动到 **"Artifacts"** 部分
4. 下载 **"android-spreadsheet-release-apk"**
5. 解压得到 `app-release.apk` 文件

### 手动触发构建（可选）：
1. 在Actions页面点击 **"Run workflow"**
2. 选择构建类型：`release` (生产版本) 或 `debug` (调试版本)
3. 点击 **"Run workflow"**

## 📱 安装APK到手机

### 方法一：直接传输
1. 将APK文件复制到Android手机
2. 在手机上打开文件管理器
3. 找到APK文件并点击安装
4. 如果提示"未知来源"，进入设置允许安装

### 方法二：使用ADB（开发人员）
```bash
# 连接手机到电脑
adb devices
# 安装APK
adb install app-release.apk
```

## 🔧 构建配置说明

### GitHub Actions工作流特点：
- **自动触发**：推送代码到main分支时自动构建
- **缓存优化**：缓存Flutter包，加快构建速度
- **双版本构建**：同时生成Release和Debug APK
- **构建报告**：生成详细的构建摘要
- **30天保留**：APK文件保留30天

### 构建过程：
1. **检出代码** - 获取最新代码
2. **设置环境** - 安装Flutter SDK
3. **安装依赖** - 下载项目依赖包
4. **代码分析** - 检查代码质量
5. **运行测试** - 执行单元测试
6. **构建APK** - 编译生成APK文件
7. **上传产物** - 保存APK供下载

## 🐛 常见问题解决

### Q1: 构建失败怎么办？
- 检查 **Actions** 页面查看错误日志
- 常见问题：依赖冲突、Flutter版本不兼容
- 可尝试删除 `pubspec.lock` 文件重新构建

### Q2: 找不到APK文件？
- 检查是否构建成功（绿色勾号）
- 确保下载的是 **"android-spreadsheet-release-apk"**
- 解压zip文件获取APK

### Q3: 安装时提示"解析包错误"？
- 可能APK文件损坏，重新构建
- 检查Android版本兼容性（最低Android 5.0）
- 确保手机有足够存储空间

### Q4: 如何更新应用？
1. 修改代码
2. 提交并推送到GitHub
3. GitHub Actions自动构建新APK
4. 下载新APK安装

## 📈 进阶功能

### 自动版本号递增
可以配置每次构建自动递增版本号。

### 发布到GitHub Releases
构建成功后自动创建Release并上传APK。

### 多架构APK
构建支持不同CPU架构的APK（arm64, x86_64等）。

## 📞 支持

如果遇到问题：
1. 查看GitHub Actions错误日志
2. 检查Flutter版本兼容性
3. 确保 `pubspec.yaml` 依赖正确
4. 可以创建GitHub Issue寻求帮助

## 🎉 完成！

恭喜！你现在拥有：
- ✅ 一个完整的Flutter表格应用
- ✅ 自动构建系统
- ✅ 随时可下载的APK
- ✅ 持续集成/持续部署管道

现在你可以：
1. **立即使用**：下载APK安装到手机
2. **继续开发**：修改代码并自动构建新版本
3. **分享应用**：将GitHub链接分享给朋友

构建愉快！🚀