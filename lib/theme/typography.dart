import 'package:flutter/material.dart';

class AppTypography {
  // Primary font family definition
  static const String fontFamily = 'Roboto';

  // Text styles for different text elements
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF6F675F), // dark neutral color from palette
    height: 1.25,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6F675F),
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.5,
  );

  static const TextStyle bodyText1 = bodyLarge; // Alias for backward compatibility

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.4,
  );

  static const TextStyle bodyText2 = bodyMedium; // Alias for backward compatibility

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Color(0xFFBEB7AD), // medium neutral color for lower hierarchy
    height: 1.3,
  );

  // New Material 3 text styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.22,
  );

  static const TextStyle headlineLarge = headline1; // Alias for headline1

  static const TextStyle headlineMedium = headline2; // Alias for headline2

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6F675F),
    height: 1.25,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6F675F),
    height: 1.43,
  );

  static const TextStyle bodySmall = caption; // Alias for caption

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Color(0xFFBEB7AD),
    height: 1.45,
  );
}
