import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions{
  static FirebaseOptions get currentPlatform{
    return android;
  }
  
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAitQn2jdhi01wTcTWIqUODaa_hogMspBc',
    appId: '1:50370855004:android:a05e5f2ccba3e52dc82699',
    projectId: 'coffee-app-f86a5',
    messagingSenderId: '50370855004',
    storageBucket: 'coffee-app-f86a5.appspot.com'
  );
}