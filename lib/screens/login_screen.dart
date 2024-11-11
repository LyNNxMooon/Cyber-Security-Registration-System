// ignore_for_file: avoid_print, unused_field

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/config/captcha_config_form.dart';
import 'package:cyber_clinic/constants/colors.dart';
import 'package:cyber_clinic/data/models/hive_model.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:cyber_clinic/widgets/button_widget.dart';
import 'package:cyber_clinic/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:local_captcha/local_captcha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleScreens});

  final void Function()? toggleScreens;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final authCubit = context.read<AuthCubit>();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final CountDownController _controller = CountDownController();

  bool showPassword = true;

  final _hiveModel = HiveModel();

  int lastSecond = -1;

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
  void initState() {
    lastSecond = _hiveModel.getRestrictTimer();
    if (_hiveModel.getTimerState()) authCubit.isRestrictTimerSet = true;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _localCaptchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(50),
                  Text(
                    "Login to tap into Cyber Clinic!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(25),
                  CustomTextField(
                      validator: Validator.email,
                      controller: _emailController,
                      hintText: "Email",
                      isObscure: false),
                  const Gap(10),
                  CustomTextField(
                      minLines: 1,
                      maxLines: 1,
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
                      controller: _passwordController,
                      hintText: "Password",
                      isObscure: showPassword),
                  const Gap(10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => authCubit.resetPassword(
                          _emailController.text, context),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const Gap(30),
                  authCubit.isRestrictTimerSet
                      ? restrictTimerWidget()
                      : const SizedBox(),
                  CustomButtonWidget(
                    functionName: "Login",
                    function: () {
                      setState(() {
                        showCaptcha = true;
                      });
                    },
                  ),
                  showCaptcha ? robotConfirmationWidget() : const SizedBox(),
                  isRobot ? captchaFormWidget(context) : const SizedBox(),
                  const Gap(60),
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
                              text: 'Not a member? ',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          TextSpan(
                              text: 'Register Now',
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

                    if (!(authCubit.isRestrictTimerSet)) {
                      authCubit
                          .login(_emailController.text,
                              _passwordController.text, context)
                          .then(
                        (value) {
                          if (authCubit.attempt >= 3) {
                            authCubit.isRestrictTimerSet = true;
                          }

                          if (!value) {
                            ++authCubit.attempt;
                          }
                        },
                      );
                    }
                  }
                },
                functionName: "Validate Code & Login")
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

  Widget restrictTimerWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Try Login again after : ",
            style: TextStyle(color: kWeakPasswordColor),
          ),
          CircularCountDownTimer(
            duration: lastSecond == -1 ? 60 : lastSecond,
            initialDuration: 0,
            controller: _controller,
            width: 20,
            height: 20,
            ringColor: Colors.transparent,
            fillColor: Colors.transparent,
            textStyle: const TextStyle(
              color: kWeakPasswordColor,
            ),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              _hiveModel.saveTimerState(true);
            },
            onComplete: () {
              setState(() {
                authCubit.attempt = 0;
                authCubit.isRestrictTimerSet = false;
                _hiveModel.saveRestrictTimer(-1);
                _hiveModel.saveTimerState(false);
              });
            },
            onChange: (String timeStamp) {
              _hiveModel.saveRestrictTimer(int.parse(timeStamp));
            },
          ),
        ],
      ),
    );
  }
}
