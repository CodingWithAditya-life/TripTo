import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/user_profile/user_provider/user_provider.dart';
import '../../utils/theme/colors.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  @override
  Widget build(BuildContext context) {
    // UserProfileController provider=Provider.of<UserProfileController>(context);
    return Scaffold(
        backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("Profile")),
      ),
      body: ListView(
        children: [
          SizedBox(height: 100),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 4),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 60,
                  child: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF063970),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Full Name",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(color: Color(0xFF063970)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Mobile Number",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(color: Color(0xFF063970)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Address",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(color: Color(0xFF063970)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Date of Birth",
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: TextStyle(color: Color(0xFF063970)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 140,right: 140),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF092A54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {},
              child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )
        ],
      )
    );
  }
}
