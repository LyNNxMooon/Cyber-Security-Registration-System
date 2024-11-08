import 'package:cyber_clinic/BLoC/auth/auth_cubit.dart';
import 'package:cyber_clinic/BLoC/auth/auth_states.dart';
import 'package:cyber_clinic/BLoC/profile/profile_cubit.dart';
import 'package:cyber_clinic/BLoC/theme/theme_cubit.dart';
import 'package:cyber_clinic/data/models/hive_model.dart';
import 'package:cyber_clinic/firebase/firebase_auth_repo.dart';
import 'package:cyber_clinic/firebase/firebase_profile_repo.dart';
import 'package:cyber_clinic/screens/activate_2fa_screen.dart';
import 'package:cyber_clinic/screens/auth_screen.dart';
import 'package:cyber_clinic/screens/home_screen.dart';
import 'package:cyber_clinic/screens/verify_2fa_screen.dart';
import 'package:cyber_clinic/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final _hiveModel = HiveModel();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(profileRepo: profileRepo),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(isDarkMode: _hiveModel.getTheme()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, currentThemeState) => MaterialApp(
              theme: currentThemeState,
              debugShowCheckedModeBanner: false,
              home: BlocConsumer<AuthCubit, AuthStates>(
                builder: (context, authState) {
                  return authState is Unauthenticated
                      ? const AuthScreen()
                      : authState is Authenticated
                          ? const HomeScreen()
                          : authState is ActivateTwoFA
                              ? ActivateTwoFaScreen(
                                  email: authState.email,
                                )
                              : authState is VerifyTwoFA
                                  ? const Verify2FaScreen()
                                  : const CustomLoadingWidget();
                },

                //for listening errors
                listener: (context, authState) {
                  if (authState is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(authState.message),
                    ));
                  }
                },
              )),
        ));
  }
}
