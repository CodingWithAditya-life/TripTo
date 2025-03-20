import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String location,
  }) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("Error: User is not logged in.");
        return;
      }

      String? deviceToken = await FirebaseMessaging.instance.getToken();
      print('Device Token: $deviceToken');

      UserModel user = UserModel(
        id: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        deviceToken: deviceToken,
        location: location,
      );

      await _firestore.collection("users").doc(uid).set(user.toMap());
    } catch (e) {
      print("Error saving user data: $e");
    }
  }


  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}
