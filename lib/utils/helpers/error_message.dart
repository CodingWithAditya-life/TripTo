// import 'package:flutter/material.dart';
//
// void errorMessageSnack(BuildContext context, String error){
//
//   ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: TextCustom(text: error, color: Colors.white),
//           backgroundColor: Colors.red
//       )
//   );
//
// }

import 'package:aws_client/app_test_2022_12_06.dart';

class EmailValidator {
  static bool validate(String email) {
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    ).hasMatch(email);
    return emailValid;
  }
}

