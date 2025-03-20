import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/send_ride_request/send_ride_request.dart';

class RideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> requestRide(RideRequest ride) async {
    try {
      DocumentReference docRef = await _firestore.collection('rides').add(ride.toMap());
      return docRef.id;
    } catch (e) {
      print("Error booking ride: $e");
      return "";
    }
  }

  Future<List<String>> getNearbyDrivers() async {
    try {
      QuerySnapshot driversSnapshot = await _firestore.collection('drivers').get();
      List<String> driverTokens = driversSnapshot.docs
          .map((doc) => doc["fcmToken"] as String)
          .toList();
      return driverTokens;
    } catch (e) {
      print("Error getting drivers: $e");
      return [];
    }
  }
}
