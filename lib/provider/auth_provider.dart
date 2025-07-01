import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';
import 'package:tripto/features/authentication/screens/signUp/verify_otp_page.dart';
import '../features/authentication/screens/auth_service.dart';

class AuthController extends ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  late String _verificationId;

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      bool googleSignOut = await authService.signOut();
      if (googleSignOut) {
        _isLoggedIn = false;
        Get.offAll(() => const SignUpPage());
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Error: $ex');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

    Future<void> sendOTP(String phoneNumber, BuildContext context) async {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: "+91${phoneNumber}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await _auth.signInWithCredential(credential);
              _isLoggedIn = true;
              notifyListeners();
            } catch (e) {
              debugPrint("Auto-sign-in failed: $e");
              Fluttertoast.showToast(msg:"Auto-sign-in failed. Try manually.",);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            debugPrint("Verification Failed: ${e.message}");
            Fluttertoast.showToast(msg:  "Verification Failed: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpPage(verificationId: verificationId),));
            Fluttertoast.showToast(msg: "OTP Sent to +91$phoneNumber");
            notifyListeners();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
            Fluttertoast.showToast(msg: "OTP Expired. Request a new one.");
          },
          timeout: const Duration(seconds: 60),
        );
      } catch (e) {
        debugPrint("OTP Error: $e");
        Fluttertoast.showToast( msg: "Error sending OTP. Try again.");
      }
    }

  Future<void> verifyOTP(String otp, BuildContext context, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      _isLoggedIn = true;
      notifyListeners();

      // ✅ OTP Verified - Navigate to Home Page
      Fluttertoast.showToast(msg: "OTP Verified! Logging in...");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } catch (e) {
      debugPrint("OTP Verification Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

}
