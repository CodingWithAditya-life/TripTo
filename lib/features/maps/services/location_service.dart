import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tripto/utils/constants/map_constants.dart';

class LocationServices {
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

  static double getDistanceBetween(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    print("Fetching LatLng for: $address");

    final response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${MapConstants.googleApiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Geocode API Response: $data");

      if (data["results"].isNotEmpty) {
        final location = data["results"][0]["geometry"]["location"];
        return LatLng(location["lat"], location["lng"]);
      }
    }
    return null;
  }

  static Future<double> getEstimatedTime(LatLng start, LatLng end) async {
    double distance = getDistanceBetween(start, end);
    double speed = 40 * 1000 / 60; // 40 km/h average speed in meters per minute
    return distance / speed;
  }

  static Future<String> getAddressFromLatLng(LatLng position) async {
    final response = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?"
          "latlng=${position.latitude},${position.longitude}&key=${MapConstants.googleApiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      }
    }
    return "Address not found";
  }

  static Future<List<LatLng>> getRoutePolyline(LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/directions/json?"
          "origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}"
          "&mode=driving&key=${MapConstants.googleApiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<LatLng> polylineCoordinates = [];
      if (data["routes"].isNotEmpty) {
        String encodedPolyline =
            data["routes"][0]["overview_polyline"]["points"];
        polylineCoordinates = decodePolyline(encodedPolyline);
      }
      return polylineCoordinates;
    }
    return [];
  }

  static Future<Map<String, dynamic>> getRouteAndDistance(
      LatLng start, LatLng end) async {
    print(
        "Fetching Route between: ${start.latitude}, ${start.longitude} → ${end.latitude}, ${end.longitude}");

    final response = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/directions/json?"
          "origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}"
          "&mode=driving&key=${MapConstants.googleApiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Directions API Response: $data");

      if (data["routes"].isNotEmpty) {
        return {
          "distance": data["routes"][0]["legs"][0]["distance"]["text"],
          "duration": data["routes"][0]["legs"][0]["duration"]["text"],
          "polyline":
              decodePolyline(data["routes"][0]["overview_polyline"]["points"]),
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
