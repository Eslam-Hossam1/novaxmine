plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")

}

android {
    signingConfigs {
        create("release") {
            storeFile = file("D:\\SourceCodeFlutter\\codecanyonSouces\\mySell\\novaxmine\\key-nov")
            storePassword = "00123Nn"
            keyPassword = "00123Nn"
            keyAlias = "nov"
        }
    }
    namespace = "dev.novaxmine.app"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = "27.1.12297006" // اختياري لكن مفيد لو عندك تضارب NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // دي المهمة:
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.novaxmine.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
