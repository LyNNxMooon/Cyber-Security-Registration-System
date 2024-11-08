abstract class PersistentRepo {
  saveRestrictTimer(int lastSecond);

  int? getRestrictTimer();

  saveTimerState(bool isTimer);

  bool? getTimerState();

  saveTheme(bool theme);

  bool? getTheme();
}
