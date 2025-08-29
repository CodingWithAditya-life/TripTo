import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../utils/constants/color.dart';

class VerifyOtpPage extends StatefulWidget {
  final String verificationId;
  const VerifyOtpPage({super.key, required this.verificationId});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late final String verificationId;

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
  }

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final authProvider = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('Verify your number',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Please enter the verification code we sent to your mobile number.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TripToColor.buttonColors, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () => authProvider.verifyOTP(
                  otpController.text.trim(),
                  context,
                  verificationId,
                ),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                    backgroundColor: TripToColor.buttonColors),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
