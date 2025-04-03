import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequest {
  String id;
  String userId;
  String userName;
  double pickupLat;
  double pickupLng;
  double dropLat;
  double dropLng;
  String pickUpAddress;
  String dropAddress;
  String status;
  Timestamp createdAt;
  String vehicleType;
  String? driverId;
  String? fcmToken;
  String? driverName;
  String? tripId;

  RideRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickUpAddress,
    required this.dropAddress,
    required this.status,
    required this.createdAt,
    required this.vehicleType,
    this.driverId,
    this.fcmToken,
    this.driverName,
    this.tripId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'pickUpAddress':pickUpAddress,
      'dropAddress': dropAddress,
      'status': status,
      'createdAt': createdAt,
      'type': vehicleType,
      'driverID': driverId,
      'fcmToken': fcmToken,
      'driverName': driverName
    };
  }

  factory RideRequest.fromMap(Map<String, dynamic> map, String docId) {
    return RideRequest(
      id: docId,
      userId: map['userId'],
      userName: map['userName'],
      pickupLat: map['pickupLat'],
      pickupLng: map['pickupLng'],
      dropLat: map['dropLat'],
      dropLng: map['dropLng'],
      pickUpAddress: map['pickUpAddress'],
      dropAddress: map['dropAddress'],
      status: map['status'],
      createdAt: map['createdAt'],
      vehicleType: map['type'],
      driverId: map['driverID'],
      fcmToken: map['fcmToken'],
      driverName: map['driverName'],
    );
  }
}
