import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

List<String> fonts = ['Manrope', 'Rubik'];
int fontIndex = 1;
// ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
Color? darkThemeScaffoldBackgroundColor = const Color.fromARGB(255, 30, 41, 53);
// ColorScheme darkBlueColorScheme =
//     ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
    tertiary: darkThemeScaffoldBackgroundColor,
  ),

  // scaffoldBackgroundColor:
  //     ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)
  //         .secondaryContainer,

  scaffoldBackgroundColor: const Color.fromARGB(255, 11, 14, 16),

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

// ColorScheme darkColorScheme = darkThemeData.colorScheme;

// TextStyle? bodyMedium = darkThemeData.textTheme.bodyMedium;
// TextStyle? titleLarge = darkThemeData.textTheme.titleLarge;
// TextStyle? titleSmall = darkThemeData.textTheme.titleSmall;
// TextStyle? titleMedium = darkThemeData.textTheme.titleMedium;

// Color secondaryButtonBackGroundColor =
//     darkThemeData.colorScheme.primary.withOpacity(0.2);

// Color secondaryButtonBackgroundSolidColor =
//     darkThemeData.colorScheme.primaryContainer;

// Color warningPrimaryColor = darkThemeData.colorScheme.error;

// Color backgroundAnimationColor = const Color.fromRGBO(0, 57, 95, 0.627);

// Color secondaryTextColor = Colors.blueGrey[400]!;
// Color primaryTextColor = Colors.blueGrey[700]!;
