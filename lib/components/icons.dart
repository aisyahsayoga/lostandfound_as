import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/color_palette.dart';

class AppIcons {
  static const double iconSize = 24;

  static Icon categoryElectronics({Color color = AppColors.accentPrimary}) =>
      Icon(Icons.electrical_services, size: iconSize, color: color);

  static Icon categoryPersonal({Color color = AppColors.accentPrimary}) =>
      Icon(Icons.person, size: iconSize, color: color);

  static Icon categoryDocuments({Color color = AppColors.accentPrimary}) =>
      Icon(Icons.description, size: iconSize, color: color);

  static Icon categoryPets({Color color = AppColors.accentPrimary}) =>
      Icon(Icons.pets, size: iconSize, color: color);

  static Icon search({Color color = AppColors.neutralMedium}) =>
      Icon(Icons.search, size: iconSize, color: color);

  static Icon locationPin({Color color = AppColors.accentHighlight}) =>
      Icon(Icons.location_pin, size: iconSize, color: color);

  // Add more icons as needed
}
