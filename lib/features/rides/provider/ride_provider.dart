import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/send_ride_request/send_ride_request.dart';
import '../notifications/services/push_notification.dart';

class RideProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestRide(RideRequest ride) async {
    try {
      DocumentReference rideRef = await _firestore.collection('trip').add(ride.toMap());

      print("Ride request saved in Firestore: ${rideRef.id}");

      List<String> driverTokens = await _getNearbyDrivers(ride.vehicleType);
      print("Found ${driverTokens.length} nearby drivers");

      if (driverTokens.isNotEmpty) {
        for (var token in driverTokens) {
          await PushNotification.sendPushNotification(token, ride);
        }
        print("Ride request notifications sent to drivers.");
      } else {
        print("No available drivers nearby!");
      }
    } catch (e) {
      print("Error booking ride: $e");
    }
  }

  Future<List<String>> _getNearbyDrivers(String vehicleType) async {
    List<String> driverTokens = [];
    try {
      QuerySnapshot driversSnapshot = await _firestore
          .collection("drivers")
          .where("status", isEqualTo: true)
          .where("type", isEqualTo: vehicleType)
          .get();

      for (var doc in driversSnapshot.docs) {
        String? token = doc["driver_id_token"];
        if (token != null && token.isNotEmpty) {
          driverTokens.add(token);
        }
      }
    } catch (e) {
      print("Error fetching nearby drivers: $e");
    }
    return driverTokens;
  }
}
