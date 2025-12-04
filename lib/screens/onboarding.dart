import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../components/buttons.dart';
import '../components/animations.dart';
import 'main_wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.search,
      'title': 'Find Lost Items',
      'description':
          "Search through thousands of lost items reported by the community. Filter by category, location, and date to find what you're looking for.",
    },
    {
      'icon': Icons.add_circle_outline,
      'title': 'Report Found Items',
      'description':
          'Found something? Help reunite it with its owner by reporting it on our platform. Upload photos and location details.',
    },
    {
      'icon': Icons.group_outlined,
      'title': 'Connect & Reunite',
      'description':
          'Connect with item owners or finders directly. Our secure platform makes it easy to return lost items to their rightful owners.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildIconBadge(IconData icon) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.neutralLight.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 40, color: AppColors.accentPrimary),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          FadeIn(child: _buildIconBadge(page['icon'] as IconData)),
          const SizedBox(height: 36),
          FadeIn(
            child: Text(
              page['title'] ?? '',
              style: appThemeData.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FadeIn(
            child: Text(
              page['description'] ?? '',
              style: appThemeData.textTheme.bodyLarge!.copyWith(
                color: AppColors.neutralDark.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? appThemeData.colorScheme.primary
                : appThemeData.colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainWrapper(),
                        ),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: appThemeData.textTheme.bodyMedium!.copyWith(
                        color: AppColors.neutralDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _buildPageContent(_pages[index]);
              },
            ),
          ),
          _buildPageIndicator(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: PrimaryButton(
              label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
              trailing: _currentPage == _pages.length - 1
                  ? const Icon(Icons.arrow_right_alt)
                  : null,
              onPressed: _nextPage,
              fullWidth: true,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
