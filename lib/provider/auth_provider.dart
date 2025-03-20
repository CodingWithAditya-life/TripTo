import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';
import '../features/authentication/screens/auth_service.dart';

class AuthController extends ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;

  Future<void> signOut() async{
    isLoading = true;
    notifyListeners();

    try{
      bool googleSignout = await authService.signOut();
      if(googleSignout){
        Get.offAll(() => const SignUpPage());
      }
    }catch(ex){
      Fluttertoast.showToast(msg: '$ex');
    }
  }
import 'package:tripto/features/authentication/screens/signUp/verify_otp_page.dart';

import '../features/authentication/screens/auth_service.dart';
import '../features/authentication/screens/home/home_screen.dart';

class AuthController extends ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  TextEditingController pinPutController = TextEditingController();

  AuthService authService = AuthService();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  Future<void> signInWithPhoneNumber() async {
    String phoneNumber = '+91${numberController.text}';
    isLoading = true;
    notifyListeners();

    await authService.sendOtp(phoneNumber, (verificationId) {
      Get.to(() => const VerifyOtpPage());
    });

    isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOtp(String verificationId) async {
    String otp = pinPutController.text;
    isLoading = true;
    notifyListeners();

    bool success = await authService.verifyOtp(otp);
    if (success) {
      Get.to(() => const HomeScreen());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      bool login = await authService.signInWithGoogle();
      if (login) {
        Get.to(() => const HomeScreen());
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: '$ex');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      bool googleSignOut = await authService.signOut();
      if (googleSignOut) {
        Get.to(() => const SignUpPage());
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: '$ex');
    }
  }

}
