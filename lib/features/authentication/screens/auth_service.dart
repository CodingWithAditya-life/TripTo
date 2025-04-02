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





      // Future<void> verifyPhoneNumber(String phoneNumber) async {
      //   await _auth.verifyPhoneNumber(
      //     phoneNumber: '+91$phoneNumber',
      //     verificationCompleted: (PhoneAuthCredential credential) async {
      //       await _auth.signInWithCredential(credential);
      //       Fluttertoast.showToast(msg: "Phone Authentication Successful");
      //       Get.offAll(() => const HomeScreen());
      //     },
      //     verificationFailed: (FirebaseAuthException e) {
      //       String errorMessage;
      //       switch (e.code) {
      //         case 'invalid-phone-number':
      //           errorMessage = "The provided phone number is not valid.";
      //           break;
      //         case 'quota-exceeded':
      //           errorMessage = "SMS quota exceeded. Please try again later.";
      //           break;
      //       // Add more cases as needed
      //         default:
      //           errorMessage = "Phone verification failed: ${e.message}";
      //           break;
      //       }
      //       Fluttertoast.showToast(msg: errorMessage);
      //     },
      //     codeSent: (String verificationId, int? resendToken) {
      //       this.verificationId = verificationId;
      //       Get.to(() => VerifyOtpPage(verificationId: verificationId));
      //     },
      //     codeAutoRetrievalTimeout: (String verificationId) {
      //       // Handle timeout
      //     },
      //   );
      // }



        // Future<void> signInWithOTP(String verificationId, String smsCode) async {
        //   try {
        //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //       verificationId: verificationId,
        //       smsCode: smsCode,
        //     );
        //     await _auth.signInWithCredential(credential);
        //     Fluttertoast.showToast(msg: "OTP Verified Successfully");
        //     Get.offAll(() => const HomeScreen());
        //   } on FirebaseAuthException catch (e) {
        //     String errorMessage;
        //     switch (e.code) {
        //       case 'invalid-verification-code':
        //         errorMessage = "The OTP entered is invalid.";
        //         break;
        //       case 'session-expired':
        //         errorMessage = "The OTP has expired. Please request a new one.";
        //         break;
        //     // Add more cases as needed
        //       default:
        //         errorMessage = "OTP verification failed: ${e.message}";
        //         break;
        //     }
        //     Fluttertoast.showToast(msg: errorMessage);
        //   }
        // }




      Future<bool> logInWithGoogle() async {
        try {
          final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            Get.snackbar(
              'Successfully',
              'Google Sign-In aborted',

            );
                // Scaffold.of(context).showSnackBar

            // Fluttertoast.showToast(msg: "Google Sign-In aborted");
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
          Fluttertoast.showToast(msg: 'Google signOut successful');

          return true;
        }
        catch (ex) {
          Fluttertoast.showToast(msg: 'Google signOut failed');

          return false;
        }
      }
    }
