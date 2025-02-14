import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto/features/user_profile/user_provider/user_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    UserProfileController provider=Provider.of<UserProfileController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
              child: Icon(Icons.person,color: Colors.white,),
            ),
          ),
          SizedBox(height: 20,),
          profileWidget(provider.nameController, 'Enter name', Icons.person),
          SizedBox(height: 20,),
          profileWidget(provider.phoneController, 'Enter phone', Icons.phone),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Text("Submit"),
          ),
        ],
      )),
    );
  }
  Widget profileWidget(TextEditingController controller,String hintText,IconData icon){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue),),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent),)
            ,hintText: hintText,
        prefixIcon: Icon(icon)),
      ),
    );
  }
}
