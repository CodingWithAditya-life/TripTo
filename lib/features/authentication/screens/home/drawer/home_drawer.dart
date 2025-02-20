import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/user_profile/edit_user_profile.dart';
import 'DrawerItems.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({ super.key,});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? username;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: AppBar(
                leadingWidth: 20,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
                automaticallyImplyLeading: false,
                title: Text(
                  "Menu",
                  style: GoogleFonts.akatab(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              shadowColor: Colors.blueGrey,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            spreadRadius: 1,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 1,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        maxRadius: 30,
                        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                        child: imageUrl == null
                            ? Icon(CupertinoIcons.person, size: 35, color: Color(0xFF063970))
                            : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        username ?? 'TripTo User',
                        style: GoogleFonts.akatab(fontSize: 18),
                      ),
                    ),

                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserProfile(),));
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey[600], size: 20),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerItem(
                        icon: Icons.security,
                        title: "Safety",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.history,
                        title: "Ride History",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.wallet,
                        title: "Payments",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.notifications_active,
                        title: "Notifications",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.card_giftcard_rounded,
                        title: "Your Reward",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                        icon: Icons.logout,
                        title: "Logout",
                        onTap: () {}),
                    Divider(indent: 12, endIndent: 12),
                    SizedBox(height: 20), // Extra space at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {

    String uid = auth.currentUser!.uid;
    DocumentSnapshot userDoc = await firestore.collection("triptousers").doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc["full_name"];
        imageUrl = userDoc["image"];
      });
    }
  }
}
