import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure Provider is imported
import 'package:pinput/pinput.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../utils/constants/color.dart';

class VerifyOtpPage extends StatefulWidget {
  final String verificationId;

  const VerifyOtpPage({super.key, required this.verificationId});  // Constructor

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late final String verificationId;

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId; // Initialize verificationId
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pinputController = TextEditingController();
    var authProvider = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Verify your number',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8),
                child: Text(
                  'Please enter the verification code we sent to your mobile number.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                  controller: pinputController,
                  mainAxisAlignment: MainAxisAlignment.center,
                  length: 6,
                  defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle:
                      const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: TripToColor.buttonColors, width: 2)))),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                      foregroundColor: Colors.white,
                      backgroundColor: TripToColor.buttonColors),
                  onPressed: () {
                    // Pass verificationId to verifyOTP method
                    authProvider.verifyOTP(pinputController.text, context, verificationId);
                  },
                  child: const Text('Verify OTP')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive an OTP? "),
                  Text(
                    "Resend OTP",
                    style: TextStyle(
                        color: TripToColor.textColors,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
