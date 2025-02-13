import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripto/features/authentication/home/home_page.dart';
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
      home: HomePage(),
    );
  }
}
