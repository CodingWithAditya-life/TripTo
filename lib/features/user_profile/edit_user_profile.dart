import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {

  TextEditingController fullnameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  File? image;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.08),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 4),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: screenWidth * 0.18,
                      backgroundImage: image != null ? FileImage(image!) : null,
                      child: image == null
                          ? IconButton(
                        onPressed: () => showImagePickerOptions(context),
                        icon: Icon(Icons.camera_alt,
                            size: screenWidth * 0.1, color: Colors.grey
                        ),
                      ) : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => showImagePickerOptions(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF063970),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Icon(Icons.edit,
                            color: Colors.white, size: screenWidth * 0.05
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                controller: fullnameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Color(0xFF063970)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                controller: numberController,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Color(0xFF063970)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  counterText: "",
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: SizedBox(
                width: screenWidth * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF092A54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async{
                    await store();

                  },
                  child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> store() async {
    try {
      String? uid = auth.currentUser?.uid;

      if (uid == null) {
        print("Error: User is not logged in.");
        return;
      }

      await firestore.collection("users").doc(uid).set({
        'name': fullnameController.text.trim(),
      });

        Navigator.pop(context);
    } catch (e) {
      print("Error saving user data: $e");
    }
  }


}



