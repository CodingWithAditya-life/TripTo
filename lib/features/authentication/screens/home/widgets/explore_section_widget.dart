import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreSectionWidget extends StatelessWidget {
  final List<Map<String, String>> exploreOptions = [
    {"icon": 'assets/images/tripto.png', "label": "Auto"},
    {"icon": 'assets/images/E-Rickshaw.png', "label": "E-rickshaw"},
    {"icon": 'assets/images/bike.png', "label": "Bike"},
  ];

  ExploreSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Explore", style: GoogleFonts.akatab(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text("View All", style: GoogleFonts.akatab(fontSize: 14, color: Colors.grey[600])),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: exploreOptions.map((option) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 27,vertical: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.extraLightBackgroundGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(option["icon"]!, width: 45, height: 45, fit: BoxFit.fitHeight),
                    ),
                    SizedBox(height: 5),
                    Text(option["label"]!, style: GoogleFonts.akatab(fontSize: 15)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
