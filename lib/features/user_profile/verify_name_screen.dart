import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../authentication/screens/home/home_screen.dart';

class VerifyNameScreen extends StatefulWidget {
  final String? email;

  const VerifyNameScreen({super.key, this.email});

  @override
  State<VerifyNameScreen> createState() => _VerifyNameScreenState();
}

class _VerifyNameScreenState extends State<VerifyNameScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String selectedGender = "";
  String? userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    emailController.text = widget.email!;
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        userLocation = "Location Not Found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 20,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 20,
        title: const Text('Profile', style: TextStyle()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  SizedBox(height: 30),
                  _buildTextField(
                    "Your First Name",
                    fullNameController,
                    CupertinoIcons.person,
                    "First Name",
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    "Your Last Name",
                    lastNameController,
                    CupertinoIcons.person,
                    "Last Name",
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    "Email",
                    emailController,
                    Icons.email_outlined,
                    "Email",
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Select Gender",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _genderButton("Male"),
                      const SizedBox(width: 10),
                      _genderButton("Female"),
                      const SizedBox(width: 10),
                      _genderButton("Other"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF092A54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => store(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon,
      String hint, {
        bool enabled = true,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: Colors.black)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          enabled: enabled,
          cursorColor: const Color(0xFF092A54),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xFF092A54)),
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _genderButton(String gender) {
    return SizedBox(
      width: 100,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedGender = gender;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor:
          selectedGender == gender ? const Color(0xFF092A54) : Colors.white,
        ),
        child: Text(
          gender,
          style: TextStyle(
            color:
            selectedGender == gender
                ? Colors.white
                : const Color(0xFF092A54),
          ),
        ),
      ),
    );
  }

  Future<void> store() async {
    try {
      String? uid = auth.currentUser?.uid;
      if (uid == null) {
        print("Error: User is not logged in.");
        return;
      }

      String? deviceToken = await FirebaseMessaging.instance.getToken();
      print('Device Token: $deviceToken');

      await fireStore.collection("users").doc(uid).set({
        'id': uid,
        'firstName': fullNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender,
        'deviceToken': deviceToken,
        'location': userLocation,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print("Error saving user data: $e");
    }
  }
}
