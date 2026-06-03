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
