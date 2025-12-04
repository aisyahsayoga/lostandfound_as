import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import 'home_dashboard.dart';
import 'lost_item_report.dart';
import 'profile_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0; // default to Home

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
