// ignore_for_file: use_build_context_synchronously

import 'package:cyber_clinic/BLoC/auth/auth_states.dart';
import 'package:cyber_clinic/data/vos/app_user_vo.dart';
import 'package:cyber_clinic/domain/auth_repository.dart';
import 'package:cyber_clinic/utils/enums.dart';
import 'package:cyber_clinic/utils/navigation_extension.dart';
import 'package:cyber_clinic/widgets/success_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;

  AppUserVO? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  PasswordCondition pwCondition = PasswordCondition.init;
  PhoneCondition phCondition = PhoneCondition.init;

  int attempt = 0;

  bool isRestrictTimerSet = false;

  //check Password Strength

  void checkPasswordCondition(String psw) {
    RegExp regExpForSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp regExpForNumber = RegExp(r'(?=.*?[0-9])');
    RegExp regExpForCapital = RegExp(r'(?=.*?[A-Z])');
    if (!regExpForCapital.hasMatch(psw) ||
        !regExpForNumber.hasMatch(psw) ||
        !regExpForSymbol.hasMatch(psw)) {
      pwCondition = PasswordCondition.error;
    } else if (10 <= psw.length && psw.length < 11) {
      pwCondition = PasswordCondition.weak;
    } else if (11 <= psw.length && psw.length < 14) {
      pwCondition = PasswordCondition.good;
    } else if (psw.length >= 14) {
      pwCondition = PasswordCondition.strong;
    } else {
      pwCondition = PasswordCondition.error;
    }

    emit(Unauthenticated(pwCondition));
  }

  // check user auth state

  void checkAuth() async {
    final AppUserVO? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated(pwCondition));
    }
  }

  //Get current User

  AppUserVO? get currentUser => _currentUser;

  //login user

  Future<bool> login(
      String email, String password, BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        emit(AuthLoading());

        final user = await authRepo.loginWithEmailAndPassword(email, password);

        if (user != null) {
          _currentUser = user;
          //emit(Authenticated(user));
          emit(VerifyTwoFA());
          return true;
        } else {
          Unauthenticated(pwCondition);
          return false;
        }
      } catch (error) {
        emit(AuthError(error.toString()));
        emit(Unauthenticated(pwCondition));

        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter both email and password"),
      ));

      return false;
    }
  }

  //Register user

  Future<void> register(
      String name,
      String email,
      String password,
      String confirmPassword,
      String phone,
      String age,
      String gender,
      BuildContext context) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        age.isEmpty ||
        gender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill out all the fields."),
      ));
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match."),
      ));
    } else if (pwCondition == PasswordCondition.error ||
        phCondition == PhoneCondition.error) {
      return;
    } else {
      pwCondition = PasswordCondition.init;
      phCondition = PhoneCondition.init;
      try {
        emit(AuthLoading());

        final user = await authRepo.registerAppUser(
            name, email, password, phone, int.parse(age), gender, false);

        if (user != null) {
          _currentUser = user;
          emit(ActivateTwoFA(email));
        } else {
          Unauthenticated(pwCondition);
        }
      } catch (error) {
        emit(AuthError(error.toString()));
        emit(Unauthenticated(pwCondition));
      }
    }
  }

  //logout user

  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated(pwCondition));
  }

  // Reset Password

  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter your email."),
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const CupertinoActivityIndicator(),
        ),
      );
      try {
        await authRepo.resetPassword(email).then(
          (value) {
            emit(Unauthenticated(pwCondition));
            context.navigateBack();
            showDialog(
              context: context,
              builder: (context) => const SuccessWidget(
                  message:
                      "We have sent the password Reset link to your email!"),
            );
          },
        );
      } catch (error) {
        emit(AuthError(error.toString()));
      }
    }
  }
}
