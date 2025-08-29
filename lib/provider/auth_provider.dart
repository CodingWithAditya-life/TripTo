import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';
import 'package:tripto/features/authentication/screens/signUp/verify_otp_page.dart';
import 'package:tripto/features/user_profile/verify_name_screen.dart';
import '../features/authentication/screens/auth_service.dart';

class AuthController extends ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  String _verificationId = "";

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await authService.signOut();
      _isLoggedIn = false;
      Get.offAll(() => const SignUpPage());
    } catch (e) {
      Fluttertoast.showToast(msg: "Logout failed");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendOTP(String phoneNumber, BuildContext context) async {
    _setLoading(true);
    await authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
        _setLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(verificationId: verificationId),
          ),
        );
        Fluttertoast.showToast(msg: "OTP Sent to +91$phoneNumber");
      },
      onFailed: (error) {
        _setLoading(false);
        Fluttertoast.showToast(msg: "Verification Failed: $error");
      },
      onAutoVerified: (credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _isLoggedIn = true;
          _setLoading(false);
          Fluttertoast.showToast(msg: "Auto login success");
          Get.offAll(() => const HomeScreen());
        } catch (e) {
          _setLoading(false);
          Fluttertoast.showToast(msg: "Auto-sign-in failed");
        }
      },
    );
  }

  Future<void> verifyOTP(String otp, BuildContext context, String verificationId) async {
    _setLoading(true);
    try {
      await authService.signInWithOTP(verificationId, otp);
      _isLoggedIn = true;
      Fluttertoast.showToast(msg: "OTP Verified! Logging in...");
      checkAlreadyUserRegistered(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP. Try again.");
    } finally {
      _setLoading(false);
    }
  }
  checkAlreadyUserRegistered(BuildContext context)async{
    var phone = numberController.text.trim();
      var result =await FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: phone).get();
      if(result.docChanges.isEmpty){

        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) =>  const VerifyNameScreen()), (
            route) => false,);
      }else {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()), (
            route) => false,);
      }
  }

}
