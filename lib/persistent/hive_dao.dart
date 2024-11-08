import 'package:cyber_clinic/domain/persistent_repository.dart';
import 'package:cyber_clinic/persistent/hive_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDao implements PersistentRepo {
  HiveDao._();
  static final HiveDao _singleton = HiveDao._();
  factory HiveDao() => _singleton;

  Box<int> getLastTimerBox() => Hive.box<int>(kBoxNameForLastTimer);
  Box<bool> getTimerStateBox() => Hive.box<bool>(kBoxNameForTimerState);
  Box<bool> getThemeBox() => Hive.box(kBoxNameForTheme);

  @override
  int? getRestrictTimer() => getLastTimerBox().get(kHiveKeyForLastTimer);

  @override
  saveRestrictTimer(int lastSecond) =>
      getLastTimerBox().put(kHiveKeyForLastTimer, lastSecond);

  @override
  bool? getTimerState() => getTimerStateBox().get(kHiveKeyForTimerState);

  @override
  saveTimerState(bool isTimer) =>
      getTimerStateBox().put(kHiveKeyForTimerState, isTimer);

  @override
  bool? getTheme() => getThemeBox().get(kHiveKeyForTheme);

  @override
  saveTheme(bool theme) => getThemeBox().put(kHiveKeyForTheme, theme);
}
