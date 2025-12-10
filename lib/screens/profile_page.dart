import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import 'my_reports_screen.dart';
import '../components/buttons.dart';
import 'edit_profile_screen.dart';
import 'login.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Guest';
  String userEmail = '';
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

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
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
                  Text(
                    title,
                    style: appThemeData.textTheme.bodyLarge?.copyWith(
                      color: enabled ? null : Colors.grey,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: appThemeData.textTheme.labelSmall?.copyWith(
                        color: enabled ? null : Colors.grey,
                      ),
                    ),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AuthService().authStateChanges,
      initialData: AuthService().currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = user?.name ?? 'Guest User';
        final email = user?.email ?? 'Log in to manage your account';
        final isLoggedIn = user != null;
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accentSecondary,
                      AppColors.accentPrimary,
                    ],
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
                    Builder(
                      builder: (_) {
                        final url = AuthService().fileViewUrl(
                          user?.avatarFileId,
                        );
                        if (url != null) {
                          return CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(url),
                            backgroundColor: Colors.white,
                          );
                        }
                        return CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName,
                      style: appThemeData.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: appThemeData.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Account', style: appThemeData.textTheme.headlineSmall),
              const SizedBox(height: 12),
              _tile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                enabled: isLoggedIn,
                onTap: isLoggedIn
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      }
                    : null,
              ),
              _tile(
                icon: Icons.assignment,
                title: 'My Reports',
                enabled: isLoggedIn,
                onTap: isLoggedIn
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyReportsScreen(),
                          ),
                        );
                      }
                    : null,
              ),
              // Saved Items dihapus sesuai spesifikasi
              
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: PrimaryButton(
                  label: isLoggedIn ? 'Log Out' : 'Login / Register',
                  trailing: isLoggedIn
                      ? const Icon(Icons.logout)
                      : const Icon(Icons.login),
                  fullWidth: true,
                  onPressed: () async {
                    if (!isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                      return;
                    }
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                            'Are you sure you want to log out?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Log Out'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmed == true) {
                      await AuthService().logout();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
