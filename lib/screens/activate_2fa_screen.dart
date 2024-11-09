// ignore_for_file: file_names, deprecated_member_use

import 'package:cyber_clinic/screens/home_screen.dart';
import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';

class ActivateTwoFaScreen extends StatelessWidget {
  const ActivateTwoFaScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtonWidget(
                    function: () => Flutter2FA().activate(
                        context: context,
                        appName: "Cyber Clinic",
                        email: email),
                    functionName: "Activate 2 Fa"),
                const SizedBox(height: 30),
                CustomButtonWidget(
                    function: () => Flutter2FA()
                        .verify(context: context, page: const HomeScreen()),
                    functionName: "Verify 2 Fa")
              ],
            )),
      ),
    );
  }
}
