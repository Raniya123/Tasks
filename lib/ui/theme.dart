import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const Color bluisClr = Color(0xFF4e5ea8);
  static const Color yellowClr = Color.fromARGB(255, 218, 152, 0);
  static const Color pinkClr = Color.fromARGB(255, 255, 11, 121);
  static const Color primaryClr = bluisClr;
  static const Color darkGreyClr = Color(0xFF121212);
  static const Color darkHeaderClr = Color(0xFF424242);
  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static final light = ThemeData(
    primarySwatch: white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.deepPurple,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      primaryContainer: Colors.deepPurple,
      error: Colors.black,
      onError: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.pink,
      onSurface: Colors.white,
    ),
  );
}

TextStyle get subheadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]));
}
