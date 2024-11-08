import 'package:cyber_clinic/app.dart';
import 'package:cyber_clinic/config/firebase_options.dart';
import 'package:cyber_clinic/persistent/hive_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox<int>(kBoxNameForLastTimer);
  await Hive.openBox<bool>(kBoxNameForTimerState);
  await Hive.openBox<bool>(kBoxNameForTheme);
  runApp(MyApp());
}
