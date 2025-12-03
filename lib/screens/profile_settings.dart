import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../components/form_fields.dart';
import '../components/buttons.dart';
import '../components/animations.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool notificationsEnabled = true;
  List<String> savedItems = [
    'Lost Wallet',
    'Found Dog',
    'Car Keys',
  ];

  void _toggleNotifications(bool? value) {
    if (value == null) return;
    setState(() {
      notificationsEnabled = value;
    });
  }

  void _onItemTap(String item) {
    // TODO: Navigate to item details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.person, size: 60),
                  ),
                  const SizedBox(height: 12),
                  Text('Username', style: appThemeData.textTheme.headline2),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    value: notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: appThemeData.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Saved Items / Watchlist',
                    style: appThemeData.textTheme.headline2,
                  ),
                  const SizedBox(height: 12),
                  ...savedItems.map((item) {
                    return ListTile(
                      title: Text(item),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _onItemTap(item),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
