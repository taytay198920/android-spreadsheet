# 📱 简易安卓表格应用

一个类似Excel的简单表格应用，使用Flutter开发，支持基本的表格编辑功能。

![GitHub Actions](https://img.shields.io/github/actions/workflow/status/YOUR_USERNAME/android-spreadsheet/build-apk.yml?branch=main)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.19-brightgreen.svg)

## ✨ 功能特点

- ✅ **自由添加/删除行和列** - 动态调整表格大小
- ✅ **单元格文本编辑** - 点击编辑内容
- ✅ **单元格颜色设置** - 长按选择背景颜色
- ✅ **单元格备注功能** - 添加注释，显示红点标记
- ✅ **离线使用** - 完全本地运行，无需网络
- ✅ **响应式UI** - 适应不同屏幕尺寸
- ✅ **自动构建** - GitHub Actions自动构建APK

## 🎨 界面预览

| 主界面 | 编辑单元格 | 颜色选择 |
|--------|------------|----------|
| ![主界面](https://via.placeholder.com/300x600/4A90E2/FFFFFF?text=表格界面) | ![编辑](https://via.placeholder.com/300x600/50E3C2/FFFFFF?text=编辑对话框) | ![颜色](https://via.placeholder.com/300x600/9013FE/FFFFFF?text=颜色选择器) |

## 🚀 一键构建APK

本项目使用GitHub Actions自动构建APK：

### 自动构建
1. 推送代码到 `main` 分支
2. GitHub Actions自动构建APK
3. 在 [Actions页面](https://github.com/YOUR_USERNAME/android-spreadsheet/actions) 下载APK

### 手动构建
1. 访问 Actions 页面
2. 点击 "Run workflow"
3. 选择构建类型 (release/debug)
4. 等待构建完成
5. 下载APK文件

## 📲 安装使用

### 下载APK
1. 从GitHub Actions下载最新APK
2. 传输到Android手机
3. 允许"未知来源应用安装"
4. 点击安装

### 使用说明
- **点击单元格**：编辑文本和备注
- **长按单元格**：选择背景颜色
- **右上角+按钮**：添加行/列
- **右上角删除按钮**：删除行/列

## 🏗️ 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/
│   └── spreadsheet.dart   # 数据模型
├── screens/
│   └── spreadsheet_screen.dart  # 主界面
└── widgets/
    └── cell_widget.dart   # 单元格组件
```

## 🛠️ 技术栈

- **Flutter 3.19** - 跨平台UI框架
- **Provider** - 状态管理
- **Hive** - 本地数据存储（待集成）
- **flutter_colorpicker** - 颜色选择器组件

## 📖 开发指南

### 本地开发
```bash
# 克隆项目
git clone https://github.com/YOUR_USERNAME/android-spreadsheet.git

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 构建APK
```bash
# 构建Release APK
flutter build apk --release

# 构建Debug APK  
flutter build apk --debug
```

## 📋 开发计划

### 已实现 ✅
- [x] 基础表格界面
- [x] 单元格编辑功能
- [x] 颜色选择功能
- [x] 备注功能
- [x] 行列管理

### 计划中 📅
- [ ] 数据持久化 (Hive/SQLite)
- [ ] 更多格式选项 (字体、对齐)
- [ ] 复制/粘贴功能
- [ ] 搜索功能
- [ ] 导出为CSV/Excel
- [ ] 公式计算支持

## 🤝 贡献

欢迎提交Issue和Pull Request！

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

- [Flutter](https://flutter.dev) - 优秀的跨平台框架
- [Provider](https://pub.dev/packages/provider) - 状态管理
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - 颜色选择器

---

**提示**：将 `YOUR_USERNAME` 替换为你的GitHub用户名