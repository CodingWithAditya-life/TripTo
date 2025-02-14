import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/authentication/screens/home/widgets/explore_section_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/places_list_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/promo_banner_widget.dart';
import 'package:tripto/features/authentication/screens/home/widgets/search_bar_widget.dart';

import 'drawer/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SearchBarWidget(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExploreSectionWidget(),
              SizedBox(height: 25),
              PromoBannerWidget(),
              SizedBox(height: 20),
              SizedBox(height: 10),
              PlacesListWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

