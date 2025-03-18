import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';

import '../../user_profile/verify_name_screen.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<bool> logInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google Sign-In aborted");
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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

      return false;
    }
  }
}
