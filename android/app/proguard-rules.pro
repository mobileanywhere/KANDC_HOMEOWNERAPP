# Flutter & Dart
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Gson / Serialization (if used)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Reflection-based classes (adjust if needed)
-keep class * implements android.os.Parcelable { *; }

# Prevent stripping used resources
-keep class * extends java.lang.annotation.Annotation { *; }

# Retrofit, OkHttp, Moshi, etc. (if used)
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

# Kotlin metadata
-keep class kotlin.Metadata
