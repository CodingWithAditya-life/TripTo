import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacesListWidget extends StatelessWidget {
  final List<Map<String, String>> places = [
    {"image": "assets/images/image.jpg", "label": "Madhaura railway station"},
    {"image": "assets/images/amnour_place.jpg", "label": "Amnour"},
    {"image": "assets/images/chhapra_junction.jpg", "label": "Chapra"},
  ];

  PlacesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Go Places with TripTo",
            style: GoogleFonts.akatab(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF063970))),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: CupertinoColors.extraLightBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(places[index]["image"]!,
                        height: 100,width: 150, fit: BoxFit.cover),
                    SizedBox(height: 5),
                    Text(places[index]["label"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.akatab(fontSize: 14,)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
