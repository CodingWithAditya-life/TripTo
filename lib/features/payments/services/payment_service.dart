import 'package:cloud_firestore/cloud_firestore.dart';

class SavePaymentService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePaymentStatus({
    required String userId,
    required String userName,
    required String driverName,
    required int amount,
    required String dropLocation,
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
        'dropLocation': dropLocation,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(), // ✅ Timestamp added
      });

      print("✅ Firestore Save Successful!");
    } catch (ex) {
      print("❌ Firestore Payment Error: $ex");
    }
    }
}
