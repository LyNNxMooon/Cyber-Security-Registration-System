import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/BLoC/profile/profile_cubit.dart';
import 'package:cyber_clinic/BLoC/profile/profile_states.dart';
import 'package:cyber_clinic/data/vos/app_user_vo.dart';
import 'package:cyber_clinic/screens/edit_profile_screen.dart';
import 'package:cyber_clinic/utils/navigation_extension.dart';
import 'package:cyber_clinic/widgets/banned_user_info_widget.dart';
import 'package:cyber_clinic/widgets/loading_widget.dart';
import 'package:cyber_clinic/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userID});

  final String userID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final profileCubit = context.read<ProfileCubit>();
  late final authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    authCubit.checkAuth();
    profileCubit.fetchUserProfile(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return CustomLoadingWidget();
        } else if (profileState is ProfileLoaded) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(profileState.userProfile.name),
                foregroundColor: Theme.of(context).colorScheme.primary,
                actions: [
                  IconButton(
                      onPressed: () {
                        bool isUserBanned =
                            authCubit.currentUser?.isBanned ?? false;
                        if (!isUserBanned) {
                          context.navigateToNext(EditProfileScreen(
                            userProfile: profileState.userProfile,
                          ));
                        }
                      },
                      icon: Icon(
                        Icons.settings,
                      ))
                ],
              ),
              body: authCubit.currentUser?.isBanned ?? false
                  ? const BannedUserInfoWidget()
                  : profileWidget(context, profileState.userProfile),
            ),
          );
        } else {
          return SafeArea(
              child: Scaffold(
            body: Center(
              child: Text("No Profile found..."),
            ),
          ));
        }
      },
    );
  }

  Widget profileWidget(BuildContext context, AppUserVO user) {
    return Center(
      child: Column(
        children: [
          Text(
            user.email,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const Gap(25),
          ProfileImageWidget(),
          const Gap(25),
          userInfoWidget("Bio", user.bio.isEmpty ? "Empty bio..." : user.bio),
          const Gap(25),
          userInfoWidget("Phone", user.phone.isEmpty ? " - " : user.phone),
          const Gap(25),
          userInfoWidget("Age", user.age.toString()),
          const Gap(25),
        ],
      ),
    );
  }

  Widget userInfoWidget(String title, String info) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        const Gap(25),
        Container(
          padding: const EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12)),
          width: double.infinity,
          child: Text(
            info,
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ],
    );
  }
}
