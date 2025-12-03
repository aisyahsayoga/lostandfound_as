import 'package:flutter/material.dart';
import '../components/buttons.dart';
import '../components/animations.dart';
import '../theme/color_palette.dart';
import '../theme/theme_data.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final VoidCallback onContactPressed;

  const ItemDetailsScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.onContactPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeIn(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, height: 240, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
            FadeIn(
              child: Text(title, style: appThemeData.textTheme.displayLarge),
            ),
            const SizedBox(height: 12),
            FadeIn(
              child: Text(description, style: appThemeData.textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            FadeIn(
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Map with pin at: $location',
                    style: appThemeData.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeIn(
              child: PrimaryButton(
                label: 'Contact / Claim',
                onPressed: onContactPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
