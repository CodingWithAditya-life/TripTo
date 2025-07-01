import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../payment_service.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService;
  SavePaymentService paymentService = SavePaymentService();

  PaymentProvider({required PaymentService paymentService})
      : _paymentService = paymentService;

  void makePayment({
    required int amount,
    required String name,
    required String userName,
    required String driverName,
    required String contact,
    required String dropLocation,
    required String userId,
  }) {
    _paymentService.checkOutPayment(
      amount: amount,
      name: name,
      contact: contact,
      userId: userId,
      userName: userName,
      driverName: driverName,
      dropLocation: dropLocation,
    );
  }

  void setOnPaymentSuccess(Function(PaymentSuccessResponse response) onPaymentSuccess) {
    _paymentService.onPaymentSuccess = (response) {
      onPaymentSuccess(response);
      notifyListeners();
    };
  }

  void setOnPaymentError(Function(PaymentFailureResponse response) onPaymentError) {
    _paymentService.onPaymentError = onPaymentError;
  }

  void setOnExternalWallet(Function(ExternalWalletResponse response) onExternalWallet) {
    _paymentService.onExternalWallet = onExternalWallet;
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
    }
}