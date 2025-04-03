import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tripto/features/payments/service/save_payment_status.dart';
import 'payment_service.dart';

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
    required String userId,

  }) {
    _paymentService.checkOutPayment(
      amount: amount,
      name: name,
      contact: contact,
      userId: userId,
      userName: userName,
      driverName: driverName,
    );
  }

  // Set payment success callback
  void setOnPaymentSuccess(
    Function(PaymentSuccessResponse response) onPaymentSuccess,
  ) {
    _paymentService.onPaymentSuccess = (response) {
      onPaymentSuccess(response);
      notifyListeners();
    };
  }

  // Set payment error callback
  void setOnPaymentError(
    Function(PaymentFailureResponse response) onPaymentError,
  ) {
    _paymentService.onPaymentError = onPaymentError;
  }

  // Set external wallet callback
  void setOnExternalWallet(
    Function(ExternalWalletResponse response) onExternalWallet,
  ) {
    _paymentService.onExternalWallet = onExternalWallet;
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }
}
