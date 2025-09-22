import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFBB4430); // Deep burnt orange
  static const Color secondaryColor = Color(0xFF2C3E50); // Dark blue
  static const Color accentColor = Color(0xFFEFC88B);  // Golden accent
  static const Color backgroundColor = Color(0xFFFFF8E7); // Soft cream

  static const Color darkPrimaryColor = Color(0xFFBB4430);
  static const Color darkSecondaryColor = Color(0xFFB0BEC5); // Light blue-grey for dark mode
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark background

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'NotoSans',
    fontWeight: FontWeight.bold,
    color: secondaryColor,
    fontSize: 24,
  );

  static const TextStyle darkHeadingStyle = TextStyle(
    fontFamily: 'NotoSans',
    fontWeight: FontWeight.bold,
    color: darkSecondaryColor,
    fontSize: 24,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'NotoSans',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    textTheme: const TextTheme(
      titleLarge: headingStyle,
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 16),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    fontFamily: 'NotoSans',
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: accentColor,
      surface: darkBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white70,
    ),
    textTheme: const TextTheme(
      titleLarge: darkHeadingStyle,
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
