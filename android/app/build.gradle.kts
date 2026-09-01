import java.util.Properties
import java.io.FileInputStream

// =============================================================================
// STEP 1: Plugins MUST be at the absolute top of the file in Kotlin DSL
// =============================================================================
plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// =============================================================================
// STEP 2: Read local.properties cleanly for API keys
// =============================================================================
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

// =============================================================================
// STEP 3: Android Application Configuration
// =============================================================================
android {
    namespace = "com.example.mvvm_consepts"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // CRITICAL FIX: Tells Gradle to enable desugaring for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.mvvm_consepts"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Correct Kotlin DSL Map placeholder assignment:
        manifestPlaceholders["mapsApiKey"] = localProperties.getProperty("MAPS_API_KEY") ?: ""
    }
}

// =============================================================================
// STEP 4: Global Kotlin Compiler Options
// =============================================================================
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}

// =============================================================================
// STEP 5: Add the actual desugaring library dependency engine
// =============================================================================
dependencies {
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.1.4")
}
