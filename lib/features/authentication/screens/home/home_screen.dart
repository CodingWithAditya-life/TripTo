import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/authentication/screens/home/widgets/explore_section_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/places_list_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/promo_banner_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/search_bar_widget.dart';
import 'package:tripto/utils/constants/color.dart';

import 'drawer/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                child: Row(
                  children: [
                    // Drawer Icon
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(child: SearchBarWidget()),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExploreSectionWidget(),
                        SizedBox(height: 25),
                        PromoBannerWidget(),
                        SizedBox(height: 20),
                        PlacesListWidget(),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/india-icon.png'),
                                      height: 50,
                                      width: 50),
                                  Text('Made In Bharat',
                                      style: GoogleFonts.federo(fontSize: 30)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
