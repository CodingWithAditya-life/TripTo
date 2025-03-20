import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';

import '../../user_profile/verify_name_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<bool> logInWithGoogle() async {
  String? verificationId;

  Future<void> sendOtp(String phoneNumber, Function onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: "Phone number verified automatically");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          Fluttertoast.showToast(msg: "Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          this.verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending OTP: $e");
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      if (verificationId == null) {
        Fluttertoast.showToast(msg: "No verification ID found");
        return false;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "OTP verified successfully");
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "OTP verification failed:");
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google Sign-In aborted");
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      Fluttertoast.showToast(msg: "Google Sign-In successful");

      if (user != null) {
        DocumentSnapshot userData = await fireStore.collection("users").doc(user.uid).get();
        if (userData.exists) {
          Get.offAll(()=>const HomeScreen());
        }else{
          Get.offAll(() => VerifyNameScreen(email: user.email ?? ""));
        }
      }


      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "Google Sign-In successful");
      return true;
    } catch (ex) {
      print(ex.toString());
      Fluttertoast.showToast(msg: "Error: $ex");
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'Google signout successful');

      return true;
    }
    catch (ex) {
      Fluttertoast.showToast(msg: 'Google signout failed');

      Fluttertoast.showToast(msg: 'Google sign out successful');

      return true;
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Google sign out failed');
      return false;
    }
  }
}
