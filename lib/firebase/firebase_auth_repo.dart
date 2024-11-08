import 'package:cyber_clinic/data/vos/app_user_vo.dart';
import 'package:cyber_clinic/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref();

  //get current user

  @override
  Future<AppUserVO?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return null;
    }

    AppUserVO? user =
        await databaseRef.child("users").child(currentUser.uid).once().then(
      (event) {
        final rawData = event.snapshot.value;
        return AppUserVO.fromJson(Map<String, dynamic>.from(rawData as Map));
      },
    );

    return user;
  }

  // login user

  @override
  Future<AppUserVO?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUserVO user = await databaseRef
          .child("users")
          .child(userCredential.user?.uid ?? "")
          .once()
          .then(
        (event) {
          final rawData = event.snapshot.value;
          return AppUserVO.fromJson(Map<String, dynamic>.from(rawData as Map));
        },
      );

      return user;
    } catch (error) {
      throw Exception("Login Failed: $error");
    }
  }

  //logout user

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //Register User

  @override
  Future<AppUserVO?> registerAppUser(String name, String email, String password,
      String phone, int age, String gender, bool isBanned) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUserVO user = AppUserVO(
          uid: userCredential.user?.uid ?? "",
          email: email,
          name: name,
          bio: "",
          age: age,
          gender: gender,
          isBanned: isBanned,
          phone: phone);

      await databaseRef.child("users").child(user.uid).set(user.toJson());

      return user;
    } catch (error) {
      throw Exception("Register Failed: $error");
    }
  }

  // Reset Password

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw Exception("Error sending password reset to email: $error");
    }
  }
}
