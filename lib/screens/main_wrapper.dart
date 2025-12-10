import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import 'home_dashboard.dart';
import 'lost_item_report.dart';
import 'profile_page.dart';
import 'onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  const MainWrapper({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadOnboardingFlag();
  }

  Future<void> _loadOnboardingFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('hasSeenOnboarding') ?? false;
    setState(() {
      _hasSeenOnboarding = seen;
    });
  }

  final List<Widget> _pages = const [
    HomeDashboardScreen(),
    LostItemReportScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    if (user == null) {
      if (_hasSeenOnboarding == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (_hasSeenOnboarding == false) {
        return const OnboardingScreen();
      }
    }
    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: AppColors.neutralMedium,
        backgroundColor: AppColors.surface,
        elevation: 8,
        items: [
          _navItem(Icons.home, 'Home'),
          _navItem(Icons.add_circle_outline, 'Report'),
          _navItem(Icons.person, 'Profile'),
        ],
      ),
    );
  }
}
