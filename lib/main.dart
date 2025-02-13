import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripto/features/home/home_screen.dart';
import 'package:tripto/firebase_options.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
