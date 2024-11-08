import 'package:cyber_clinic/data/vos/app_user_vo.dart';
import 'package:cyber_clinic/utils/enums.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  final AppUserVO user;
  Authenticated(this.user);
}

class VerifyTwoFA extends AuthStates {}

class ActivateTwoFA extends AuthStates {
  final String email;

  ActivateTwoFA(this.email);
}

class Unauthenticated extends AuthStates {
  final PasswordCondition condition;

  Unauthenticated(this.condition);
}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
