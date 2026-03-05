#!/bin/bash

echo "🚨 自动修复Android v1嵌入错误"
echo "============================"

# 1. 备份当前配置
echo "📁 备份当前Android配置..."
backup_dir="android-backup-$(date +%Y%m%d_%H%M%S)"
cp -r android "$backup_dir" 2>/dev/null || echo "无Android目录可备份"
echo "✅ 备份完成: $backup_dir"

# 2. 删除整个Android目录
echo "🗑️  删除旧的Android目录..."
rm -rf android
echo "✅ 旧目录已删除"

# 3. 创建最基本的Android结构
echo "📁 创建新的Android项目结构..."
mkdir -p android/app/src/main/kotlin/com/example/android_spreadsheet
mkdir -p android/app/src/main/res/values
mkdir -p android/app/src/main/res/drawable

# 4. 创建最简化的AndroidManifest.xml
echo "📝 创建AndroidManifest.xml..."
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="简易表格"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# 5. 创建MainActivity.kt
echo "📝 创建MainActivity.kt..."
cat > android/app/src/main/kotlin/com/example/android_spreadsheet/MainActivity.kt << 'EOF'
package com.example.android_spreadsheet

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF

# 6. 创建最简化的build.gradle (app)
echo "📝 创建app/build.gradle..."
cat > android/app/build.gradle << 'EOF'
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader("UTF-8") { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found.")
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    compileSdkVersion 34

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.android_spreadsheet"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.22"
}
EOF

# 7. 创建项目级build.gradle
echo "📝 创建项目级build.gradle..."
cat > android/build.gradle << 'EOF'
buildscript {
    ext.kotlin_version = '1.9.22'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.4'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
EOF

# 8. 创建gradle.properties
echo "📝 创建gradle.properties..."
cat > android/gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
EOF

# 9. 创建settings.gradle
echo "📝 创建settings.gradle..."
cat > android/settings.gradle << 'EOF'
include ':app'

def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
def properties = new Properties()

assert localPropertiesFile.exists()
localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }

def flutterSdkPath = properties.getProperty("flutter.sdk")
assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"
EOF

# 10. 创建超简单GitHub Actions工作流
echo "📝 更新GitHub Actions工作流..."
cat > .github/workflows/build-final.yml << 'EOF'
name: Build APK (最终版)

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: 🎯 安装Flutter
      run: |
        echo "下载Flutter 3.19.0..."
        wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz -O flutter.tar.xz
        tar -xf flutter.tar.xz
        rm flutter.tar.xz
        echo "$(pwd)/flutter/bin" >> $GITHUB_PATH
        
    - name: 📦 安装项目依赖
      run: |
        echo "安装Flutter依赖..."
        ./flutter/bin/flutter pub get 2>&1 | tail -20
        
    - name: 🔧 准备构建环境
      run: |
        echo "准备Android构建环境..."
        # 创建local.properties
        echo "sdk.dir=/usr/local/lib/android/sdk" > android/local.properties
        echo "flutter.sdk=$(pwd)/flutter" >> android/local.properties
        
    - name: 🏗️ 构建APK
      run: |
        echo "开始构建APK..."
        ./flutter/bin/flutter build apk --release --verbose 2>&1 | tail -50
        
    - name: 📤 上传APK
      if: success()
      uses: actions/upload-artifact@v4
      with:
        name: spreadsheet-app
        path: build/app/outputs/flutter-apk/app-release.apk
        
    - name: 📋 生成报告
      if: always()
      run: |
        echo "## 构建报告" >> $GITHUB_STEP_SUMMARY
        echo "" >> $GITHUB_STEP_SUMMARY
        if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
          echo "✅ **构建成功!**" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "📱 APK文件大小: $(ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print $5}')" >> $GITHUB_STEP_SUMMARY
        else
          echo "❌ **构建失败**" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "请检查构建日志中的错误信息。" >> $GITHUB_STEP_SUMMARY
        fi
EOF

echo ""
echo "🎉 自动修复完成！"
echo ""
echo "📝 执行以下命令："
echo "1. git add ."
echo "2. git commit -m '完全重置Android配置为v2嵌入'"
echo "3. git push"
echo ""
echo "🚀 然后在GitHub Actions中运行 'Build APK (最终版)' 工作流"