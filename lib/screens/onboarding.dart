import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../components/buttons.dart';
import '../components/animations.dart';
import 'home_dashboard.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to Lost & Found',
      'description':
          'Find lost items or upload found items quickly and easily.',
    },
    {
      'title': 'Report Lost Items',
      'description': 'Fill out a simple form to let others know what you lost.',
    },
    {
      'title': 'Upload Found Items',
      'description':
          'Help reunite items with their owners by uploading found items.',
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
        MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildPageContent(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeIn(
            child: Text(
              page['title'] ?? '',
              style: appThemeData.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FadeIn(
            child: Text(
              page['description'] ?? '',
              style: appThemeData.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
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
                : appThemeData.colorScheme.primary.withOpacity(0.3),
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
              onPressed: _nextPage,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
