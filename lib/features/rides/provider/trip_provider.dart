import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/active_drivers.dart';

Future<List<ActiveModel>> getActiveDriverOnce(String selectVehicleDrivers) async {
  List<ActiveModel> drivers = [];
  try {
    final snapshot = await FirebaseDatabase.instance.ref('activeDriver').get();

    if (snapshot.value == null) {
      Fluttertoast.showToast(msg: 'No active drivers found');
      return [];
    }

    if (snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));

      print("All Data: $data");

      for (var entry in data.values) {
        try {
          var driverData = ActiveModel.fromJson(entry as Map<String, dynamic>);
          if (driverData.driver != null &&
              driverData.driver!.vehicle != null &&
              driverData.driver!.vehicle!.isOnline == true &&
              driverData.driver!.vehicle!.type?.toLowerCase() == selectVehicleDrivers.toLowerCase()) {

            print("Matched Online Driver: ${driverData.driver!.fullName}");
            drivers.add(driverData);
          }
        } catch (e) {
          print("Error parsing ActiveModel: $e");
        }
      }
    } else {
      print("Unexpected Data Format: ${snapshot.value}");
    }
  } catch (e) {
    print("Error fetching active drivers: $e");
  }
  return drivers;
}

