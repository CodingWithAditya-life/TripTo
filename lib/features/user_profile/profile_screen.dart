import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String selectedGender = "Male";
  String userName = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String uid = auth.currentUser?.uid ?? "";
      if (uid.isEmpty) return;

      DocumentSnapshot userDoc = await firestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc["name"];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        title: Text(
          'Profile',
          style: GoogleFonts.akatab(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection("users").doc(auth.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!;
          String userName = userData["name"] ?? "No Name";
          String userEmail = userData["email"] ?? "No Email";
          // String userPhone = userData["userNumber"] ?? "No Email";

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileTile(
                  icon: Icons.person,
                  title: "Name",
                  subtitle: userName,
                  onTap: () => _showEditableBottomSheet(context, "Name", userName),
                ),
                ProfileTile(
                  icon: Icons.email_outlined,
                  title: "Email",
                  subtitle: userEmail,
                  onTap: () => _showEditableBottomSheet(context, "Email", userEmail),
                ),
                ProfileTile(
                  icon: Icons.wifi_calling_3,
                  title: "Phone Number",
                  subtitle: "userPhone",
                  onTap: () => _showEditableBottomSheet(context, "Phone Number", "userPhone"),
                ),
                ListTile(
                  leading: Image(image: AssetImage('assets/images/gender.png'),color: Colors.blueGrey,width: screenWidth * 0.07,),
                  title: Text(
                    "Gender",
                    style: GoogleFonts.akatab(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedGender,
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedGender,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        elevation: 1,

                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedGender = newValue;
                            });
                          }
                        },
                        items: ["Male", "Female", "Other"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }


  void _showEditableBottomSheet(BuildContext context, String field, String value) {
    TextEditingController controller = TextEditingController(text: value);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(field, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF092A54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        String updatedValue = controller.text.trim();
                        if (updatedValue.isNotEmpty) {
                          await _updateUserData(field.toLowerCase(), updatedValue);
                          Navigator.pop(context); // BottomSheet close karega
                        }
                      },
                      child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateUserData(String field, String value) async {
    try {
      String uid = auth.currentUser?.uid ?? "";
      if (uid.isNotEmpty) {
        await firestore.collection("users").doc(uid).update({field: value});
        setState(() {});
      }
    } catch (e) {
      print("Error updating $field: $e");
    }
  }

}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showTrailing;
  final VoidCallback? onTap;

  ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showTrailing = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, size: screenWidth * 0.07, color: Colors.blueGrey),
          title: Text(
            title,
            style: GoogleFonts.akatab(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          trailing: showTrailing
              ? Icon(Icons.arrow_forward_ios_outlined, size: screenWidth * 0.04, color: Colors.grey)
              : null,
        ),
        const Divider(),
      ],
    );
  }
}
