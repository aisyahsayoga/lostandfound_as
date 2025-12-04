import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Rafiandra';
  String userEmail = 'rafi@gmail.com';
  bool darkModeEnabled = false;
  String languageSelected = 'English';
  String appVersion = '1.0.0';

  Widget _leadingIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.accentSecondary),
    );
  }

  Widget _profileHeaderCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.accentSecondary, AppColors.accentPrimary],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Text(
              'JD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: appThemeData.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: appThemeData.textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _leadingIcon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: appThemeData.textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: appThemeData.textTheme.labelSmall),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _logoutTile() {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logged out')));
      },
      icon: const Icon(Icons.logout),
      label: const Text('Log Out'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        side: BorderSide(color: AppColors.accentPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.neutralDark,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _profileHeaderCard(),
          const SizedBox(height: 24),
          Text('Account', style: appThemeData.textTheme.headlineSmall),
          const SizedBox(height: 12),
          _tile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile tapped')),
              );
            },
          ),
          _tile(
            icon: Icons.assignment,
            title: 'My Items',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('My Items tapped')));
            },
          ),
          _tile(
            icon: Icons.bookmark_outline,
            title: 'Saved Items',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved Items tapped')),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Settings', style: appThemeData.textTheme.headlineSmall),
          const SizedBox(height: 12),
          _tile(
            icon: Icons.language,
            title: 'Language',
            subtitle: languageSelected,
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Language tapped')));
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _leadingIcon(Icons.dark_mode_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dark Mode',
                    style: appThemeData.textTheme.bodyLarge,
                  ),
                ),
                Switch(
                  value: darkModeEnabled,
                  onChanged: (v) => setState(() => darkModeEnabled = v),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return appThemeData.colorScheme.primary.withValues(
                        alpha: 0.3,
                      );
                    }
                    return Colors.grey.withValues(alpha: 0.3);
                  }),
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return appThemeData.colorScheme.primary;
                    }
                    return appThemeData.colorScheme.secondary;
                  }),
                ),
              ],
            ),
          ),
          _tile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: appVersion,
          ),
          const SizedBox(height: 16),
          _logoutTile(),
        ],
      ),
    );
  }
}
