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

import '../../payments/service/payment_provider.dart';
import '../../payments/service/payment_service.dart';
import '../../rides/provider/trip_provider.dart';
import 'driver_details.dart';

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
  @override
  GoogleMapController? mapController;
  LatLng? pickUpLatLng;
  LatLng? dropLatLng;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> polyLines = {};
  String distanceText = "";
  String durationText = "";
  int totalFare = 0;
  bool isLoading = true;
  Position? currentPosition;
  final MapType _currentMapType = MapType.normal;
  StreamSubscription<DatabaseEvent>? rideRequestInformationStreamSubscription;
  int selectedRideIndex = 0;
  late DatabaseReference userLocationRef;
  late Timer locationTimer;
  bool isDriverAssigned = false;
  Map<dynamic, dynamic>? tripData;
  String tripId = "";
  final userId = FirebaseAuth.instance.currentUser?.uid;

  List<Map<String, dynamic>> rideOptions = [
    {
      "type": "Auto",
      "time": "4:23PM - 6 min away",
      "price": 14,
      "image": "assets/images/tripto.png",
    },
    {
      "type": "E-Rickshaw",
      "time": "4:26PM - 8 min away",
      "price": 11.5,
      "image": "assets/images/E-Rickshaw.png",
    },
    {
      "type": "Bike",
      "time": "4:20PM - 3 min away",
      "price": 8,
      "image": "assets/images/bike.png",
    },
  ];

  final UserService _userService = UserService();
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .ref()
      .child("activeDriver");

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
    var driver = selectedDriver[0];
    String? driverId = driver.driver?.id;
    String? driverToken = driver.driver?.fcmToken;

    if (driverToken == null) {
      Fluttertoast.showToast(msg: "No valid driver token found.");
      return;
    }

    String rideId = FirebaseFirestore.instance.collection("trip").doc().id;

    RideRequest rideRequest = RideRequest(
      id: rideId,
      userId: users.id,
      userName: "${users.firstName} ${users.lastName}",
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

    print("Ride booked with User Name: ${users.firstName}");
    print("Ride booked with Driver ID: $driverId");

    Fluttertoast.showToast(msg: "Ride booked with $selectedVehicleType");

    await FirebaseFirestore.instance
        .collection("trip")
        .doc(rideId)
        .set(rideRequest.toMap());
    // await PushNotification.sendPushNotification(driverToken, rideRequest);

    // add drivers ride
    var maxDriver = selectedDriver.length > 3 ? 2 : selectedDriver.length;
    print(maxDriver);
    for (var index = 0; index < maxDriver; index++) {
      var driver = selectedDriver[index];
      String? driverId = driver.driver?.id;
      String? driverToken = driver.driver?.fcmToken;

      if (driverToken == null) {
        Fluttertoast.showToast(msg: "No valid driver token found.");
        return;
      }

      String rideId =
          FirebaseFirestore.instance.collection("drivers_trip").doc().id;

      RideRequest rideRequest = RideRequest(
        id: rideId,
        userId: users.id,
        userName: "${users.firstName} ${users.lastName}",
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
        tripId: rideId,
      );

      print("Ride booked with User Name: ${users.firstName}");
      print("Ride booked with Driver ID: $driverId");

      // Fluttertoast.showToast(msg: "Ride booked with $selectedVehicleType");

      await FirebaseFirestore.instance
          .collection("drivers_trip")
          .doc(rideId)
          .set(rideRequest.toMap());
      // await PushNotification.sendPushNotification(driverToken, rideRequest);

      print("Ride request notification sent to driver: $driverId");
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
      ImageConfiguration(size: Size(30, 30)),
      'assets/images/pickUpIcon.png',
    );
    BitmapDescriptor dropIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
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

    userLocationRef = FirebaseDatabase.instance.ref(
      "userLocation/${FirebaseAuth.instance.currentUser?.uid}",
    );
    updateUserLocation();
    _listenForDriverUpdates(tripId!);
    debugFirebaseData();
  }

  @override
  Widget build(BuildContext context) {
    final PaymentProvider paymentProvider = PaymentProvider(
      paymentService: PaymentService(),
    );
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
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: rideOptions.length,
                                itemBuilder: (context, index) {
                                  double distanceInKm =
                                      double.tryParse(
                                        distanceText.split(" ")[0],
                                      ) ??
                                      0.0;
                                  double fare =
                                      distanceInKm *
                                      rideOptions[index]["price"];
                                  return ListTile(
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            index == selectedRideIndex
                                                ? Colors.blue.shade100
                                                : Colors.grey.shade200,
                                        image:
                                            rideOptions[index]['image'] != null
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
                                      ],
                                    ),
                                    trailing: Text(
                                      "₹${fare.round()}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: TripToColor.buttonColors,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedRideIndex = index;
                                        totalFare = fare.toInt();
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
                                  bookRide(selectedRideIndex, context);
                                  _showSearchingDialog(context);
                                  _listenForDriverUpdates(tripId);
                                  listenForNewTrips();

                                  paymentProvider.makePayment(
                                    amount: totalFare,
                                    name: 'Chandan Kumar',
                                    contact: "7241872547",
                                    userId: userId.toString(),
                                    driverName: 'Naushad Ansari',
                                    userName: 'Chandan Kumar',
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TripToColor.buttonColors,
                                  minimumSize: const Size(double.infinity, 50),
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
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }

  void showDriverDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full screen bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: isDriverAssigned ? 300 : 200,
          child:
              tripData == null || !isDriverAssigned
                  ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          'Waiting for driver to accept...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Driver Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Text(
                        '🚗 Driver: ${tripData!['driverName']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '📞 Phone: ${tripData!['driverPhone'] ?? 'Not available'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '📍 Pickup: ${tripData!['pickUpAddress']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '📍 Drop: ${tripData!['dropAddress']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close"),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  void _showSearchingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          // 🔥 Block Manual Close
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    "Searching for a driver...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Icon(Icons.close, size: 30),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _listenForDriverUpdates(String tripId) {
    DatabaseReference tripRef = FirebaseDatabase.instance.ref(
      "tripTracker/$tripId",
    );

    print("🔄 Listening for driver updates for trip: $tripId");

    tripRef.onValue.listen((event) {
      print("📡 Firebase Data Changed!");

      if (event.snapshot.value != null) {
        print("🔥 New Data Received: ${event.snapshot.value}");

        Map<String, dynamic> trip = Map<String, dynamic>.from(
          event.snapshot.value as Map<Object?, Object?>,
        );
        print("📌 Processed Data: $trip");
        if (trip['driverName'] != null && trip['status'] == "accepted") {
          setState(() {
            tripData = trip;
            isDriverAssigned = true;
          });

          print("✅ isDriverAssigned: $isDriverAssigned");

          if (isDriverAssigned) {
            Navigator.pop(context);
            print("🚗 Showing Driver Details...");
            showDriverDetails();
          }
        } else {
          print("❌ Driver Not Assigned Yet!");
        }
      } else {
        print("❌ No Data Found in Realtime Listener!");
      }
    });
  }

  void debugFirebaseData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "tripTracker/JAIo6Cj7DeWyXszZmZ63",
    );

    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      print(" Data Found in Firebase: ${snapshot.value}");
    } else {
      print(" No Data Found in Firebase!");
    }
  }

  void listenForNewTrips() {
    DatabaseReference tripRef = FirebaseDatabase.instance.ref("tripTracker");
    tripRef.onChildAdded.listen((DatabaseEvent event) {
      String tripId = event.snapshot.key!;
      Map<dynamic, dynamic> tripData = event.snapshot.value as Map;
      print("New Trip ID: $tripId");
      print("Driver: ${tripData['driverName']}");
    });
  }
}
