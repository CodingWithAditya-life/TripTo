import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/authentication/onboarding/onboarding.dart';
import 'package:tripto/features/authentication/onboarding/tripto_splash.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';
import 'package:tripto/firebase_options.dart';
import 'package:tripto/utils/theme/theme_data.dart';
import 'package:tripto/utils/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripTo',
      home: TriptoSplash(),
    );
  }
}
