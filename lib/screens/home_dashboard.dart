import 'package:flutter/material.dart';
import '../components/icons.dart';
import '../components/animations.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../services/auth_service.dart';
import 'package:appwrite/models.dart' as Models;

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int foundCount = 0;
  int lostCount = 0;
  int resolvedCount = 0;
  int _selectedFilterIndex = 0;
  bool _loading = true;
  List<Models.Document> recentDocs = [];

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

  Future<void> _loadHomeData() async {
    try {
      final counts = await AuthService().getItemCounts();
      final docs = await AuthService().listRecentAllItems(limit: 12);
      if (!mounted) return;
      setState(() {
        lostCount = counts['lost'] ?? 0;
        foundCount = counts['found'] ?? 0;
        resolvedCount = counts['resolved'] ?? 0;
        recentDocs = docs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loading
                ? const LinearProgressIndicator(minHeight: 2)
                : const SizedBox.shrink(),

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
                    onTap: () async {
                      setState(() => _selectedFilterIndex = index);
                      final label = f['label'] as String;
                      setState(() => _loading = true);
                      try {
                        List<Models.Document> docs;
                        if (label == 'All') {
                          docs = await AuthService().listRecentAllItems(
                            limit: 12,
                          );
                        } else {
                          docs = await AuthService().listItemsByCategory(
                            label,
                            limit: 12,
                          );
                        }
                        if (!mounted) return;
                        setState(() {
                          recentDocs = docs;
                          _loading = false;
                        });
                      } catch (_) {
                        if (!mounted) return;
                        setState(() => _loading = false);
                      }
                    },
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
                          if (index != 0) f['icon'],
                          if (index != 0) const SizedBox(width: 8),
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
            Text('Recent Items', style: appThemeData.textTheme.headlineSmall),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: recentDocs.length,
              itemBuilder: (context, index) {
                final doc = recentDocs[index];
                final data = doc.data;
                final isFound = data['isFound'] == true;
                final status = isFound ? 'Found' : 'Lost';
                final tint = _statusTint(status);
                final isResolved = data['isResolved'] == true;
                final rowTint = isResolved
                    ? AppColors.success.withValues(alpha: 0.12)
                    : tint;
                final chipText = isResolved ? 'Resolved' : status;
                final title = (data['title'] ?? 'Untitled').toString();
                final location = (data['location'] ?? '-').toString();
                String? thumb;
                final imgs = data['imageIds'];
                if (imgs is List && imgs.isNotEmpty && imgs.first is String) {
                  thumb = AuthService().fileViewUrl(imgs.first as String);
                }
                return FadeIn(
                  duration: Duration(milliseconds: 300 + index * 100),
                  child: Stack(
                    children: [
                      Container(
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
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (thumb != null)
                              SizedBox(
                                height: 92,
                                width: double.infinity,
                                child: Image.network(thumb, fit: BoxFit.cover),
                              )
                            else
                              Container(
                                height: 92,
                                width: double.infinity,
                                color: AppColors.neutralLight,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.neutralMedium,
                                  size: 28,
                                ),
                              ),
                            Container(
                              width: double.infinity,
                              color: rowTint,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          title,
                                          style:
                                              appThemeData.textTheme.bodyLarge,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          location,
                                          style:
                                              appThemeData.textTheme.labelSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      chipText,
                                      style: appThemeData.textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // bookmark removed
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }
}
