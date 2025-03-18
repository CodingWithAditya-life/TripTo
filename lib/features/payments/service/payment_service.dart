import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay razorpay;

  Function(PaymentSuccessResponse response)? onPaymentSuccess;
  Function(PaymentFailureResponse response)? onPaymentError;
  Function(ExternalWalletResponse response)? onExternalWallet;

  PaymentService(
      {this.onPaymentSuccess, this.onPaymentError, this.onExternalWallet})
  {
    razorpay=Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handelPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalError);
  }

  void checkOutPayment({
  required int amount,
    required String name,
    required String contact
}) {

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

  void _handelPaymentSuccess(PaymentSuccessResponse response){
    if(onPaymentSuccess!=null){
      onPaymentSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response){
    if(onPaymentError!=null){
      onPaymentError!(response);
    }
  }

  void _handleExternalError(ExternalWalletResponse response){
    if(onExternalWallet!=null){
      onExternalWallet!(response);
    }
  }
  void dispose(){
    razorpay.clear();
  }

}