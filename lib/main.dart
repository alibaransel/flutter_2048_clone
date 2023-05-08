import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/constants/app_themes.dart';
import 'package:flutter_2048_clone/ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
