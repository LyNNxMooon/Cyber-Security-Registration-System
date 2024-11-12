// ignore_for_file: deprecated_member_use

import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';

import 'package:cyber_clinic/widgets/banned_user_info_widget.dart';
import 'package:cyber_clinic/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final authCubit = context.read<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      drawer: const CustomDrawerWidget(),
      body: authCubit.currentUser?.isBanned ?? false
          ? const BannedUserInfoWidget()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                  children: [item(context), item(context), item(context)]),
            ),
    );
  }

  Widget item(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            spreadRadius: 3, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 3), // Offset of the shadow
          ),
        ], //border corner radius
      ),
    );
  }
}
