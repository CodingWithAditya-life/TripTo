import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService;

  PaymentProvider({required PaymentService paymentService})
      : _paymentService = paymentService;

  void makePayment({
    required int amount,
    required String name,
    required String contact,
  }) {
    _paymentService.checkOutPayment(amount: amount, name: name, contact: contact);
  }

  // Set payment success callback
  void setOnPaymentSuccess(Function(PaymentSuccessResponse response) onPaymentSuccess) {
    _paymentService.onPaymentSuccess = (response) {
      // Handle payment success
      onPaymentSuccess(response);
      notifyListeners();
    };
  }

  // Set payment error callback
  void setOnPaymentError(Function(PaymentFailureResponse response) onPaymentError) {
    _paymentService.onPaymentError = onPaymentError;
  }

  // Set external wallet callback
  void setOnExternalWallet(Function(ExternalWalletResponse response) onExternalWallet) {
    _paymentService.onExternalWallet = onExternalWallet;
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }
}