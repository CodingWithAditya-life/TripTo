import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<bool?> logInWithGoogle() async {
    Completer<bool?> completer = Completer<bool?>();
    try {
      final googleUser = await GoogleSignIn().signIn();
      if(googleUser != null){
        final googleAuth = await googleUser.authentication;
        final cred = await GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
         await _auth.signInWithCredential(cred);
        Fluttertoast.showToast(msg: "Google_Sign_in successfully");

     completer.complete(true);
      }
      else{
       Fluttertoast.showToast(msg: "Google_Sign_in aborted");
       completer.complete(false);
      }

    } catch (ex) {
      print(ex.toString());
      completer.complete(false);
    }
    return completer.future;
  }


}
