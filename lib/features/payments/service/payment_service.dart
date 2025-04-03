import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tripto/features/payments/service/save_payment_status.dart';

class PaymentService {
  late Razorpay razorpay;
  SavePaymentService paymentService=SavePaymentService();
  Function(PaymentSuccessResponse response)? onPaymentSuccess;
  Function(PaymentFailureResponse response)? onPaymentError;
  Function(ExternalWalletResponse response)? onExternalWallet;
  int _amount = 0;
  String _userId = "";
  String _userName = "";
  String _driverName = "";
  PaymentService(
      {this.onPaymentSuccess, this.onPaymentError, this.onExternalWallet}) {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handelPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalError);
  }

  void checkOutPayment({
    required int amount,
    required String name,
    required String userName,
    required String driverName,
    required String contact,
    required String userId
  })
  {
    _amount = amount;
    _userId = userId;
    _userName = userName;
    _driverName = userId;
    var options = {
      "key": "rzp_test_xIt454xKRLsm0C",
      "amount": (amount * 100).toInt(),
      "name": "Tripto Cab",
      "description": "Cab Fare Payment",
      "prefill": {
        "contact": contact,
        "name": name
      },
      "theme": {
        "color": "#3399cc"
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handelPaymentSuccess(PaymentSuccessResponse response) {
    print("🟢 Payment Success Callback Called!");
    print("🔥 Firestore Save Function Called!");

    if (onPaymentSuccess != null) {
      onPaymentSuccess!(response);

      print("🟢 Calling savePaymentStatus()");
      paymentService.savePaymentStatus(
        userId: _userId,
        amount: _amount,
        status: 'Success',
        userName: _userName,
        driverName: _driverName,
      );
    }
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    if (onPaymentError != null) {
      onPaymentError!(response);
      paymentService.savePaymentStatus(
          userId: _userId,
          amount: _amount,
          status: 'Failed',
          userName: _userName,
          driverName: _driverName);
    }
  }

  void _handleExternalError(ExternalWalletResponse response) {
    if (onExternalWallet != null) {
      onExternalWallet!(response);
    }
  }

  void dispose() {
    razorpay.clear();
  }

}