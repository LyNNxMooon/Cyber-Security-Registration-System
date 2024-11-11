// ignore_for_file: unused_field

import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';

import 'package:cyber_clinic/config/captcha_config_form.dart';
import 'package:cyber_clinic/constants/colors.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:cyber_clinic/widgets/password_condition_widget.dart';
import 'package:cyber_clinic/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:local_captcha/local_captcha.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.toggleScreens});

  final void Function()? toggleScreens;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _ageController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool showPassword = true;

  String? _selectedGender = "Male";

  bool isRobot = false;

  bool showCaptcha = false;

  final _captchaFormKey = GlobalKey<FormState>();

  final _localCaptchaController = LocalCaptchaController();
  final _configFormData = ConfigFormData();

  var _inputCode = '';

  void validateCaptcha(String value) {
    _localCaptchaController.validate(value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _localCaptchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(40),
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(30),
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(25),
                  CustomTextField(
                      controller: _nameController,
                      hintText: "Name",
                      isObscure: false),
                  const Gap(10),
                  CustomTextField(
                      validator: Validator.email,
                      controller: _emailController,
                      hintText: "Email",
                      isObscure: false),
                  const Gap(10),
                  CustomTextField(
                      validator: Validator.phone,
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      hintText: "Phone",
                      isObscure: false),
                  const Gap(10),
                  CustomTextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      hintText: "Age",
                      isObscure: false),
                  const Gap(10),
                  CustomTextField(
                    function: (password) =>
                        authCubit.checkPasswordCondition(password),
                    validator: Validator.password,
                    minLines: 1,
                    maxLines: 1,
                    controller: _passwordController,
                    hintText: "Password",
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
                  const Gap(10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Male'),
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Female'),
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(25),
                  CustomButtonWidget(
                      functionName: "Register",
                      function: () {
                        setState(() {
                          showCaptcha = true;
                        });
                      }),
                  showCaptcha ? robotConfirmationWidget() : const SizedBox(),
                  isRobot ? captchaFormWidget(context) : const SizedBox(),
                  const Gap(50),
                  Icon(
                    Icons.rocket_launch_sharp,
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                  const Gap(20),
                  GestureDetector(
                    onTap: widget.toggleScreens,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Already a member? ',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          TextSpan(
                              text: 'Login Now',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget captchaFormWidget(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: _captchaFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LocalCaptcha(
              key: ValueKey(_configFormData.toString()),
              controller: _localCaptchaController,
              height: 80,
              width: 200,
              backgroundColor: Colors.grey[100]!,
              chars: _configFormData.chars,
              length: _configFormData.length,
              fontSize: _configFormData.fontSize > 0
                  ? _configFormData.fontSize
                  : null,
              caseSensitive: _configFormData.caseSensitive,
              codeExpireAfter: _configFormData.codeExpireAfter,
              onCaptchaGenerated: (captcha) {
                debugPrint('Generated captcha: $captcha');
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "Enter Code",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != _configFormData.length) {
                          return '* Code must be length of ${_configFormData.length}.';
                        }

                        final validation =
                            _localCaptchaController.validate(value);

                        switch (validation) {
                          case LocalCaptchaValidation.invalidCode:
                            return '* Invalid code.';
                          case LocalCaptchaValidation.codeExpired:
                            return '* Code expired.';
                          case LocalCaptchaValidation.valid:
                            return null;
                        }
                      }

                      return '* Required field.';
                    },
                    onSaved: (value) => _inputCode = value ?? '',
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _localCaptchaController.refresh();
                    },
                    icon: Icon(
                      Icons.replay_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
            const SizedBox(height: 16.0),
            CustomButtonWidget(
                function: () {
                  if (_captchaFormKey.currentState?.validate() ?? false) {
                    _captchaFormKey.currentState!.save();

                    authCubit.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _confirmPasswordController.text,
                        _phoneController.text,
                        _ageController.text,
                        _selectedGender ?? "Male",
                        context);
                  }
                },
                functionName: "Validate Code & Register")
          ],
        ),
      ),
    );
  }

  Widget robotConfirmationWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.only(right: 5),
        width: 300,
        height: 80,
        decoration: BoxDecoration(
            color: kCaptchaColor,
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.primary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  checkColor: kRobotCheckBoxColor,
                  side: BorderSide(color: kRobotCheckBoxColor),
                  value: isRobot,
                  onChanged: (value) {
                    setState(() {
                      isRobot = !(isRobot);
                    });
                  },
                ),
                Text(
                  "I'm not a robot",
                  style: TextStyle(color: kRobotCheckBoxColor),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    "assets/images/reCaptcha.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Privacy-Terms",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 8),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
