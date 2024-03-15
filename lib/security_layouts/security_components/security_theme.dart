import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

List<String> fonts = ['Manrope', 'Rubik'];
int fontIndex = 1;
// ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
Color? securityThemeScaffoldBackgroundColor = Colors.blueGrey[50];

ThemeData securityThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
  scaffoldBackgroundColor: securityThemeScaffoldBackgroundColor,
  // textTheme: GoogleFonts.manropeTextTheme(),

  fontFamily: fonts[fontIndex],
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontFamily: fonts[fontIndex],
      fontVariations: const [FontVariation('wght', 400)],
    ),
    titleLarge: TextStyle(
      fontSize: 25,
      fontFamily: fonts[0],
      fontVariations: const [FontVariation('wght', 700)],
    ),
    titleSmall: TextStyle(
      fontFamily: fonts[0],
      fontVariations: const [FontVariation('wght', 500)],
    ),
    titleMedium: TextStyle(
      fontSize: 40,
      fontFamily: fonts[0],
      fontVariations: const [FontVariation('wght', 600)],
    ),
  ),
);

ColorScheme securityColorScheme = securityThemeData.colorScheme;

TextStyle? bodyMedium = securityThemeData.textTheme.bodyMedium;
TextStyle? titleLarge = securityThemeData.textTheme.titleLarge;
TextStyle? titleSmall = securityThemeData.textTheme.titleSmall;
TextStyle? titleMedium = securityThemeData.textTheme.titleMedium;

Color secondaryButtonBackGroundColor =
    securityThemeData.colorScheme.primary.withOpacity(0.2);

Color secondaryButtonBackgroundSolidColor =
    securityThemeData.colorScheme.primaryContainer;

Color warningPrimaryColor = securityThemeData.colorScheme.error;

Color backgroundAnimationColor = const Color.fromRGBO(0, 57, 95, 0.627);

Color secondaryTextColor = Colors.blueGrey[400]!;
Color primaryTextColor = Colors.blueGrey[700]!;
