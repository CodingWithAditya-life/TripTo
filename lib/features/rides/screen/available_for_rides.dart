import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/maps/screens/map_screen.dart';
import 'package:tripto/features/maps/search_location/search_location.dart';
import 'package:tripto/utils/helpers/helper_function.dart';

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
      "rideDetails": "Automatic   |   4 seats   |   Petrol",
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available cars for ride",
                style: GoogleFonts.akatab(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "${rideList.length} rides founds",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarItem extends StatelessWidget {
  final String rideName;
  final String rideDetails;
  final String rideDistance;
  final String rideImage;

  const CarItem({
    super.key,
    required this.rideName,
    required this.rideDetails,
    required this.rideDistance,
    required this.rideImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF092A54)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rideName,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rideDetails,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      rideDistance,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF092A54)),
                        ),
                        child: Text(
                          "Book later",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF092A54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AppHelperFunctions.navigateToScreen(
                            context,
                            SearchLocation(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF092A54),
                        ),
                        child: Text(
                          "Book Now",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              rideImage,
              width: 80,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
