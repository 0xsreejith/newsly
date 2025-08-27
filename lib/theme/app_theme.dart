import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A73E8);
  static const Color secondaryColor = Color(0xFF34A853);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEA4335);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Color(0xFF202124);
  static const Color onSurface = Color(0xFF202124);
  static const Color onError = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onBackground: onBackground,
        onSurface: onSurface,
        onError: onError,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: onBackground,
        titleTextStyle: TextStyle(
          color: onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ) as CardThemeData,
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        labelStyle: const TextStyle(color: onBackground),
        selectedColor: primaryColor,
        secondaryLabelStyle: const TextStyle(color: onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Responsive layout helpers
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 600 && 
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;
  
  // Responsive padding
  static EdgeInsetsGeometry responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 80, vertical: 20);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }
}
