 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
 import 'package:tripto/features/authentication/onboarding/tripto_splash.dart';
 import 'package:tripto/firebase_options.dart';
import 'package:tripto/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  Provider.debugCheckInvalidValueType=null;

  // final paymentService = PaymentService();

  runApp( MultiProvider(providers: [
    Provider(create: (context) => AuthController()),
    // Provider<PaymentService>(create: (context) => paymentService),
    // ChangeNotifierProvider<PaymentProvider>(
    //   create: (context) => PaymentProvider(paymentService: paymentService),
    // ),
  ],
  child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return  const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripTo',
       home: TriptoSplash(),
    );
  }
}
