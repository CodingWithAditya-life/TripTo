import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/helpers/helper_function.dart';
import '../../maps/search_location/search_location.dart';

class CarItem extends StatelessWidget {
  final String rideName;
  final String rideDetails;
  final String rideDistance;
  final String rideImage;
  final BoxConstraints constraints;

  const CarItem({
    super.key,
    required this.rideName,
    required this.rideDetails,
    required this.rideDistance,
    required this.rideImage,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.04),
      padding: EdgeInsets.all(constraints.maxWidth * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF092A54)),
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
                    fontSize: constraints.maxWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rideDetails,
                  style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * 0.035,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      rideDistance,
                      style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth * 0.035,
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
                            fontSize: constraints.maxWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF092A54),
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
                            const SearchLocation(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF092A54),
                        ),
                        child: Text(
                          "Book Now",
                          style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth * 0.035,
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
              width: constraints.maxWidth * 0.2,
              height: constraints.maxWidth * 0.15,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
