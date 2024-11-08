import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscure,
      this.validator,
      this.suffixIcon,
      this.minLines,
      this.keyboardType,
      this.function,
      this.maxLines});

  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final TextInputType? keyboardType;
  final Validator? validator;
  final IconButton? suffixIcon;
  final int? minLines;
  final int? maxLines;

  final void Function(String)? function;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: function,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator != null
          ? () {
              switch (validator) {
                case Validator.email:
                  return (value) => TextFieldValidator.email(value);

                case Validator.phone:
                  return (value) => TextFieldValidator.phone(value, context);
                case Validator.password:
                  return (value) => TextFieldValidator.password(value, context);
                default:
                  return (value) => TextFieldValidator.defaultEnterV(value);
              }
            }()
          : null,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12)),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12)),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true),
    );
  }
}

class TextFieldValidator {
  static String? password(String? psw, BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    RegExp regExpForSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp regExpForNumber = RegExp(r'(?=.*?[0-9])');
    RegExp regExpForCapital = RegExp(r'(?=.*?[A-Z])');

    if (psw!.isEmpty) {
      authCubit.pwCondition = PasswordCondition.error;
      return 'Please enter password !';
    } else if (psw.length < 10) {
      authCubit.pwCondition = PasswordCondition.error;
      return "Password must be at least 10 digits";
    } else if (!regExpForSymbol.hasMatch(psw)) {
      authCubit.pwCondition = PasswordCondition.error;
      return "Password must contain at least 1 symbol!";
    } else if (!regExpForNumber.hasMatch(psw)) {
      authCubit.pwCondition = PasswordCondition.error;
      return "Password must contain at least 1 number!";
    } else if (!regExpForCapital.hasMatch(psw)) {
      authCubit.pwCondition = PasswordCondition.error;
      return "Password must contain at least 1 Capital letter!";
    }
    return null;
  }

  static String? phone(String? phone, BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    String pattern = r'^(?:[+0]9)?[0-9]{9,12}$';

    RegExp regExp = RegExp(
      pattern,
    );
    if (phone!.isEmpty) {
      authCubit.phCondition = PhoneCondition.error;
      return 'Please enter Phone Number !';
    } else if (!regExp.hasMatch(phone)) {
      authCubit.phCondition = PhoneCondition.error;
      return "Please enter validate Phone Number !";
    } else {
      authCubit.phCondition = PhoneCondition.okay;
    }
    return null;
  }

  static String? email(String? email) {
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email!.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(email)) {
      return "Please enter valid email !";
    }
    return null;
  }

  static String? defaultEnterV([dynamic value, String? validateName]) {
    if (value is String && value.isEmpty) {
      return '$validateName';
    }
    return null;
  }
}
