import 'package:cyber_clinic/data/vos/app_user_vo.dart';

abstract class ProfileRepo {
  Future<AppUserVO?> fetchUserProfile(String uid);

  Future<void> updateUserProfile(AppUserVO updatedProfile);
}
