// ignore_for_file: use_build_context_synchronously

import 'package:cyber_clinic/BLoC/profile/profile_states.dart';
import 'package:cyber_clinic/domain/profile_repository.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:cyber_clinic/utils/navigation_extension.dart';
import 'package:cyber_clinic/widgets/success_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/vos/app_user_vo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  PasswordCondition pwCondition = PasswordCondition.init;

  //Fetch User Profile

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await profileRepo.fetchUserProfile(uid);

      user == null
          ? emit(ProfileError("User not found"))
          : emit(ProfileLoaded(user));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  //Update user profile

  Future<void> updateUserProfile(
      {required String uid,
      required String newBio,
      required String newName,
      required BuildContext context}) async {
    if (newBio.isNotEmpty && newName.isNotEmpty) {
      emit(ProfileLoading());

      try {
        final currentUser = await profileRepo.fetchUserProfile(uid);

        if (currentUser == null) {
          emit(ProfileError("Failed to fetch user to update profile"));
          return;
        }

        final updatedProfile = AppUserVO(
            uid: uid,
            email: currentUser.email,
            name: newName,
            bio: newBio,
            age: currentUser.age,
            gender: currentUser.gender,
            isBanned: currentUser.isBanned,
            phone: currentUser.phone);

        await profileRepo.updateUserProfile(updatedProfile);

        await fetchUserProfile(uid);
      } catch (error) {
        emit(ProfileError("Error updating profile : $error"));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill both new bio and name"),
      ));
    }
  }

  //Change Password

  Future<void> changePassword(String oldPassword, String newPassword,
      String confirmPassword, BuildContext context) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fill the password fields!"),
      ));
    } else if (pwCondition == PasswordCondition.error) {
      return;
    } else if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match."),
      ));
    } else {
      pwCondition = PasswordCondition.init;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            padding: EdgeInsets.all(10),
            child: CupertinoActivityIndicator(),
          ),
        ),
      );

      try {
        await profileRepo.changePassword(oldPassword, newPassword).then(
          (value) {
            context.navigateBack();
            showDialog(
              context: context,
              builder: (context) =>
                  SuccessWidget(message: "Password updated Successfully!"),
            ).then(
              (value) => context.navigateBack(),
            );
          },
        );
      } catch (error) {
        context.navigateBack();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error Updating password: $error"),
        ));
      }
    }
  }
}
