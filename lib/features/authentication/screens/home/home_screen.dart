import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/authentication/screens/home/widgets/explore_section_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/places_list_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/promo_banner_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/search_bar_widget.dart';
import 'package:tripto/features/rides/notifications/get_server_token/get_server_token.dart';
import 'package:tripto/features/rides/notifications/store_device_token/get_device_token.dart';

import '../../../rides/notifications/services/notification_services.dart';
import 'drawer/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DeviceTokenServices _accessToken = DeviceTokenServices();
  final GetServerToken _serverToken = GetServerToken();

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _checkLocationPermission();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
    });
  }

  Future<void> _initializeNotification() async {
    await _notificationServices.initNotification(context);
    await _notificationServices.requestPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      _showLocationDeniedDialog();
    }
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
            "Location permission is permanently denied. Please enable it from settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notificationServices.initNotification(context);
      await _accessToken.storeDeviceToken();
      await _serverToken.getServerToken();
      print("Device token = $_accessToken");
      print("Device token = $_serverToken");
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Drawer Icon
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: SearchBarWidget()),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExploreSectionWidget(),
                      const SizedBox(height: 25),
                      const PromoBannerWidget(),
                      const SizedBox(height: 20),
                      PlacesListWidget(),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Image(
                                    image: AssetImage(
                                        'assets/images/india-icon.png'),
                                    height: 50,
                                    width: 50),
                                Text('Made In Bharat',
                                    style: GoogleFonts.federo(fontSize: 30)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
