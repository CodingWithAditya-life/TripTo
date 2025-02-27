import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/helpers/helper_function.dart';
import '../maps/search_location/search_location.dart';

class AllServicesForRides extends StatefulWidget {
  const AllServicesForRides({super.key});

  @override
  State<AllServicesForRides> createState() => _AllServicesForRidesState();
}

class _AllServicesForRidesState extends State<AllServicesForRides> {
  final List<Map<String, String>> exploreOptions = [
    {"icon": 'assets/images/tripto.png', "label": "Auto"},
    {"icon": 'assets/images/E-Rickshaw.png', "label": "E-rickshaw"},
    {"icon": 'assets/images/bike.png', "label": "Bike"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              child: Center(
                child: Text(
                  'Explore all services',
                  style: GoogleFonts.akatab(fontSize: 20),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: exploreOptions.map((option) {
                      return Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                AppHelperFunctions.navigateToScreen(
                                  context,
                                  const SearchLocation(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 12),
                                decoration: BoxDecoration(
                                  color:
                                      CupertinoColors.extraLightBackgroundGray,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(option["icon"]!,
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              option["label"]!,
                              style: GoogleFonts.akatab(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
