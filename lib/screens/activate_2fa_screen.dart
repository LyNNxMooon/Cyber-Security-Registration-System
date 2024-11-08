// ignore_for_file: file_names, deprecated_member_use

import 'package:cyber_clinic/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';

class ActivateTwoFaScreen extends StatelessWidget {
  const ActivateTwoFaScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                      onPressed: () {
                        Flutter2FA().activate(
                            context: context,
                            appName: "Cyber Clinic",
                            email: email);
                      },
                      child: const Text('Activate 2FA'))),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Flutter2FA()
                        .verify(context: context, page: const HomeScreen()),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Login with 2FA'),
                  ))
            ],
          )),
    );
  }
}
