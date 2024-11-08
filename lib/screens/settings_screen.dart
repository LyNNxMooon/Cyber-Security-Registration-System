import 'package:cyber_clinic/BLoC/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();

    bool isDarkMode = themeCubit.isDarkMode;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Settings")),
        body: Column(
          children: [
            ListTile(
              title: const Text("Dark Mode"),
              trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) => themeCubit.toggleTheme(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
