#!/bin/bash

echo "🔥 终极修复Android嵌入问题"
echo "========================"

# 1. 确保AndroidManifest.xml有正确的v2嵌入配置
echo "🔍 检查并修复AndroidManifest.xml..."

# 创建正确的AndroidManifest.xml
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
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
        
        <!-- 关键：必须添加这个以使用Android嵌入v2 -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
EOF

echo "✅ AndroidManifest.xml已修复"

# 2. 确保MainActivity正确
echo "🔍 检查MainActivity..."
cat > android/app/src/main/kotlin/com/example/android_spreadsheet/MainActivity.kt << 'EOF'
package com.example.android_spreadsheet

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF

echo "✅ MainActivity已修复"

# 3. 创建必要的资源文件占位符
echo "📁 创建必要资源文件..."
mkdir -p android/app/src/main/res/values
mkdir -p android/app/src/main/res/drawable

# 创建简单的styles.xml
cat > android/app/src/main/res/values/styles.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
</resources>
EOF

# 创建简单的launch_background.xml
cat > android/app/src/main/res/drawable/launch_background.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />
</layer-list>
EOF

echo "✅ 资源文件已创建"

# 4. 更新build.gradle确保使用正确版本
echo "🔧 更新build.gradle..."
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
    namespace "com.example.android_spreadsheet"
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

echo "✅ build.gradle已更新"

# 5. 创建验证脚本
echo "🔍 创建配置验证脚本..."
cat > verify_config.sh << 'EOF'
#!/bin/bash

echo "🔧 验证配置..."
echo "1. 检查AndroidManifest.xml:"
if grep -q "flutterEmbedding.*value=\"2\"" android/app/src/main/AndroidManifest.xml; then
    echo "   ✅ 有flutterEmbedding v2"
else
    echo "   ❌ 缺少flutterEmbedding v2"
fi

echo "2. 检查MainActivity:"
if [ -f "android/app/src/main/kotlin/com/example/android_spreadsheet/MainActivity.kt" ]; then
    echo "   ✅ MainActivity存在"
else
    echo "   ❌ MainActivity不存在"
fi

echo "3. 检查styles.xml:"
if [ -f "android/app/src/main/res/values/styles.xml" ]; then
    echo "   ✅ styles.xml存在"
else
    echo "   ❌ styles.xml不存在"
fi

echo "4. 检查build.gradle配置:"
if grep -q "minSdkVersion 21" android/app/build.gradle; then
    echo "   ✅ minSdkVersion正确"
else
    echo "   ❌ minSdkVersion不正确"
fi

if grep -q "targetSdkVersion 34" android/app/build.gradle; then
    echo "   ✅ targetSdkVersion正确"
else
    echo "   ❌ targetSdkVersion不正确"
fi
EOF

chmod +x verify_config.sh

echo ""
echo "🎉 终极修复完成！"
echo ""
echo "📝 执行以下命令："
echo "1. git add ."
echo "2. git commit -m '终极修复：添加flutterEmbedding v2配置'"
echo "3. git push"
echo ""
echo "🔍 运行验证脚本：./verify_config.sh"
echo ""
echo "🚀 然后在GitHub Actions中运行 'Build APK (最终版)'"