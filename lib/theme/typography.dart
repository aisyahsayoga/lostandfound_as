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

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.5,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6F675F),
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Color(0xFFBEB7AD), // medium neutral color for lower hierarchy
    height: 1.3,
  );
}
