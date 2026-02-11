import 'package:flutter/material.dart';
import 'package:survey_app/views/all_forms.dart';
import 'package:survey_app/views/auth/login.dart';
import 'package:survey_app/views/survey_input.dart';
import 'package:survey_app/resources/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outlet Interaction Report',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.knaufBlue,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
