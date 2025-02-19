import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tripto/features/authentication/screens/auth_service.dart';
import 'package:tripto/features/authentication/screens/home/home_screen.dart';

import '../features/authentication/onboarding/onboarding.dart';

class AuthController extends ChangeNotifier{
    TextEditingController numberController = TextEditingController();
    AuthService authService = AuthService();

    Future<void> logInWithGoogle(BuildContext context) async{
        var isLoading = true;

        try{
            notifyListeners();
            var login=await authService.logInWithGoogle();
            if(login == true){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                    ));
            }

        }catch(ex){
            Fluttertoast.showToast(msg: '$ex');
        }finally{
            isLoading = false;
            notifyListeners();
        }

    }

}