# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift (sqlite)
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# flutter_local_notifications 使用 GSON
-keep class * extends com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.TypeAdapter { *; }
-keep class * implements com.google.gson.TypeAdapterFactory { *; }
-keep class * implements com.google.gson.JsonSerializer { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }

# Parcelable (Android 序列化)
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Enum (drift 生成)
-keepclassmembers,allowobfuscation enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留行号（崩溃堆栈有用）
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ============================================
# Google Play Core (Flutter PlayStoreSplitApplication / deferred components)
# 工程未启用 Play Store 动态功能模块, 但 Flutter SDK reference 必须保留
# 2026-06-07 R8 release 编不过, 加这批 keep rule
# ============================================
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
