import 'package:flutter/material.dart';
import 'theme/theme_data.dart';
import 'screens/main_wrapper.dart';
import 'services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService().init(
    endpoint: 'https://sgp.cloud.appwrite.io/v1',
    projectId: '69381019002f2a88ff96',
    databaseId: '6938117c00204ffcbd56',
    usersCollectionId: 'users',
    itemsCollectionId: 'items',
    bucketId: '69381263000d9cb370bc',
  );
  await AuthService().refreshUser();
  try {
    final prefs = await SharedPreferences.getInstance();
    if (AuthService().currentUser == null) {
      await prefs.setBool('hasSeenOnboarding', false);
    }
  } catch (_) {}
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
