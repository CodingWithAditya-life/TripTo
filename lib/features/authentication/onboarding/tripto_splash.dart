import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/authentication/onboarding/onboarding.dart';

import '../screens/home/home_screen.dart';

class TriptoSplash extends StatefulWidget {
  const TriptoSplash({super.key});

  @override
  State<TriptoSplash> createState() => _TriptoSplashState();
}

class _TriptoSplashState extends State<TriptoSplash> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body:SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tripto',style: GoogleFonts.montserrat(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          letterSpacing: 4.0,
          color: Colors.black,
        ),),
            Center(
              child: Image.asset("assets/images/triotoSplash.jpg"), // Your splash image
            ),
          ],
        ),
      )
    );
  }
}
