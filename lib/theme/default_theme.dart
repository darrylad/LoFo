import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

List<String> fonts = ['Manrope', 'Rubik'];
int fontIndex = 1;
// ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
Color? lightThemeScaffoldBackgroundColor =
    const Color.fromARGB(255, 219, 226, 230);
ColorScheme blueColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    // surfaceVariant: blueColorScheme.background,
    tertiary: blueColorScheme.background,
  ),
  scaffoldBackgroundColor: blueColorScheme.surfaceVariant,

  // textTheme: GoogleFonts.manropeTextTheme(),

  fontFamily: fonts[fontIndex],
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontFamily: fonts[fontIndex],
      fontVariations: const [FontVariation('wght', 400)],
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
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

ColorScheme lightColorScheme = lightThemeData.colorScheme;

// TextStyle? bodyMedium = lightThemeData.textTheme.bodyMedium;
// TextStyle? titleLarge = lightThemeData.textTheme.titleLarge;
// TextStyle? titleSmall = lightThemeData.textTheme.titleSmall;
// TextStyle? titleMedium = lightThemeData.textTheme.titleMedium;

// Color secondaryButtonBackGroundColor =
//     lightThemeData.colorScheme.primary.withOpacity(0.2);

// Color secondaryButtonBackgroundSolidColor =
//     lightThemeData.colorScheme.primaryContainer;

// Color warningPrimaryColor = lightThemeData.colorScheme.error;

// Color backgroundAnimationColor = const Color.fromRGBO(0, 57, 95, 0.627);

// Color secondaryTextColor = Colors.blueGrey[400]!;
// Color primaryTextColor = Colors.blueGrey[700]!;

// TextStyle? bodyMedium = themeData.textTheme.bodyMedium;
// TextStyle? titleLarge = themeData.textTheme.titleLarge;
// TextStyle? titleSmall = themeData.textTheme.titleSmall;
// TextStyle? titleMedium = themeData.textTheme.titleMedium;

// Color secondaryButtonBackGroundColor =
//     themeData.colorScheme.primary.withOpacity(0.2);

// Color secondaryButtonBackgroundSolidColor =
//     themeData.colorScheme.primaryContainer;

Color backgroundAnimationColor = const Color.fromRGBO(0, 57, 95, 0.627);
