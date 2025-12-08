import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool multiline;
  final TextInputType keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  const TextInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.multiline = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: multiline ? null : 1,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.neutralMedium,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
          ),
          style: AppTypography.bodyLarge,
        ),
      ],
    );
  }
}

class PhotoUploadField extends StatelessWidget {
  final String label;
  final VoidCallback onUploadPressed;
  final VoidCallback onUploadFromGalleryPressed;
  final List<String> photoUrls;
  final List<String> localImagePaths;

  const PhotoUploadField({
    Key? key,
    required this.label,
    required this.onUploadPressed,
    required this.onUploadFromGalleryPressed,
    this.photoUrls = const [],
    this.localImagePaths = const [],
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
            itemCount: localImagePaths.length + photoUrls.length + 2,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final localCount = localImagePaths.length;
              final remoteCount = photoUrls.length;
              if (index < localCount) {
                final path = localImagePaths[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }
              final rIndex = index - localCount;
              if (rIndex < remoteCount) {
                final photoUrl = photoUrls[rIndex];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }
              if (index == localCount + remoteCount) {
                return GestureDetector(
                  onTap: onUploadPressed,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutralMedium),
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              if (index == localCount + remoteCount + 1) {
                return GestureDetector(
                  onTap: onUploadFromGalleryPressed,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutralMedium),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_library,
                            size: 28,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'add foto',
                            style: AppTypography.bodyText1.copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
