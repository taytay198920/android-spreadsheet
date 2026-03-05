#!/bin/bash

echo "🔧 修复Android v2嵌入问题"
echo "========================"

echo "📁 检查Android项目结构..."

# 1. 检查MainActivity.kt是否存在
if [ ! -f "android/app/src/main/kotlin/com/example/android_spreadsheet/MainActivity.kt" ]; then
    echo "❌ MainActivity.kt 不存在，创建中..."
    mkdir -p android/app/src/main/kotlin/com/example/android_spreadsheet
    echo 'package com.example.android_spreadsheet

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}' > android/app/src/main/kotlin/com/example/android_spreadsheet/MainActivity.kt
    echo "✅ MainActivity.kt 已创建"
else
    echo "✅ MainActivity.kt 存在"
fi

# 2. 检查AndroidManifest.xml
echo ""
echo "🔍 检查AndroidManifest.xml..."
if grep -q "flutterEmbedding" android/app/src/main/AndroidManifest.xml; then
    echo "⚠️  发现flutterEmbedding标签，可能引起v1嵌入问题"
    echo "正在修复..."
    
    # 创建备份
    cp android/app/src/main/AndroidManifest.xml android/app/src/main/AndroidManifest.xml.backup
    
    # 使用简化的Manifest
    echo '<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application
        android:label="简易表格"
        android:icon="@mipmap/ic_launcher"
        android:allowBackup="false">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            <meta-data
                android:name="io.flutter.embedding.android.SplashScreenDrawable"
                android:resource="@drawable/launch_background" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>' > android/app/src/main/AndroidManifest.xml
    
    echo "✅ AndroidManifest.xml 已修复"
else
    echo "✅ AndroidManifest.xml 看起来正常"
fi

# 3. 检查build.gradle
echo ""
echo "🔍 检查build.gradle..."
if grep -q "ndkVersion flutter.ndkVersion" android/app/build.gradle; then
    echo "⚠️  发现旧的ndk配置，更新中..."
    
    # 更新build.gradle
    sed -i 's/ndkVersion flutter.ndkVersion//g' android/app/build.gradle
    sed -i 's/minSdkVersion flutter.minSdkVersion/minSdkVersion 21/g' android/app/build.gradle
    sed -i 's/targetSdkVersion flutter.targetSdkVersion/targetSdkVersion 34/g' android/app/build.gradle
    
    # 添加多架构支持
    if ! grep -q "abiFilters" android/app/build.gradle; then
        sed -i '/versionName flutterVersionName/a\        \n        # 添加多架构支持\n        ndk {\n            abiFilters \"armeabi-v7a\", \"arm64-v8a\", \"x86_64\"\n        }' android/app/build.gradle
    fi
    
    echo "✅ build.gradle 已更新"
else
    echo "✅ build.gradle 看起来正常"
fi

# 4. 检查必要的gradle文件
echo ""
echo "📁 检查gradle配置文件..."
required_gradle_files=(
    "android/build.gradle"
    "android/gradle.properties"
    "android/settings.gradle"
)

for file in "${required_gradle_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 不存在，但这不是关键问题"
    fi
done

# 5. 检查proguard规则
if [ ! -f "android/app/proguard-rules.pro" ]; then
    echo "📝 创建proguard规则文件..."
    cat > android/app/proguard-rules.pro << 'EOF'
# Flutter 基础规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
EOF
    echo "✅ proguard-rules.pro 已创建"
else
    echo "✅ proguard-rules.pro 存在"
fi

echo ""
echo "🎯 修复完成！"
echo ""
echo "📝 接下来："
echo "1. 提交更改: git add ."
echo "2. 提交消息: git commit -m '修复Android v2嵌入问题'"
echo "3. 推送到GitHub: git push"
echo ""
echo "🔧 新增的工作流："
echo "- build-apk-simple.yml (最简单版，推荐)"
echo "- build-apk-stable.yml (稳定版)"
echo ""
echo "🚀 建议使用 build-apk-simple.yml 工作流构建"