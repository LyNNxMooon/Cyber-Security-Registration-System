import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/BLoC/profile/profile_cubit.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:cyber_clinic/widgets/password_condition_widget.dart';
import 'package:cyber_clinic/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final authCubit = context.read<AuthCubit>();

  late final profileCubit = context.read<ProfileCubit>();

  bool showPassword = false;

  final _oldPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Change Your Password"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: ListView(
          children: [
            CustomTextField(
              minLines: 1,
              maxLines: 1,
              controller: _oldPasswordController,
              hintText: "Old Password",
              isObscure: showPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    showPassword = !showPassword;
                    setState(() {});
                  },
                  icon: showPassword
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )),
            ),
            const Gap(10),
            CustomTextField(
              function: (password) =>
                  authCubit.checkPasswordCondition(password),
              validator: Validator.password,
              minLines: 1,
              maxLines: 1,
              controller: _newPasswordController,
              hintText: "New Password",
              isObscure: showPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    showPassword = !showPassword;
                    setState(() {});
                  },
                  icon: showPassword
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )),
            ),
            PasswordConditionWidget(),
            const Gap(10),
            CustomTextField(
              minLines: 1,
              maxLines: 1,
              controller: _confirmPasswordController,
              hintText: "Confirm Password",
              isObscure: showPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    showPassword = !showPassword;
                    setState(() {});
                  },
                  icon: showPassword
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )),
            ),
            const Gap(25),
            CustomButtonWidget(
                function: () {
                  profileCubit.changePassword(
                      _oldPasswordController.text,
                      _newPasswordController.text,
                      _confirmPasswordController.text,
                      context);
                },
                functionName: "Update your password")
          ],
        ),
      ),
    ));
  }
}
