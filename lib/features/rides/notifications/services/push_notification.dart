import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tripto/features/rides/models/send_ride_request/send_ride_request.dart';
import '../get_server_token/get_server_token.dart';

class PushNotification {
  static sendPushNotification(
      String fcmToken, RideRequest ride) async {
    String serverToken = await GetServerToken().getServerToken();

    var headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverToken',
    };

    Map bodyNotification = {
      "body": "From ${ride!.pickupLat},${ride.pickupLng} To\n ${ride.dropLat},${ride.dropLng}",
      "title": "New Ride Request From ${ride.userName}",
      "sound": "default"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "status": "pending",
      "userName": ride.userName,
      "pickupLat": ride.pickupLat,
      "pickupLng": ride.pickupLng,
      "dropLat": ride.dropLat,
      "dropLng":ride.dropLng
    };

    Map<String, dynamic> officialNotification = {
      "message": {
        "token": fcmToken,
        "notification": bodyNotification,
        "data": dataMap,
        "priority": "high",
      }
    };

    var response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/fir-apptest-c3e4e/messages:send'),
      headers: headerNotification,
      body: jsonEncode(officialNotification),
    );

    if(response.statusCode == 200){
      print("Send Notification successfully");
    }
  }
}
