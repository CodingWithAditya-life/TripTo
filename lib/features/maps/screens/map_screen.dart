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
  bool isLoading = true; // For showing loader before loading map
  MapType _currentMapType = MapType.normal;

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
        const SnackBar(content: Text("Invalid pickup or drop location")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      pickUpLatLng = pickup;
      dropLatLng = drop;
      isLoading = false;

      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: pickup,
        infoWindow: const InfoWindow(title: "Pickup Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      markers.add(Marker(
        markerId: const MarkerId("drop"),
        position: drop,
        infoWindow: const InfoWindow(title: "Drop Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
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
          polylineId: const PolylineId("route"),
          points: result["polyline"],
          width: 5,
          color: Colors.blue,
        ));
      });

      _moveCameraToRoute();
    }
  }

  void _moveCameraToRoute() {
    if (pickUpLatLng != null && dropLatLng != null) {
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            pickUpLatLng!.latitude < dropLatLng!.latitude
                ? pickUpLatLng!.latitude
                : dropLatLng!.latitude,
            pickUpLatLng!.longitude < dropLatLng!.longitude
                ? pickUpLatLng!.longitude
                : dropLatLng!.longitude,
          ),
          northeast: LatLng(
            pickUpLatLng!.latitude > dropLatLng!.latitude
                ? pickUpLatLng!.latitude
                : dropLatLng!.latitude,
            pickUpLatLng!.longitude > dropLatLng!.longitude
                ? pickUpLatLng!.longitude
                : dropLatLng!.longitude,
          ),
        ),
        100,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: pickUpLatLng!,
              zoom: 12,
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
            top: 30,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Distance: $distanceText, ETA: $durationText",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
