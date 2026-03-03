// lib/firebase_options.dart
// COPYRIGHT 2026 Google LLC. All Rights Reserved.
//
// This file is a placeholder. 
// Ideally, you should run `flutterfire configure` to generate this file tailored to your project.
// 
// For this base model to work, you MUST:
// 1. Setup Firebase in the console.
// 2. Download google-services.json (for Android) and place it in android/app/
// 3. Run `flutterfire configure` OR replace this class with the generated one.
//
// If you cannot run flutterfire, you can manually configure Firebase.initialize() in main.dart
// but using the generated options is best practice.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // REPLACE WITH YOUR ANDROID VALUES FROM FIREBASE CONSOLE
        return const FirebaseOptions(
          apiKey: 'AIzaSy...', // paste your API key
          appId: '1:123456789:android:123456789', // paste your App ID
          messagingSenderId: '123456789', // paste your Sender ID
          projectId: 'vidyasarathi-app', // paste your Project ID
          storageBucket: 'vidyasarathi-app.appspot.com', // paste your Storage Bucket
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
