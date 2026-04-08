//________________________________________________________________
// CONSTANTS: layout and constant values
//________________________________________________________________


import 'package:flutter/material.dart';  // Import Flutter Material library for UI widgets and themes                                                          // rootBundel is needet to have access to "-access" files

// App Title and Version
const String appName = "GymTracker";
const String appVersion = "1.0.0";

const double kgToLb = 2.20462;


// Define Colors for Light and Dark mode
final lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF607D8B),           // Define primary color
  onPrimary: Colors.white,              // Define color for text/icons on primary color
  secondary: Color(0xFF546E7A),
  onSecondary: Colors.white,
  error: Color(0xFFB00020),
  onError: Colors.white,
  surface: Colors.white,                // Define surface color (e.g., card backgrounds)
  onSurface: Color(0xFF1C1B1F),         // Define color for text/icons on surface color
);

final darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF607D8B),
  onPrimary: Color(0xFF121212),
  secondary: Color(0xFF546E7A),
  onSecondary: Colors.black,
  error: Color(0xFFCF6679),
  onError: Colors.black,
  surface: Color(0xFF121212),
  onSurface: Colors.white,
);

class AppColors {
  static Color progressUp(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.greenAccent
          : Colors.green;

  static Color progressDown(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.orangeAccent
          : Colors.orange;

  static Color progressEqual(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blueAccent
          : Colors.blue;

  static Color alert(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.redAccent
          : Colors.red.shade900;
}