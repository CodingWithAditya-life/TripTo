import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/maps/search_location/search_location.dart';
import 'package:tripto/utils/helpers/helper_function.dart';

import 'car_items.dart';

class AvailableForRides extends StatefulWidget {
  const AvailableForRides({super.key});

  @override
  State<AvailableForRides> createState() => _AvailableForRidesState();
}

class _AvailableForRidesState extends State<AvailableForRides> {
  final List<Map<String, String>> rideList = [
    {
      "rideName": "Auto",
      "rideDetails": "Automatic   |   3 seats   |   Octane",
      "rideDistance": "800m (5mins away)",
      "rideImage": "assets/images/tripto.png",
    },
    {
      "rideName": "E-Rickshaw",
      "rideDetails": "Electric   |   4 seats   |   EV",
      "rideDistance": "1.2km (7mins away)",
      "rideImage": "assets/images/E-Rickshaw.png",
    },
    {
      "rideName": "Bike",
      "rideDetails": "Petrol",
      "rideDistance": "2km (10mins away)",
      "rideImage": "assets/images/bike.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double textScale = constraints.maxWidth * 0.0025;
            return Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available cars for ride",
                    style: GoogleFonts.akatab(
                      fontSize: constraints.maxWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${rideList.length} rides found",
                    style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rideList.length,
                      itemBuilder: (context, index) {
                        return CarItem(
                          rideName: rideList[index]['rideName']!,
                          rideDetails: rideList[index]['rideDetails']!,
                          rideDistance: rideList[index]['rideDistance']!,
                          rideImage: rideList[index]['rideImage']!,
                          constraints: constraints,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
