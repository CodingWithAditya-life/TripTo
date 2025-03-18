import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tripto/utils/constants/map_constants.dart';

class LocationServices {

  static Future<Map<String, dynamic>> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true
    );

    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    String address = await getAddressFromLatLng(currentLocation);

    return {
      "latLng": currentLocation,
      "address": address,
    };
  }

  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    final String url =
        "https://maps.gomaps.pro/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${MapConstants.goMapsApiKey}";
    final response = await http.get(Uri.parse(url));

    print("DEBUG API Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["results"].isNotEmpty
          ? data["results"][0]["formatted_address"]
          : "Unknown Location";
    }
    return "Unknown Location";
  }

  // static Future<String> getAddressFromLatLng(LatLng latLng) async {
  //   final String url =
  //       "https://maps.gomaps.pro/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$_apiKey";
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //
  //     if (data["results"].isNotEmpty) {
  //       List addressComponents = data["results"][0]["address_components"];
  //       String formattedAddress = data["results"][0]["formatted_address"];
  //
  //       String city = "";
  //       String state = "";
  //       String country = "";
  //
  //       for (var component in addressComponents) {
  //         List types = component["types"];
  //
  //         if (types.contains("locality")) {
  //           city = component["long_name"];
  //         } else if (types.contains("administrative_area_level_1")) {
  //           state = component["long_name"];
  //         } else if (types.contains("country")) {
  //           country = component["long_name"];
  //         }
  //       }
  //
  //       if (city.isNotEmpty && state.isNotEmpty && country.isNotEmpty) {
  //         return "$city, $state, $country";
  //       }
  //
  //       return formattedAddress;
  //     }
  //   }
  //   return "Unknown Location";
  // }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    String formattedAddress = "$address, Bihar, India";
    final response = await http.get(
      Uri.parse(
          "https://maps.gomaps.pro/maps/api/geocode/json?address=$formattedAddress&key=${MapConstants.goMapsApiKey}"),
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

  static Future<Map<String, dynamic>> getRouteAndDistance(
      LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse(
          "https://maps.gomaps.pro/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=${MapConstants.goMapsApiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
