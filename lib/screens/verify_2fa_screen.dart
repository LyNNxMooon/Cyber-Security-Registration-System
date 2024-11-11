// ignore_for_file: deprecated_member_use

import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';

import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Verify2FaScreen extends StatelessWidget {
  const Verify2FaScreen({
    super.key,
  });

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
                    function: () => authCubit.verify2Fa(context),
                    functionName: "Login with 2 Fa")
              ],
            )),
      ),
    );
  }
}
