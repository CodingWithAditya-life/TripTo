import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripto/features/maps/services/location_service.dart';

class MapScreen extends StatefulWidget {
  final String pickUpLocation;
  final String dropLocation;

  const MapScreen({super.key, required this.pickUpLocation, required this.dropLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? pickUpLatLng;
  LatLng? dropLatLng;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String distanceText = "";
  String durationText = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setPickupAndDrop();
  }

  Future<void> _setPickupAndDrop() async {
    LatLng? pickup = await LocationServices.getLatLngFromAddress(widget.pickUpLocation);
    LatLng? drop = await LocationServices.getLatLngFromAddress(widget.dropLocation);
    print("DEBUG: Pickup Location - ${pickup?.latitude}, ${pickup?.longitude}");
    print("DEBUG: Drop Location - ${drop?.latitude}, ${drop?.longitude}");

    if (pickup == null || drop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid pickup or drop location")),
      );
      return;
    }

    setState(() {
      pickUpLatLng = pickup;
      dropLatLng = drop;
      isLoading = false;

      markers.add(Marker(
          markerId: MarkerId("pickup"),
          position: pickup,
          infoWindow: InfoWindow(title: "Pickup Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));

      markers.add(Marker(
          markerId: MarkerId("drop"),
          position: drop,
          infoWindow: InfoWindow(title: "Drop Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    });

    _calculateDistanceAndRoute();
  }

  Future<void> _calculateDistanceAndRoute() async {
    if (pickUpLatLng == null || dropLatLng == null) return;

    final result = await LocationServices.getRouteAndDistance(pickUpLatLng!, dropLatLng!);

    if (result.isNotEmpty) {
      setState(() {
        distanceText = result["distance"];
        durationText = result["duration"];
        polylines.clear();
        polylines.add(Polyline(
          polylineId: PolylineId("route"),
          points: result["polyline"],
          width: 5,
          color: Colors.blue,
        ));
      });

      mapController?.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: pickUpLatLng!, northeast: dropLatLng!),
        100,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pickUpLatLng ?? LatLng(28.7041, 77.1025),
              zoom: 10,
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: markers,
            polylines: polylines,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (distanceText.isNotEmpty && durationText.isNotEmpty)
                    Text(
                      "Distance: $distanceText, ETA: $durationText",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
