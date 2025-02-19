import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripto/features/maps/screens/map_screen.dart';
import 'package:tripto/features/maps/services/location_service.dart';

import '../../../../utils/helpers/helper_function.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _changeStatusBarColor();
  // }
  //
  // void _changeStatusBarColor() {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.light,
  //     systemNavigationBarColor: Colors.white,
  //   ));
  //   setState(() {});
  // }

  Future<void> _requestLocationPermission() async {
    LatLng locationServices = await LocationServices.getUserLocation();
    if (_pickUpController.text.isNotEmpty && _dropController.text.isNotEmpty) {
      AppHelperFunctions.navigateToScreen(context, MapScreen(pickUpLocation: _pickUpController.text,dropLocation: _dropController.text,));
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both pickup and drop locations")),
      );
    }

    print("User Location: ${locationServices.latitude}, ${locationServices.longitude}");
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Where are you going',
                    style: GoogleFonts.akatab(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(12),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.extraLightBackgroundGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 4),
                                    Icon(Icons.location_on_sharp,
                                        color: Colors.green, size: 20),
                                    SizedBox(height: 2),
                                    Image.asset(
                                      'assets/images/line.png',
                                      height: 30,
                                      color: Colors.green,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.medium,
                                    ),
                                    SizedBox(height: 2),
                                    Icon(Icons.location_on_sharp,
                                        color: Colors.red, size: 20),
                                  ],
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextField(
                                        controller: _pickUpController,
                                        cursorColor: Colors.green,
                                        decoration: InputDecoration(
                                          hintText: 'Pickup location',
                                          hintStyle: GoogleFonts.akatab(
                                              color: Colors.black54),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      Divider(height: 1, color: Colors.black12),
                                      TextField(
                                        controller: _dropController,
                                        cursorColor: Colors.red,
                                        decoration: InputDecoration(
                                          hintText: 'Drop location',
                                          hintStyle: GoogleFonts.akatab(
                                              color: Colors.black54),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          height: 35,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _requestLocationPermission();
                            },
                            icon: Icon(Icons.my_location,
                                color: Colors.tealAccent.shade700),
                            label: Text(
                              'Select on map',
                              style: GoogleFonts.akatab(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(height: 2, color: Colors.black12, thickness: 2),
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
