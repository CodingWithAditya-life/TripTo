import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
}
