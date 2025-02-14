import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFe0eef3),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 1, blurStyle: BlurStyle.inner, blurRadius: 1)
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Enjoying", style: GoogleFonts.akatab(fontWeight: FontWeight.bold, fontSize: 19, color: Color(0xFF063970))),
                    SizedBox(width: 5),
                    Text("TripTo", style: GoogleFonts.akatab(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF063970))),
                    SizedBox(width: 5),
                    Text("Rides?", style: GoogleFonts.akatab(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF063970))),
                  ],
                ),
                Text("Spread the towns!", style: GoogleFonts.akatab(fontSize: 14, color: Color(0xFF02326a))),
                SizedBox(height: 10),
                Text("Refer a Friend", style: GoogleFonts.allerta(fontSize: 12, color: Color(0xFF0866a4))),
              ],
            ),
          ),
          Image.asset('assets/images/share_app.png', width: 100, height: 100),
        ],
      ),
    );
  }
}
