# Flutter 混淆规则

# 保留 Flutter 主类
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 保留 Dart 相关类
-keep class **.R { *; }
-keep class **.R$* { *; }

# 保留注解
-keepattributes *Annotation*

# 保留序列化相关
-keepattributes Signature
-keepattributes EnclosingMethod

# 保留资源
-keepclassmembers class **.R$* {
    public static <fields>;
}

# 保留所有实现了 Parcelable 的类
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# 保留所有本地方法
-keepclasseswithmembernames class * {
    native <methods>;
}

# 保留自定义 View
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(***);
}

# 保留 Activity 中的方法
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

# 保留枚举
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}