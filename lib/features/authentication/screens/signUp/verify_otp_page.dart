import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/constants/color.dart';
import '../../../user_profile/verify_name_screen.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController pinputController = TextEditingController();

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
                            color: TripToColor.buttonColors, width: 2))),
              ),
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
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),)
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifyNameScreen(),
                        ));
                  },
                  child: const Text('Verify OTP')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn`t receive an OTP ? "),
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
