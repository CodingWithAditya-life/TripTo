import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationServices {
  static const String _apiKey = "AlzaSyUUs6EPVHuIaK-6ooq_Ev9fky9DkGtxqFe";

  static Future<LatLng> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    String formattedAddress = "$address, Bihar, India";
    final response = await http.get(
      Uri.parse("https://maps.gomaps.pro/maps/api/geocode/json?address=$formattedAddress&key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["results"].isNotEmpty) {
        final location = data["results"][0]["geometry"]["location"];
        return LatLng(location["lat"], location["lng"]);
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>> getRouteAndDistance(LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse("https://maps.gomaps.pro/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["routes"].isNotEmpty) {
        return {
          "distance": data["routes"][0]["legs"][0]["distance"]["text"],
          "duration": data["routes"][0]["legs"][0]["duration"]["text"],
          "polyline": decodePolyline(data["routes"][0]["overview_polyline"]["points"]),
        };
      }
    }
    return {};
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decoded = polylinePoints.decodePolyline(encoded);
    for (var point in decoded) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    return points;
  }
}
