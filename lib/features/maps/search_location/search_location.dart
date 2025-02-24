import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripto/features/maps/screens/map_screen.dart';
import 'package:tripto/features/maps/services/location_service.dart';
import 'package:tripto/utils/constants/color.dart';
import '../../../../utils/helpers/helper_function.dart';
import 'package:http/http.dart' as http;

import '../widgets/search_location_appbar.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  LatLng? pickUpLatLng;
  LatLng? dropLatLng;
  List<dynamic> _placePredictions = [];
  LatLng? _selectedLocation;

  Future<void> _getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placePredictions = [];
      });
      return;
    }

    final String url =
        "https://maps.gomaps.pro/maps/api/place/autocomplete/json?input=$input&key=AlzaSyUUs6EPVHuIaK-6ooq_Ev9fky9DkGtxqFe";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _placePredictions = data['predictions'];
      });
    }
  }

  Future<void> _onPlaceSelected(String placeId, String description) async {
    final String url =
        "https://maps.gomaps.pro/maps/api/place/details/json?place_id=$placeId&key=AlzaSyUUs6EPVHuIaK-6ooq_Ev9fky9DkGtxqFe";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];

      setState(() {
        _selectedLocation = LatLng(location['lat'], location['lng']);
        _dropController.text = description;
        _placePredictions.clear();
      });

      print("Selected Location: $_selectedLocation");
    }
  }

  Future<void> _setCurrentLocation() async {
    setState(() {
      _pickUpController.text = "Your current location";
    });

    Map<String, dynamic> locationData = await LocationServices.getUserLocation();

    setState(() {
      pickUpLatLng = locationData["latLng"];
      _pickUpController.text = locationData["address"];
    });

    print("Current Location: ${locationData["address"]}");
  }

  Future<void> _requestLocationPermission() async {
    Map<String, dynamic> locationServices = await LocationServices.getUserLocation();
    if (_pickUpController.text.isNotEmpty && _dropController.text.isNotEmpty) {
      AppHelperFunctions.navigateToScreen(
          context,
          MapScreen(
            pickUpLocation: _pickUpController.text,
            dropLocation: _dropController.text,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter both pickup and drop locations"))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  Widget _buildSuggestionList() {
    return _placePredictions.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _placePredictions.length,
            itemBuilder: (context, index) {
              String description = _placePredictions[index]['description'];
              List<String> parts = description.split(',');
              String firstLine = parts.isNotEmpty ? parts.first.trim() : "";
              String secondLine =
                  parts.length > 1 ? parts.sublist(1).join(',').trim() : "";
              return ListTile(
                leading: Image(image: const AssetImage('assets/images/location.png'),height: 25,color: TripToColor.buttonColors),
                title: Text(
                  firstLine,
                ),
                subtitle: Text(secondLine),
                onTap: () {
                  _onPlaceSelected(
                    _placePredictions[index]['place_id'],
                    _placePredictions[index]['description'],
                  );
                },
              );
            },
          )
        : const SizedBox();
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
            const SearchLocationAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    const SizedBox(height: 4),
                                    const Icon(Icons.location_on_sharp,
                                        color: Colors.green, size: 20),
                                    const SizedBox(height: 2),
                                    Image.asset(
                                      'assets/images/line.png',
                                      height: 30,
                                      color: Colors.green,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.medium,
                                    ),
                                    const SizedBox(height: 2),
                                    const Icon(Icons.location_on_sharp,
                                        color: Colors.red, size: 20),
                                  ],
                                ),
                                const SizedBox(width: 5),
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
                                      const Divider(
                                          height: 1, color: Colors.black12),
                                      TextField(
                                        controller: _dropController,
                                        onChanged: _getPlaceSuggestions,
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
                        padding: const EdgeInsets.all(10),
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
                              side: const BorderSide(color: Colors.black12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                          height: 2, color: Colors.black12, thickness: 2),
                      _buildSuggestionList(),
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
