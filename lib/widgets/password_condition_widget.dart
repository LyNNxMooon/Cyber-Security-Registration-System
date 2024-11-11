import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/BLoC/auth/auth_states.dart';
import 'package:cyber_clinic/constants/colors.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordConditionWidget extends StatelessWidget {
  const PasswordConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, authState) {
        if (authState is Unauthenticated) {
          if (authState.condition == PasswordCondition.error ||
              authState.condition == PasswordCondition.init) {
            return SizedBox();
          } else {
            return Align(
              alignment: Alignment.centerRight,
              child: Text(
                authState.condition == PasswordCondition.weak
                    ? "Weak!"
                    : authState.condition == PasswordCondition.good
                        ? "Good!"
                        : authState.condition == PasswordCondition.strong
                            ? "Strong!"
                            : "",
                style: TextStyle(
                    color: authState.condition == PasswordCondition.weak
                        ? kWeakPasswordColor
                        : authState.condition == PasswordCondition.good
                            ? kGoodPasswordColor
                            : authState.condition == PasswordCondition.strong
                                ? kStrongPasswordColor
                                : kStrongPasswordColor,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}
