import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RideHistoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _rides = [];
  bool _isLoading = true;
  String _errorMessage = '';

  List<Map<String, dynamic>> get rides => _rides;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  RideHistoryProvider() {
    fetchRideHistory();
  }

  Future<void> fetchRideHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trip')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      _rides = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // ✅ Ensure 'createdAt' is properly handled
        if (data.containsKey('createdAt') && data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }

        return data;
      }).toList();

      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
