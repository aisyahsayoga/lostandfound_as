import 'package:flutter/material.dart';

// --- MAIN (Hanya untuk mengetes) ---
void main() {
  runApp(const MaterialApp(home: DemoHomeScreen()));
}

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DATA DUMMY
    final List<Map<String, dynamic>> screens = [
      {'title': 'Onboarding', 'screen': const PlaceholderScreen(title: 'Onboarding'), 'icon': Icons.launch},
      {'title': 'Home Dashboard', 'screen': const PlaceholderScreen(title: 'Home'), 'icon': Icons.home},
      {'title': 'Lost Item Report', 'screen': const PlaceholderScreen(title: 'Lost Item'), 'icon': Icons.report},
      {'title': 'Found Item Upload', 'screen': const PlaceholderScreen(title: 'Found Item'), 'icon': Icons.upload},
      {'title': 'Item Details', 'screen': const PlaceholderScreen(title: 'Details'), 'icon': Icons.details},
      {'title': 'Map View', 'screen': const PlaceholderScreen(title: 'Map'), 'icon': Icons.map},
      {'title': 'Profile Settings', 'screen': const PlaceholderScreen(title: 'Settings'), 'icon': Icons.settings},
    ];

    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lost & Found Demo'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.neutralDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              child: Text(
                'UI/UX Design Concept Demo',
                style: appThemeData.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 8),
            FadeIn(
              child: Text(
                'Tap on any screen below to view the high-fidelity design.',
                style: appThemeData.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: screens.length,
                itemBuilder: (context, index) {
                  final screenData = screens[index];
                  return BounceIn(
                    duration: Duration(milliseconds: 600 + index * 100),
                    child: ScaleOnTap(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => screenData['screen'],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),d
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              screenData['icon'],
                              size: 48,
                              color: AppColors.accentPrimary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              screenData['title'],
                              style: appThemeData.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutralDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET DUMMY PENGGANTI ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Halaman $title')),
    );
  }
}