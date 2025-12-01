import 'package:flutter/material.dart';
import 'theme/theme_data.dart';
import 'screens/demo_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost & Found',
      theme: appThemeData,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
