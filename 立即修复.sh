#!/bin/bash

echo "🚨 紧急修复Android v1嵌入错误"
echo "============================="

echo "⚠️  警告：这将重置Android配置"
read -p "按回车键继续，或Ctrl+C取消..."

# 1. 备份当前配置
echo "📁 备份当前Android配置..."
cp -r android android-backup-$(date +%s)
echo "✅ 备份完成"

# 2. 删除整个Android目录
echo "🗑️  删除旧的Android目录..."
rm -rf android
echo "✅ 旧目录已删除"

# 3. 创建最基本的Android结构
echo "📁 创建新的Android项目结构..."
mkdir -p android/app/src/main/kotlin/com/example/android_spreadsheet
mkdir -p android/app/src/main/res
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
    ndkVersion "25.1.8937393"

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
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()
    settings.ext.flutterSdkPath = flutterSdkPath

    includeBuild("${settings.ext.flutterSdkPath}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.1.4" apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}

include ":app"
EOF

# 10. 创建最简单的GitHub Actions工作流
echo "📝 创建最简GitHub Actions工作流..."
mkdir -p .github/workflows
cat > .github/workflows/build-ultra-simple.yml << 'EOF'
name: Build APK (超简单版)

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: 🔧 安装Flutter
      run: |
        wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz
        tar -xf flutter_linux_3.19.0-stable.tar.xz
        rm flutter_linux_3.19.0-stable.tar.xz
        echo "$(pwd)/flutter/bin" >> $GITHUB_PATH
        
    - name: 📦 安装依赖
      run: |
        ./flutter/bin/flutter --version
        ./flutter/bin/flutter pub get
        
    - name: 🏗️ 构建APK
      run: |
        # 使用最小化配置构建
        ./flutter/bin/flutter build apk --release
        
    - name: 📤 上传APK
      uses: actions/upload-artifact@v4
      with:
        name: app-release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
EOF

echo ""
echo "🎉 修复完成！"
echo ""
echo "📝 接下来操作："
echo "1. 提交更改: git add ."
echo "2. 提交信息: git commit -m '完全重置Android配置，修复v1嵌入错误'"
echo "3. 推送到GitHub: git push"
echo ""
echo "🚀 在GitHub上："
echo "1. 使用新的工作流: 'Build APK (超简单版)'"
echo "2. 点击 'Run workflow'"
echo "3. 等待构建完成"
echo ""
echo "🔧 关键修复："
echo "- ✅ 完全重置Android目录"
echo "- ✅ 最简化的v2嵌入配置"
echo "- ✅ 移除所有可能导致v1嵌入的配置"
echo "- ✅ 全新的GitHub Actions工作流"