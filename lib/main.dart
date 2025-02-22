import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/authentication/onboarding/tripto_splash.dart';
import 'package:tripto/firebase_options.dart';

import 'package:tripto/provider/auth_provider.dart';

import 'features/authentication/screens/home/drawer/home_drawer.dart';
import 'features/user_profile/edit_user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Provider.debugCheckInvalidValueType=null;
  runApp( MultiProvider(providers: [Provider(create: (context) => AuthController())],
  child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripTo',
       home: TriptoSplash(),
    );
  }
}
