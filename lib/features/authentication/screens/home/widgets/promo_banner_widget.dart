import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tripto/utils/constants/color.dart';

import '../../../../services/dynamic_link_service.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        final shareWithFriends = await DynamicLinkService().generateDynamicLink();
        Share.share(shareWithFriends.toString());
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFe0eef3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1, blurStyle: BlurStyle.inner, blurRadius: 1)
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Enjoying", style: GoogleFonts.akatab(fontWeight: FontWeight.bold, fontSize: 19, color: TripToColor.textColors)),
                      const SizedBox(width: 5),
                      Text("TripTo", style: GoogleFonts.akatab(fontSize: 20, fontWeight: FontWeight.bold, color: TripToColor.textColors)),
                      const SizedBox(width: 5),
                      Text("Rides?", style: GoogleFonts.akatab(fontWeight: FontWeight.bold, fontSize: 17, color: TripToColor.textColors)),
                    ],
                  ),
                  Text("Spread the towns!", style: GoogleFonts.akatab(fontSize: 14, color: TripToColor.textColors)),
                  const SizedBox(height: 10),
                  Text("Refer a Friend", style: GoogleFonts.allerta(fontSize: 12, color: const Color(0xFF0866a4))),
                ],
              ),
            ),
            Image.asset('assets/images/share_app.png', width: 100, height: 100),
          ],
        ),
      ),
    );
  }
}
