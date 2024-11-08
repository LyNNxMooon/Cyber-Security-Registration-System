import 'package:cyber_clinic/data/models/hive_model.dart';
import 'package:cyber_clinic/themes/dark_mode.dart';
import 'package:cyber_clinic/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool isDarkMode;

  final _hiveModel = HiveModel();

  ThemeCubit({required this.isDarkMode})
      : super(isDarkMode ? darkMode : lightMode);

  bool get getMode => isDarkMode;

  void toggleTheme() {
    isDarkMode = !isDarkMode;

    isDarkMode ? emit(darkMode) : emit(lightMode);

    _hiveModel.saveTheme(isDarkMode);
  }
}
