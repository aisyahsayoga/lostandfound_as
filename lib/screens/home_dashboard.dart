import 'package:flutter/material.dart';
import '../components/icons.dart';
import '../components/animations.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final TextEditingController searchController = TextEditingController();
  int foundCount = 12;
  int lostCount = 8;
  int resolvedCount = 5;
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'label': 'Electronics', 'icon': AppIcons.categoryElectronics()},
    {'label': 'Personal Items', 'icon': AppIcons.categoryPersonal()},
    {'label': 'Documents', 'icon': AppIcons.categoryDocuments()},
    {'label': 'Apparel', 'icon': AppIcons.categoryApparel()},
  ];

  List<Map<String, dynamic>> get filters => [
    {'label': 'All', 'icon': const Icon(Icons.circle, size: 0)},
    ...categories,
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

  // Removed local bottom navigation handling; navigation is managed by MainWrapper

  Widget _metricCard({
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.accentSecondary),
            ),
            const SizedBox(height: 12),
            Text('$value', style: appThemeData.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: appThemeData.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }

  Color _statusTint(String status) {
    switch (status) {
      case 'Lost':
        return AppColors.error.withValues(alpha: 0.08);
      case 'Found':
        return AppColors.success.withValues(alpha: 0.08);
      default:
        return AppColors.neutralLight;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lost and Found'),
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
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _metricCard(
                  icon: Icons.check_circle_outline,
                  label: 'Resolved',
                  value: resolvedCount,
                ),
                const SizedBox(width: 12),
                _metricCard(
                  icon: Icons.priority_high,
                  label: 'Lost',
                  value: lostCount,
                ),
                const SizedBox(width: 12),
                _metricCard(
                  icon: Icons.search,
                  label: 'Found',
                  value: foundCount,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 68,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                padding: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  final f = filters[index];
                  final selected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.neutralLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          if (index != 0) ...[
                            f['icon'],
                            const SizedBox(width: 8),
                          ],
                          Text(
                            f['label'],
                            style: appThemeData.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Items',
                  style: appThemeData.textTheme.headlineSmall,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.accentPrimary,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'View All',
                      style: appThemeData.textTheme.labelLarge?.copyWith(
                        color: AppColors.accentPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final item = recentItems[index];
                  final tint = _statusTint(item['status']!);
                  return FadeIn(
                    duration: Duration(milliseconds: 300 + index * 100),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: tint,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item['status']!,
                                  style: appThemeData.textTheme.labelLarge,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                item['title']!,
                                style: appThemeData.textTheme.bodyLarge,
                              ),
                              Text(
                                item['subtitle']!,
                                style: appThemeData.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
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
