import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/authentication/onboarding/tripto_splash.dart';

import 'package:tripto/features/authentication/screens/home/home_screen.dart';
import 'package:tripto/features/notifications/services/notification_services.dart';

import 'package:tripto/firebase_options.dart';

import 'package:tripto/provider/auth_provider.dart';

import 'features/authentication/screens/home/drawer/home_drawer.dart';
import 'features/user_profile/edit_user_profile.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationServices.initialize();

  Provider.debugCheckInvalidValueType = null;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(MultiProvider(
      providers: [Provider(create: (context) => AuthController())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripTo',
      home: TriptoSplash(),
    );
  }
}
