import 'package:flutter/material.dart';
import 'theme/theme_data.dart';
import 'screens/onboarding.dart';

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
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
