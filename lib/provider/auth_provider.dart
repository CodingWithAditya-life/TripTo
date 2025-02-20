import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';

import '../features/authentication/screens/auth_service.dart';
import '../features/authentication/screens/home/home_screen.dart';

class AuthController extends ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;

  Future<void> logInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      bool login = await authService.logInWithGoogle();
      if (login) {
        Get.to(() => const HomeScreen());  // Replaces the login screen
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: '$ex');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async{
    isLoading = true;
    notifyListeners();

    try{
      bool googleSignout = await authService.signOut();
      if(googleSignout){
        Get.to(() => SignUpPage());
      }
    }catch(ex){
      Fluttertoast.showToast(msg: '$ex');
    }
  }
}
