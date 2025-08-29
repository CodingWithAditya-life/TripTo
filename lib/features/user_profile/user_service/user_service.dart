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
      // Fetch user doc
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance
          .collection("users") // 🔹 confirm karo collection ka naam yahi hai
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        print("DEBUG: No user document found for uid: $userId in 'users' collection");
        return null;
      }

      final data = userDoc.data();
      if (data == null) {
        print("DEBUG: User document exists but data is null for $userId");
        return null;
      }

      print("DEBUG: User data fetched for $userId => $data");

      // 🔹 ensure your model has correct factory
      return UserModel.fromFirestore(userDoc);
    } catch (e, st) {
      print("DEBUG: Error fetching user data for $userId => $e");
      print(st);
      return null;
    }
  }


}
