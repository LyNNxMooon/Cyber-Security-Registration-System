// ignore_for_file: deprecated_member_use

import 'package:cyber_clinic/screens/home_screen.dart';
import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';

class Verify2FaScreen extends StatelessWidget {
  const Verify2FaScreen({
    super.key,
  });

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
                    function: () => Flutter2FA()
                        .verify(context: context, page: const HomeScreen()),
                    functionName: "Login with 2 Fa")
              ],
            )),
      ),
    );
  }
}
