// settings.gradle.kts

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("org.jetbrains.kotlin.android") version "2.0.0" apply false
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false // Make sure this AGP version is compatible with your Gradle version
    id("com.google.gms.google-services") version "4.4.2" apply false
    // --- ADD THIS LINE ---
    id("com.google.firebase.crashlytics") version "3.0.1" apply false // Use the latest compatible version
    // ---------------------
}

include(":app")