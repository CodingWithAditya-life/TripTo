import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../maps/search_location/search_location.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SearchLocation(),
                  ),
                );
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: CupertinoColors.extraLightBackgroundGray,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text("Where are you going?",
                        style: GoogleFonts.akatab(
                            fontSize: 17, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
