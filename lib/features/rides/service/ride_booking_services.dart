import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripto/features/rides/models/send_ride_request/send_ride_request.dart';
import 'package:tripto/features/rides/provider/ride_provider.dart';
import 'package:tripto/features/user_profile/model/user_model.dart';
import 'package:tripto/features/user_profile/user_service/user_service.dart';
import 'package:provider/provider.dart';

class RideBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Future<void> bookRide(String rideType, LatLng pickup, LatLng drop) async {
  //   String? userId = _auth.currentUser?.uid;
  //   if (userId == null) {
  //     print("Error: User not logged in.");
  //     return;
  //   }
  //
  //   UserModel? user = await _userService.getUserData(userId);
  //   if (user == null) {
  //     print("Error: User data not found.");
  //     return;
  //   }
  //
  //   QuerySnapshot driversSnapshot = await _firestore
  //       .collection("drivers")
  //       .where("rideType", isEqualTo: rideType)
  //       .where("isAvailable", isEqualTo: true)
  //       .get();
  //
  //   if (driversSnapshot.docs.isEmpty) {
  //     print("No available drivers for this ride type.");
  //     return;
  //   }
  //
  //   var driverData = driversSnapshot.docs.first.data() as Map<String, dynamic>;
  //   String driverId = driverData["id"];
  //   String driverName = driverData["name"];
  //   String driverPhone = driverData["phone"];
  //
  //   RideRequest rideRequest = RideRequest(
  //     id: "",
  //     userId: user.id,
  //     userName: "${user.firstName} ${user.lastName}",
  //     driverId: driverId,
  //     pickupLat: pickup.latitude,
  //     pickupLng: pickup.longitude,
  //     dropLat: drop.latitude,
  //     dropLng: drop.longitude,
  //     status: "pending",
  //     createdAt: Timestamp.now(), vehicleType: '',
  //   );
  //
  //   await _firestore.collection("ride_requests").add(rideRequest.toMap());
  //
  //   print("Ride request sent to driver: $driverName ($driverPhone)");
  // }
}
