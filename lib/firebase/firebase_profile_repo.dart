import 'package:cyber_clinic/data/vos/app_user_vo.dart';
import 'package:cyber_clinic/domain/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final databaseRef = FirebaseDatabase.instance.ref();

  final firebaseAuth = FirebaseAuth.instance;

  //Fetch User Profile

  @override
  Future<AppUserVO?> fetchUserProfile(String uid) async {
    try {
      return databaseRef.child("users").child(uid).once().then((event) {
        if (event.snapshot.value == null) {
          return null;
        } else {
          final rawData = event.snapshot.value;
          return AppUserVO.fromJson(Map<String, dynamic>.from(rawData as Map));
        }
      });
    } catch (error) {
      return null;
    }
  }

  //Update User Profile

  @override
  Future<void> updateUserProfile(AppUserVO updatedProfile) async {
    try {
      await databaseRef
          .child("users")
          .child(updatedProfile.uid)
          .set(updatedProfile.toJson());
    } catch (error) {
      throw Exception(error);
    }
  }

  //Change Password

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: firebaseAuth.currentUser?.email ?? "",
              password: oldPassword)
          .then(
        (value) async {
          await firebaseAuth.currentUser?.updatePassword(newPassword);
        },
      );
    } catch (error) {
      throw Exception(error);
    }
  }
}
