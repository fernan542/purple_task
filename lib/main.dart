import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'entities/entities.dart';
import 'globals/globals.dart';
import 'ui/ui.dart';
import 'view_models/view_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path_provider.getApplicationSupportDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(CategoryEntityAdapter())
    ..registerAdapter(TaskEntityAdapter());
  // make sure hive boxes are opened before showing UI
  await Hive.openBox(settingsBox);
  await Hive.openBox<CategoryEntity>(categoryBox);
  await Hive.openBox<TaskEntity>(taskBox);

  // Set app window size
  AppWindowSize _appWindowSize = AppWindowSizePluginBased();
  _appWindowSize.setWindowSize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsViewModel>(
            create: (_) => SettingsViewModel()),
        ChangeNotifierProvider<NewCategoryViewModel>(
            create: (_) => NewCategoryViewModel()),
        ChangeNotifierProvider<CategoryViewModel>(
            create: (_) => CategoryViewModel()),
        ChangeNotifierProvider<TaskViewModel>(create: (_) => TaskViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffe83f6f),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        buttonBarTheme: ButtonBarThemeData(
          alignment: MainAxisAlignment.spaceBetween,
        ),
        textTheme: TextTheme(
          // category name
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
          // hello
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
          ),
          // greetings info
          headline6: TextStyle(
            color: Colors.white70,
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
          // task name,
          // info with number of tasks left for category
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          // dialog title when adding new category
          bodyText1: TextStyle(
            color: Colors.grey[700],
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
          // info text when adding new category
          bodyText2: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.8,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
