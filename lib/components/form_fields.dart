import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool multiline;
  final TextInputType keyboardType;

  const TextInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.multiline = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyText1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: multiline ? null : 1,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          style: AppTypography.bodyText1,
        ),
      ],
    );
  }
}

class PhotoUploadField extends StatelessWidget {
  final String label;
  final VoidCallback onUploadPressed;
  final List<String> photoUrls;

  const PhotoUploadField({
    Key? key,
    required this.label,
    required this.onUploadPressed,
    this.photoUrls = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyText1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDark,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == photoUrls.length) {
                // Upload button
                return GestureDetector(
                  onTap: onUploadPressed,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutralMedium),
                    ),
                    child: const Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                  ),
                );
              }
              final photoUrl = photoUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photoUrl, width: 100, height: 100, fit: BoxFit.cover),
              );
            },
          ),
        ),
      ],
    );
  }
}
