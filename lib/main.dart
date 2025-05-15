import 'package:flutter/material.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/pages/home.dart';
import 'package:hate_watch/utils/hcolors.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  User.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HateWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: HColors.back,
          primary: HColors.four,
          surface: HColors.back,
          surfaceContainer: HColors.back,
          surfaceTint: HColors.back,
          ),
          iconTheme: const IconThemeData(
          color: HColors.up,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: HColors.four,fontFamily: 'Jersey'),
          bodyMedium: TextStyle(color: HColors.four,fontFamily: 'Jersey', fontSize: 20),
          titleLarge: TextStyle(color: HColors.four,fontFamily: 'Jersey'),
          labelLarge: TextStyle(color: HColors.four,fontFamily: 'Jersey'),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: HColors.sec,
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: 'Jersey'
          ),
        ),
        fontFamily: 'Jersey',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
