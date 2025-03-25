import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto/features/authentication/screens/signUp/signUp_page.dart';
import 'package:tripto/features/user_profile/profile_screen.dart';
import 'package:tripto/utils/helpers/helper_function.dart';
import '../../../../rides/ride_history_screen.dart';
import '../../auth_service.dart';
import 'DrawerItems.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  String userName = "Loading...";

  Future<void> fetchUserName() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (userDoc.exists) {
      setState(() {
        userName = "${userDoc["firstName"]} ${userDoc["lastName"]}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser?.uid ?? "";

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
                leadingWidth: 30,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                automaticallyImplyLeading: false,
                title: Text(
                  "Menu",
                  style: GoogleFonts.akatab(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
              builder: (context, snapshot) {
                String username = "Loading...";
                if (snapshot.hasData && snapshot.data!.exists) {
                  username = "${snapshot.data!["firstName"]} ${snapshot.data!["lastName"]}";
                }
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.blueGrey,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.inner,
                                blurRadius: 1,
                              )
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 30,
                            child: Icon(
                              CupertinoIcons.person,
                              size: 35,
                              color: Color(0xFF063970),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            username,
                            style: GoogleFonts.akatab(fontSize: 18),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[600], size: 20),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerItem(icon: Icons.security, title: "Safety", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.history, title: "Ride History", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.wallet, title: "Payments", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.notifications_active, title: "Notifications", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.help_outline, title: "Help & Support", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.settings, title: "Settings", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(icon: Icons.card_giftcard_rounded, title: "Your Reward", onTap: () {}),
                    const Divider(indent: 12, endIndent: 12),
                    DrawerItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () async {
                        bool isLoggedOut = await AuthService().signOut();
                        if (isLoggedOut) {
                          AppHelperFunctions.navigateToScreen(context, const SignUpPage());
                        }
                      },
                    ),
                    const Divider(indent: 12, endIndent: 12),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
