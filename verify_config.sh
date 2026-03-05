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
