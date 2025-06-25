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
        return windows;
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
    apiKey: 'AIzaSyC94pP6Zfid7mGjoXxQZp4QiiGk3c-sK9o',
    appId: '1:792466043013:web:49ceeec382703d065339ec',
    messagingSenderId: '792466043013',
    projectId: 'fir-apptest-c3e4e',
    authDomain: 'fir-apptest-c3e4e.firebaseapp.com',
    databaseURL: 'https://fir-apptest-c3e4e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fir-apptest-c3e4e.appspot.com',
    measurementId: 'G-P16VRNW8KV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZOGcSYysxq3goKm5Fo_9oTaMBGa1NcRM',
    appId: '1:792466043013:android:55c221815df642f45339ec',
    messagingSenderId: '792466043013',
    projectId: 'fir-apptest-c3e4e',
    databaseURL: 'https://fir-apptest-c3e4e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fir-apptest-c3e4e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDr8kr0wqxHg8PI3kpqwFSiPs6GRw7sHiA',
    appId: '1:792466043013:ios:3927604b3d2be39f5339ec',
    messagingSenderId: '792466043013',
    projectId: 'fir-apptest-c3e4e',
    databaseURL: 'https://fir-apptest-c3e4e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fir-apptest-c3e4e.appspot.com',
    androidClientId: '792466043013-0fgnsalsb4po7n490n9ovq46abqb9080.apps.googleusercontent.com',
    iosClientId: '792466043013-tsn8tndqted4692tcf0c51gnb94ak3l4.apps.googleusercontent.com',
    iosBundleId: 'com.ontrip.tripto',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC94pP6Zfid7mGjoXxQZp4QiiGk3c-sK9o',
    appId: '1:792466043013:web:8e392762fd8b9fcd5339ec',
    messagingSenderId: '792466043013',
    projectId: 'fir-apptest-c3e4e',
    authDomain: 'fir-apptest-c3e4e.firebaseapp.com',
    databaseURL: 'https://fir-apptest-c3e4e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fir-apptest-c3e4e.appspot.com',
    measurementId: 'G-CMSN095ERJ',
  );
}