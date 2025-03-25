import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RideHistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _rideHistory = [];

  List<Map<String, dynamic>> get rideHistory => _rideHistory;

  Future<void> getRideHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("rideHistory")
          .where("userId", isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .get();

      _rideHistory = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching ride history: $e");
    }
  }
}
