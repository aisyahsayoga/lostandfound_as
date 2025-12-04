import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final bool enabled;
  final Widget? trailing;
  final bool fullWidth;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.trailing,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: Colors.white,
        textStyle: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fullWidth ? 24 : 12),
        ),
        elevation: enabled ? 6 : 0,
        shadowColor: AppColors.shadow,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: trailing == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text(label), const SizedBox(width: 8), trailing!],
            ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final bool enabled;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentPrimary,
          side: BorderSide(color: AppColors.accentPrimary, width: 2),
          textStyle: AppTypography.bodyText1.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 36),
        ),
        child: Text(label),
      ),
    );
  }
}
