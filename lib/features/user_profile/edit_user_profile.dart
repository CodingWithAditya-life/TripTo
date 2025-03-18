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
  TextEditingController fullNameController = TextEditingController();
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
        title: const Text("Edit your profile", style: TextStyle(fontSize: 18,color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
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
                            backgroundImage:
                            image != null ? FileImage(image!) : null,
                            child: image == null
                                ? IconButton(
                              onPressed: () => showImagePickerOptions(context),
                              icon: Icon(Icons.camera_alt,
                                  size: screenWidth * 0.1,
                                  color: Colors.grey),
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => showImagePickerOptions(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF063970),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: screenWidth * 0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  _inputField("Full Name", fullNameController, false),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
          _saveButton(screenWidth, screenHeight),
        ],
      ),
    );
  }


  Widget _inputField(String label, TextEditingController controller, bool isNumber) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: isNumber ? 10 : null,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          labelStyle: const TextStyle(color: Color(0xFF063970)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          counterText: "",
        ),
      ),
    );
  }


  Widget _saveButton(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: SizedBox(
        width: screenWidth * 0.4,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF092A54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () async {
            await store();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
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
        'name': fullNameController.text.trim(),
        // 'mobile': numberController.text.trim(),
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error saving user data: $e");
    }
  }
}
