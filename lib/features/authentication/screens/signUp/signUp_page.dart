import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/authentication/screens/signUp/verify_otp_page.dart';
import 'package:tripto/provider/auth_provider.dart';


import '../../../../utils/constants/color.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthController>(context,listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Enter Phone number for verification',
                style: TextStyle(fontSize: 27),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "This number will be used for all ride-related communication.You shall receive an SMS with codefor verification",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              const SizedBox(height: 20),
              IntlPhoneField(
                controller: authProvider.numberController,
                flagsButtonPadding: const EdgeInsets.all(8),
                dropdownIconPosition: IconPosition.trailing,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color:Color(0xFF092A54) , width: 2),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.green.withOpacity(0.5)),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.withOpacity(0.8)),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyOtpPage(),));
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  // padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 14),
                  backgroundColor: TripToColor.buttonColors,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                authProvider.logInWithGoogle();
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  backgroundColor: TripToColor.buttonColors,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png',height: 20,width: 20,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Continue with Google',style: TextStyle(fontSize: 15),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
