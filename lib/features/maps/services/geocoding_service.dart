import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static Future<String> getAddressFromLatLng(LatLng position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return "${placeMarks.first.street}, ${placeMarks.first.locality}, ${placeMarks.first.country}";
  }
}
