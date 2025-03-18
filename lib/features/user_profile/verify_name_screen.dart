import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/screens/home/home_screen.dart';

class VerifyNameScreen extends StatefulWidget {
  const VerifyNameScreen({super.key});

  @override
  State<VerifyNameScreen> createState() => _VerifyNameScreenState();
}

class _VerifyNameScreenState extends State<VerifyNameScreen> {
  TextEditingController fullnameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 27),
            child: Text("Your Name", style: TextStyle(fontSize: 20, color: Colors.black)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: fullnameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: "Type your name",
                fillColor: Colors.white,
                filled: true,
                labelStyle: const TextStyle(color: Color(0xFF063970)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 27),
            child: Text("Select Gender", style: TextStyle(fontSize: 20, color: Colors.black)),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _genderButton("Male"),
                const SizedBox(width: 10),
                _genderButton("Female"),
                const SizedBox(width: 10),
                _genderButton("Other"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Divider(color: Colors.grey, height: 80),
          ),
          SizedBox(height: screenHeight * 0.03),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 380,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF092A54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => store(),
                child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Gender Selection Button
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
          backgroundColor: selectedGender == gender ? Colors.blue : Colors.white,
        ),
        child: Text(gender, style: TextStyle(color: selectedGender == gender ? Colors.white : const Color(0xFF092A54))),
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

      String fullName = fullnameController.text.trim();

      if (fullName.isEmpty || selectedGender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your name and select gender.")),
        );
        return;
      }

      await firestore.collection("users").doc(uid).set({
        'name': fullName,
        'gender': selectedGender,
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

}
