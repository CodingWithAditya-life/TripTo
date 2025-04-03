import 'package:cloud_firestore/cloud_firestore.dart';

class SavePaymentService{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<void> savePaymentStatus({
    required String userId,
    required String userName,
    required String driverName,
    required int amount,
    required String status,
  }) async {
    try {
      print("🔥 Firestore Save Function Called!");
      print("🔥 Saving userId: $userId, amount: $amount, status: $status");

      await _firestore.collection('payment').add({
        'userId': userId,
        'amount': amount,
        'userName': userName,
        'driverName': driverName,
        'status': status,
        'createdAt': Timestamp.now(),
      });

      print("✅ Firestore Save Successful!");
    } catch (ex) {
      print("❌ Firestore Payment Error: $ex");
    }
  }


}