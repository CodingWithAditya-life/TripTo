import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        backgroundColor: Colors.white,
        title: Text(
          'Where are you going',
          style: GoogleFonts.akatab(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.extraLightBackgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Pickup location',
                              hintStyle: GoogleFonts.akatab(
                                  fontSize: 16, color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey, thickness: 1),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 12),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Drop location",
                              hintStyle: GoogleFonts.akatab(
                                  fontSize: 16, color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {},
                label: Text(
                  'Select on map',
                  style: GoogleFonts.akatab(fontSize: 16, color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
