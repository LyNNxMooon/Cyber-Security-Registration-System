import 'package:cyber_clinic/data/vos/app_user_vo.dart';

abstract class AuthRepo {
  Future<AppUserVO?> loginWithEmailAndPassword(String email, String password);

  Future<AppUserVO?> registerAppUser(String name, String email, String password,
      String phone, int age, String gender, bool isBanned);

  Future<void> logout();

  Future<AppUserVO?> getCurrentUser();

  Future<void> resetPassword(String email);
}
