import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RideHistoryProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _rideHistory = [];

  List<Map<String, dynamic>> get rideHistory => _rideHistory;

  final String googleApiKey = "AlzaSy3usMkNPy5i3tMvVqEXOpdBrG1-G_70Brw";

  Future<void> getRideHistory(String userId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('trip')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _rideHistory = await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> tripData = doc.data() as Map<String, dynamic>;

        String pickupAddress = await getAddressFromLatLng(
            tripData['pickupLat'], tripData['pickupLng']);
        String dropAddress = await getAddressFromLatLng(
            tripData['dropLat'], tripData['dropLng']);

        return {
          'id': doc.id,
          'pickupAddress': pickupAddress,
          'dropAddress': dropAddress,
          ...tripData,
        };
      }));

      notifyListeners();
    } catch (e) {
      print("Error fetching ride history: $e");
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      } else {
        return "Unknown Address";
      }
    } else {
      return "Error Fetching Address";
    }
  }
}
