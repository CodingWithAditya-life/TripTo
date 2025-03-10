import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripto/features/maps/services/location_service.dart';
import 'package:tripto/utils/constants/color.dart';

class MapScreen extends StatefulWidget {
  final String pickUpLocation;
  final String dropLocation;

  const MapScreen(
      {super.key, required this.pickUpLocation, required this.dropLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? pickUpLatLng;
  LatLng? dropLatLng;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> polylines = {};
  String distanceText = "";
  String durationText = "";
  bool isLoading = true;
  final MapType _currentMapType = MapType.normal;
  String driverRideStatus = "Driver is coming";
  StreamSubscription<DatabaseEvent>? rideRequestInformationStreamSubscription;

  String driverCarDetails = "";
  String driverName = "";
  String driverPhone = "";
  String userRideRequest = "";

  int selectedRideIndex = 0;

  final List<Map<String, dynamic>> rideOptions = [
    {
      "type": "Standard 4-seat",
      "time": "4:23PM - 6 min away",
      "price": "\₹120.32",
      "image": "assets/images/tripto.png"
    },
    {
      "type": "Premium 4-seat",
      "time": "4:26PM - 8 min away",
      "price": "\₹220.32",
      "image": "assets/images/E-Rickshaw.png"
    },
    {
      "type": "Standard 2-seat",
      "time": "4:20PM - 3 min away",
      "price": "\₹160.32",
      "image": "assets/images/bike.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _setPickupAndDrop();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  Future<void> _setPickupAndDrop() async {
    LatLng? pickup =
        await LocationServices.getLatLngFromAddress(widget.pickUpLocation);
    LatLng? drop =
        await LocationServices.getLatLngFromAddress(widget.dropLocation);

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
        infoWindow: const InfoWindow(
          title: "Pickup Location",
        ),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      markers.add(Marker(
        markerId: const MarkerId("drop"),
        infoWindow: const InfoWindow(title: "Drop Location"),
        position: drop,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });

    Circle pickUpCircle = Circle(
        circleId: CircleId("pickup"),
        fillColor: Colors.pink,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: pickUpLatLng!);

    Circle dropCircle = Circle(
        circleId: CircleId("drop"),
        fillColor: Colors.red,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: dropLatLng!);

    setState(() {
      circles.add(pickUpCircle);
      circles.add(dropCircle);
    });

    _calculateDistanceAndRoute();
  }

  Future<void> _calculateDistanceAndRoute() async {
    if (pickUpLatLng == null || dropLatLng == null) return;

    final result =
        await LocationServices.getRouteAndDistance(pickUpLatLng!, dropLatLng!);

    if (result.isNotEmpty) {
      setState(() {
        distanceText = result["distance"];
        durationText = result["duration"];
        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          jointType: JointType.round,
          points: result["polyline"],
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
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

  void _adjustMapZoom(double scrollOffset) {
    double newZoom = 12 + (scrollOffset * 2);
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pickUpLatLng!, zoom: newZoom),
      ));
    }
  }

  saveRideRequest(String selectRidesType) {
    DatabaseReference referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride request").push();

    var pickUpLocation = widget.pickUpLocation;
    var dropLocation = widget.dropLocation;

    // Map pickUpLocationOnMap = {
    //   "latitude": pickUpLocation.locationLatitude.toString();
    //   "longitude": pickUpLocation.locationLongitude.toString();
    // };
    //
    // Map dropLocationOnMap = {
    // "latitude": dropLocation.locationLatitude.toString();
    // "longitude": dropLocation.locationLongitude.toString();
    // };
    //

    // Map userInformationOnMap = {
    //   'pickup': pickUpLocation,
    // "destination": destinationLocationMap,
    // "time": DateTime.now().toString(),
    // "name": "userName",
    // "phoneNumber": "number",
    // "pickUpAddress": pickUpLocation.locationName,
    // "destinationAddress": dropLocation.locationName,
    // "driverId": "waiting"
    // };

    // referenceRideRequest.set(userInformationOnMap);

    rideRequestInformationStreamSubscription =
        referenceRideRequest.onValue.listen(
      (event) async {
        if (event.snapshot.value == null) {
          return;
        }
        if ((event.snapshot.value as Map)["car_details"] != null) {
          setState(() {
            driverCarDetails =
                (event.snapshot.value as Map)["car_details"].toString();
          });
        }

        if ((event.snapshot.value as Map)["driverPhone"] != null) {
          setState(() {
            driverPhone =
                (event.snapshot.value as Map)["driverPhone"].toString();
          });
        }

        if ((event.snapshot.value as Map)["driverName"] != null) {
          setState(() {
            driverName =
                (event.snapshot.value as Map)["driverName"].toString();
          });
        }

        if((event.snapshot.value as Map)["driverLocation"] != null){
          double driverCurrentPositionLatitude = double.parse((event.snapshot.value as Map)["driverLocation"]["latitude"].toString());
          double driverCurrentPositionLongitude = double.parse((event.snapshot.value as Map)["driverLocation"]["longitude"].toString());

          LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLatitude, driverCurrentPositionLongitude);

          if(userRideRequest == "accepted"){
            // updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
          }
          if(userRideRequest == "arrived"){
            setState(() {
              driverRideStatus = "Driver has arrived";
            });
          }
          if(userRideRequest == "ended"){
            if((event.snapshot.value as Map)["fareAmount"] != null){
              double faceAmount = double.parse((event.snapshot.value as Map)["fareAmount"].toString());
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: TripToColor.buttonColors))
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
                  onCameraMove: (position) {
                    if (pickUpLatLng != position.target) {
                      setState(() {
                        pickUpLatLng = position.target;
                      });
                    }
                  },
                  markers: markers,
                  polylines: polylines,
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    scrollController.addListener(() {
                      double offset = scrollController.position.pixels /
                          scrollController.position.maxScrollExtent;
                      _adjustMapZoom(offset);
                    });
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: Colors.black26)
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.pickUpLocation,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 5),
                                Text(
                                  widget.dropLocation,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: rideOptions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: index == selectedRideIndex
                                          ? Colors.blue.shade100
                                          : Colors.grey.shade200,
                                      image: rideOptions[index]['image'] != null
                                          ? DecorationImage(
                                              image: AssetImage(
                                                  rideOptions[index]['image']))
                                          : null,
                                    ),
                                  ),
                                  title: Text(rideOptions[index]["type"]),
                                  subtitle: Text(rideOptions[index]["time"]),
                                  trailing: Text(rideOptions[index]["price"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    setState(() {
                                      selectedRideIndex = index;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    "Booking ${rideOptions[selectedRideIndex]["type"]}");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TripToColor.buttonColors,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(
                                "Book Now",
                                style: GoogleFonts.akatab(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
