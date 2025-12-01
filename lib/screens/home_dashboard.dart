import 'package:flutter/material.dart';
import '../components/buttons.dart';
import '../components/cards.dart';
import '../components/icons.dart';
import '../components/animations.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'label': 'Electronics', 'icon': AppIcons.categoryElectronics()},
    {'label': 'Personal Items', 'icon': AppIcons.categoryPersonal()},
    {'label': 'Documents', 'icon': AppIcons.categoryDocuments()},
    {'label': 'Pets', 'icon': AppIcons.categoryPets()},
  ];

  final List<Map<String, String>> recentItems = [
    {
      'title': 'Lost Wallet',
      'subtitle': 'Last seen near Central Park',
      'imageUrl': 'https://via.placeholder.com/400x240.png?text=Lost+Wallet',
      'status': 'Lost',
      'time': '2 hours ago',
    },
    {
      'title': 'Found Dog',
      'subtitle': 'Found around 5th Avenue',
      'imageUrl': 'https://via.placeholder.com/400x240.png?text=Found+Dog',
      'status': 'Found',
      'time': '1 day ago',
    },
  ];

  void _onCategorySelected(String category) {
    // TODO: Implement category filter logic
  }

  void _onItemSelected(String title) {
    // TODO: Implement navigation to item details
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Navigate to different screens based on index
  }

  void _onFabPressed() {
    // TODO: Show modal for quick report
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lost & Found'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.neutralDark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              child: Container(
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
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: AppIcons.search(),
                    hintText: 'Search for items...',
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeIn(
              child: Text(
                'Categories',
                style: appThemeData.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 12),
            FadeIn(
              child: SizedBox(
                height: 120,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ScaleOnTap(
                      onTap: () => _onCategorySelected(category['label']),
                      child: Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category['icon'],
                            const SizedBox(height: 8),
                            Text(
                              category['label'],
                              style: appThemeData.textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeIn(
              child: Text(
                'Recent Items',
                style: appThemeData.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final item = recentItems[index];
                  return FadeIn(
                    duration: Duration(milliseconds: 300 + index * 100),
                    child: EnhancedItemCard(
                      title: item['title']!,
                      subtitle: item['subtitle']!,
                      imageUrl: item['imageUrl']!,
                      status: item['status']!,
                      time: item['time']!,
                      onTap: () => _onItemSelected(item['title']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: AppColors.accentPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 8,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: AppColors.neutralMedium,
        onTap: _onItemTapped,
        backgroundColor: AppColors.surface,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
