import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

Future<Map<String, String>> getDistanceBetweenPickUpAndDrop(
    LatLng startTrip,
    LatLng dropTrip,
    ) async {
  final result = await LocationServices.getRouteAndDistance(
    startTrip,
    dropTrip,
  );

  if (result.isNotEmpty) {
    return {"distance": result["distance"], "duration": result["duration"]};
  } else {
    return {"distance": "Unknown", "duration": "Unknown"};
  }
}

