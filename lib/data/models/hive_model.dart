import 'package:cyber_clinic/persistent/hive_dao.dart';

class HiveModel {
  HiveModel._();
  static final HiveModel _singleton = HiveModel._();
  factory HiveModel() => _singleton;

  final HiveDao _hiveDao = HiveDao();

  void saveRestrictTimer(int lastSecond) =>
      _hiveDao.saveRestrictTimer(lastSecond);

  int getRestrictTimer() => _hiveDao.getRestrictTimer() ?? -1;

  void saveTimerState(bool isTimer) => _hiveDao.saveTimerState(isTimer);

  bool getTimerState() => _hiveDao.getTimerState() ?? false;

  void saveTheme(bool theme) => _hiveDao.saveTheme(theme);

  bool getTheme() => _hiveDao.getTheme() ?? false;
}
