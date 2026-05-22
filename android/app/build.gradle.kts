import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lohiya.kirana_ai"
    compileSdk = 36  // Android 15 — required for 16 KB page size compliance (Google Play Nov 2025)
    ndkVersion = flutter.ndkVersion  // Flutter 3.27+ sets this to NDK r27 which supports 16 KB alignment

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.lohiya.kirana_ai"
        minSdk = flutter.minSdkVersion
        targetSdk = 36  // Android 15 — required for 16 KB page size compliance (Google Play Nov 2025)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Release signing — only created when key.properties is present.
    // CI runners and fresh dev clones don't have the keystore; without this
    // guard Gradle fails configuration ("null cannot be cast to non-null
    // type kotlin.String") even for debug builds.
    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    // 16 KB page size — store native libs uncompressed so the OS can map them
    // directly from the AAB/APK with correct alignment
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    buildTypes {
        release {
            // Use the release key when configured; otherwise fall back to debug
            // signing so the project still configures without a keystore. Real
            // release builds without key.properties will be debug-signed —
            // intentional, so unsigned APKs are obvious in QA.
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}