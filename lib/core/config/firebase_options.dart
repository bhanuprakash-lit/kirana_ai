import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBVEFMToUcFA5Wo--at4sl2U3IBbre2_1Q',
    appId: '1:335112026607:web:4b5e7d383b19c7811ede1a',
    messagingSenderId: '335112026607',
    projectId: 'lit-kirana-ai',
    authDomain: 'lit-kirana-ai.firebaseapp.com',
    storageBucket: 'lit-kirana-ai.firebasestorage.app',
    measurementId: 'G-E430TXLQBR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvdqBDVB6Wso_dX4cdSiQTuSfhWUrBcl0',
    appId: '1:335112026607:android:ac85f16837d83c051ede1a',
    messagingSenderId: '335112026607',
    projectId: 'lit-kirana-ai',
    storageBucket: 'lit-kirana-ai.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAgSidXoybqXuITUCECVpQ6TfGh9FtmfA',
    appId: '1:335112026607:ios:6f8e8fde83cbdcfb1ede1a',
    messagingSenderId: '335112026607',
    projectId: 'lit-kirana-ai',
    storageBucket: 'lit-kirana-ai.firebasestorage.app',
    iosBundleId: 'com.lohiya.kiranaAi',
  );
}
