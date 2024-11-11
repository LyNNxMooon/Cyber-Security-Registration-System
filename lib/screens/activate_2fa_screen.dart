// ignore_for_file: file_names, deprecated_member_use

import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';

import 'package:cyber_clinic/widgets/button_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ActivateTwoFaScreen extends StatelessWidget {
  const ActivateTwoFaScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtonWidget(
                    function: () => authCubit.activate2Fa(context, email),
                    functionName: "Activate 2 Fa"),
                const SizedBox(height: 30),
                CustomButtonWidget(
                    function: () => authCubit.verify2Fa(context),
                    functionName: "Verify 2 Fa")
              ],
            )),
      ),
    );
  }
}
