import 'package:cyber_clinic/constants/colors.dart';
import 'package:flutter/material.dart';

class BannedUserInfoWidget extends StatelessWidget {
  const BannedUserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You Have been banned by admin. Please contact us.",
        style:
            TextStyle(color: kWeakPasswordColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
