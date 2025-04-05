import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripto/features/maps/services/location_service.dart';
import 'package:tripto/features/rides/models/active_drivers.dart';
import 'package:tripto/features/rides/models/send_ride_request/send_ride_request.dart';
import 'package:tripto/features/rides/notifications/services/push_notification.dart';
import 'package:tripto/features/user_profile/model/user_model.dart';
import 'package:tripto/features/user_profile/user_service/user_service.dart';
import 'package:tripto/utils/constants/color.dart';
import '../../rides/provider/trip_provider.dart';
import '../providers/ride_request_provider.dart';

class MapScreen extends StatefulWidget {
  final String pickUpLocation;
  final String dropLocation;

  const MapScreen({
    super.key,
    required this.pickUpLocation,
    required this.dropLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? pickUpLatLng;
  LatLng? dropLatLng;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> polyLines = {};
  String distanceText = "";
  String durationText = "";
  bool isLoading = true;
  Position? currentPosition;
  final MapType _currentMapType = MapType.normal;
  StreamSubscription<DatabaseEvent>? rideRequestInformationStreamSubscription;
  int selectedRideIndex = 0;
  late DatabaseReference userLocationRef;
  late Timer locationTimer;
  bool isDriverAssigned = false;
  String requestedRideId = "abcd";

  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isVehicleShowing = true;
  CameraPosition? initialPosition;

  List<Map<String, dynamic>> rideOptions = [
    {
      "type": "Auto",
      "time": "4:23PM - 6 min away",
      "price": "₹120.32",
      "image": "assets/images/tripto.png",
    },
    {
      "type": "E-Rickshaw",
      "time": "4:26PM - 8 min away",
      "price": "₹220.32",
      "image": "assets/images/E-Rickshaw.png",
    },
    {
      "type": "Bike",
      "time": "4:20PM - 3 min away",
      "price": "₹160.32",
      "image": "assets/images/bike.png",
    },
  ];

  final UserService _userService = UserService();
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .ref()
      .child("trip");

  Future<void> bookRide(int selectedRideIndex, BuildContext context) async {
    if (rideOptions.isEmpty) {
      Fluttertoast.showToast(msg: "No available rides.");
      return;
    }

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Fluttertoast.showToast(msg: "User not logged in.");
      return;
    }

    UserModel? users = await _userService.getUserData(userId);
    if (users == null) {
      Fluttertoast.showToast(msg: "User data not found.");
      return;
    }

    String selectedVehicleType = rideOptions[selectedRideIndex]["type"] ?? "";
    print("Selected Ride Type: $selectedVehicleType");

    List<ActiveModel> selectedDriver = await getActiveDriverOnce(
      selectedVehicleType,
    );

    if (selectedDriver.isEmpty) {
      Fluttertoast.showToast(msg: 'not found driver');
    }

    String pickUpAddress = await LocationServices.getFormattedAddress(
      pickUpLatLng!,
    );
    String dropAddress = await LocationServices.getFormattedAddress(
      dropLatLng!,
    );

    for (var driver in selectedDriver) {
      String? driverId = driver.driver?.id;
      String? driverToken = driver.driver?.fcmToken;
      String? driverName = driver.driver?.fullName;

      if (driverToken == null) {
        Fluttertoast.showToast(msg: "No valid driver token found.");
        return;
      }

      String rideId = FirebaseFirestore.instance.collection("trip").doc().id;

      requestedRideId = rideId;
      RideRequest rideRequest = RideRequest(
        id: rideId,
        userId: users.id,
        userName: "${users.firstName} ${users.lastName}",
        driverName: driverName,
        pickupLat: pickUpLatLng!.latitude,
        pickupLng: pickUpLatLng!.longitude,
        dropLat: dropLatLng!.latitude,
        dropLng: dropLatLng!.longitude,
        pickUpAddress: pickUpAddress,
        dropAddress: dropAddress,
        status: "pending",
        createdAt: Timestamp.now(),
        vehicleType: selectedVehicleType,
        driverId: driverId,
        fcmToken: driverToken,
      );

      print("Ride booked with Driver Name: ${driver.driver?.fullName}");

      print("Ride booked with Driver ID: $driverId");

      await FirebaseFirestore.instance
          .collection("trip")
          .doc(rideId)
          .set(rideRequest.toMap());
      await PushNotification.sendPushNotification(driverToken, rideRequest);
      setState(() {});

      print("Ride request notification sent to driver: $driverId");

      Fluttertoast.showToast(msg: "Ride book with $selectedDriver");
    }
  }

  Future<void> _setPickupAndDrop() async {
    LatLng? pickup = await LocationServices.getLatLngFromAddress(
      widget.pickUpLocation,
    );
    LatLng? drop = await LocationServices.getLatLngFromAddress(
      widget.dropLocation,
    );

    BitmapDescriptor pickUpIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30), devicePixelRatio: 30),
      'assets/images/pickUpIcon.png',
    );
    BitmapDescriptor dropIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30),devicePixelRatio: 30),
      'assets/images/pickUpIcon.png',
    );

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

    Map<String, String> travelInfo = await getDistanceBetweenPickUpAndDrop(
      pickup,
      drop,
    );

    setState(() {
      for (var ride in rideOptions) {
        ride["time"] = "${travelInfo["duration"]} away";
        ride["distance"] = travelInfo["distance"];
      }
    });

    setState(() {
      pickUpLatLng = pickup;
      dropLatLng = drop;
      isLoading = false;

      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          infoWindow: const InfoWindow(title: "user"),
          position: pickup,
          icon: pickUpIcon,
        ),
      );

      markers.add(
        Marker(
          markerId: const MarkerId("drop"),
          infoWindow: const InfoWindow(title: "Drop Location"),
          position: drop,
          icon: dropIcon,
        ),
      );
    });

    Circle pickUpCircle = Circle(
      circleId: CircleId("pickup"),
      fillColor: Colors.pink,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: pickUpLatLng!,
    );

    Circle dropCircle = Circle(
      circleId: CircleId("drop"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: dropLatLng!,
    );

    setState(() {
      circles.add(pickUpCircle);
      circles.add(dropCircle);
    });

    _calculateDistanceAndRoute();
  }

  Future<void> _calculateDistanceAndRoute() async {
    if (pickUpLatLng == null || dropLatLng == null) return;

    final result = await LocationServices.getRouteAndDistance(
      pickUpLatLng!,
      dropLatLng!,
    );

    if (result.isNotEmpty) {
      setState(() {
        distanceText = result["distance"];
        durationText = result["duration"];
        polyLines.clear();
        polyLines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            jointType: JointType.round,
            points: result["polyline"],
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            geodesic: true,
            width: 5,
            color: Colors.blue,
          ),
        );
      });
      _moveCameraToRoute();
    }
  }

  void _moveCameraToRoute() {
    if (pickUpLatLng != null && dropLatLng != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
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
        ),
      );
    }
  }

  void _adjustMapZoom(double scrollOffset) {
    double newZoom = 12 + (scrollOffset * 2);
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: pickUpLatLng!, zoom: newZoom),
        ),
      );
    }
  }

  void updateUserLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      Fluttertoast.showToast(msg: "Please enable location services");
      return;
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: "Location permission are permanently denied",
        );
        return;
      }
    }
    Stream.periodic(const Duration(seconds: 5), (computationCount) async {
      Position tripPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          currentPosition = tripPosition;
        });

        userLocationRef.set({
          "pickUpAddress": tripPosition.latitude,
          "dropAddress": tripPosition.longitude,
          "createdAt": ServerValue.timestamp,
        });

        print(
          "Updated Location: ${tripPosition.latitude}, ${tripPosition.longitude}",
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setPickupAndDrop();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: TripToColor.buttonColors,
                ),
              )
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
                      if ((pickUpLatLng?.latitude !=
                              position.target.latitude) ||
                          (pickUpLatLng?.longitude !=
                              position.target.longitude)) {
                        setState(() {});
                      }
                    },
                    markers: markers,
                    polylines: polyLines,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) {
                      scrollController.addListener(() {
                        double offset =
                            scrollController.position.pixels /
                            scrollController.position.maxScrollExtent;
                        _adjustMapZoom(offset);
                      });
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(blurRadius: 10, color: Colors.black26),
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
                            Visibility(
                              visible: isVehicleShowing,
                              child: Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: rideOptions.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color:
                                              index == selectedRideIndex
                                                  ? Colors.blue.shade100
                                                  : Colors.grey.shade200,
                                          image:
                                              rideOptions[index]['image'] !=
                                                      null
                                                  ? DecorationImage(
                                                    image: AssetImage(
                                                      rideOptions[index]['image'],
                                                    ),
                                                  )
                                                  : null,
                                        ),
                                      ),
                                      title: Text(rideOptions[index]["type"]),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Time: ${rideOptions[index]["time"]}",
                                          ),
                                          Text(
                                            "Distance: ${rideOptions[index]["distance"]}",
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        rideOptions[index]["price"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedRideIndex = index;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isVehicleShowing,
                              child: StreamBuilder<DocumentSnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection("trip")
                                        .doc(requestedRideId)
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  print(
                                    "Firestore Data Snapshot: ${snapshot.data?.data()}",
                                  );

                                  if (!snapshot.hasData ||
                                      snapshot.data?.data() == null) {
                                    return const Center(
                                      child: Text("No ride data found."),
                                    );
                                  }

                                  var tripData = snapshot.data!;
                                  String status =
                                      tripData["status"] ?? "pending";
                                  String driverName =
                                      tripData["driverName"] ?? "Unknown";
                                  String pickUpAddress =
                                      tripData["pickUpAddress"] ?? "Unknown";
                                  String dropAddress =
                                      tripData["dropAddress"] ?? "Unknown";

                                  if (status != "accepted") {
                                    return const Center(
                                      child: Text(
                                        "Waiting for ride request driver to accept...",
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 2,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.white60,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        title: Text('Driver Name: $driverName'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pickup Address: $pickUpAddress',
                                            ),
                                            Text('Drop Address: $dropAddress'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(),
                            Visibility(
                              visible: isVehicleShowing,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    bookRide(selectedRideIndex, context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TripToColor.buttonColors,
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                  ),
                                  child: Text(
                                    "Book Now",
                                    style: GoogleFonts.akatab(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            requestedRideId != "abcd"
                                ? StreamBuilder(
                                  stream:
                                      FirebaseDatabase.instance
                                          .ref()
                                          .child('tripTracker')
                                          .orderByChild("tripId")
                                          .equalTo("$requestedRideId")
                                          .onValue,
                                  builder: (context, snapshot) {
                                    try {
                                      print("Ride Data");
                                      print(snapshot.data?.snapshot.value);
                                      Map<dynamic, dynamic> tripData =
                                          Map<dynamic, dynamic>.from(
                                            snapshot.data!.snapshot.value
                                                as Map,
                                          );
                                      String? rideStatus =
                                          tripData.values.first["status"];
                                      print("ride status  $tripData");
                                      print("ride status $rideStatus");
                                      print("ride id $requestedRideId");
                                      if (snapshot.hasData &&
                                          rideStatus == "accepted") {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              if (mounted) {
                                                setState(() {
                                                  isVehicleShowing = false;
                                                });
                                              }
                                            });
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                    return Container();
                                  },
                                )
                                : Container(),
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
