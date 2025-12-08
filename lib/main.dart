import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/theme_data.dart';
import 'screens/onboarding.dart';
import 'screens/main_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- Wajib ada
  await Firebase.initializeApp(); // <-- Inisialisasi Firebase (tanpa options)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost & Found',
      theme: appThemeData,
      home: const MainWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
