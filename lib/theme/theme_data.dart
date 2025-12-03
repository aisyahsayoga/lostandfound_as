import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'typography.dart';
import 'text_theme.dart';

final ThemeData appThemeData = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme(
    primary: AppColors.accentPrimary,
    primaryContainer: AppColors.accentSecondary,
    secondary: AppColors.accentHighlight,
    secondaryContainer: AppColors.accentSecondary,
    surface: AppColors.surface,
    background: AppColors.background,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.neutralDark,
    onBackground: AppColors.neutralDark,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  fontFamily: AppTypography.fontFamily,
  textTheme: appTextTheme,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    iconTheme: IconThemeData(color: AppColors.accentPrimary),
    elevation: 0,
    titleTextStyle: AppTypography.headline2,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTypography.bodyLarge,
      elevation: 4,
      shadowColor: AppColors.shadow,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutralLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: AppTypography.bodyText2.copyWith(color: AppColors.neutralMedium),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  ),

  visualDensity: VisualDensity.adaptivePlatformDensity,
);
