import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/app.dart';

import 'package:cyber_clinic/screens/profile_screen.dart';
import 'package:cyber_clinic/screens/settings_screen.dart';
import 'package:cyber_clinic/utils/navigation_extension.dart';
import 'package:cyber_clinic/widgets/drawer_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              CustomDrawerTileWidget(
                title: "H O M E",
                icon: Icons.home,
                function: () {
                  authCubit.checkAuth();
                  context.navigateWithReplacement(MyApp());
                },
              ),
              CustomDrawerTileWidget(
                title: "P R O F I L E",
                icon: Icons.person,
                function: () => context.navigateToNext(ProfileScreen(
                  userID: authCubit.currentUser?.uid ?? "",
                )),
              ),
              CustomDrawerTileWidget(
                title: "S E T T I N G",
                icon: Icons.settings,
                function: () => context.navigateToNext(const SettingsScreen()),
              ),
              const Spacer(),
              CustomDrawerTileWidget(
                  title: "L O G O U T",
                  icon: Icons.logout,
                  function: () {
                    authCubit.logout();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
