import 'package:flutter/material.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';

class BasicButton {
  ThemeMode themeMode = ThemeMode.system;
  static ElevatedButton primaryButton(
      String buttonText, Function()? actionOnPressed) {
    return ElevatedButton(
        onPressed: actionOnPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: themeData.colorScheme.primary,
          foregroundColor: themeData.colorScheme.onPrimary,
          elevation: 0,
          // shadowColor: Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontFamily: fonts[1],
                    fontSize: 15,
                    fontVariations: const [FontVariation('wght', 440)]),
              ),
            ],
          ),
        ));
  }

  static ElevatedButton warningPrimaryButton(
      String buttonText, Function() actionOnPressed) {
    return ElevatedButton(
        onPressed: () {
          actionOnPressed();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: themeData.colorScheme.error,
          foregroundColor: themeData.colorScheme.onError,
          elevation: 0,
          // shadowColor: Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontFamily: fonts[0],
                    fontSize: 15,
                    fontVariations: const [FontVariation('wght', 600)]),
              ),
            ],
          ),
        ));
  }

  static ElevatedButton warningSecondaryButton(
      String buttonText, Function() actionOnPressed) {
    return ElevatedButton(
        onPressed: () {
          actionOnPressed();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: themeData.colorScheme.errorContainer,
          foregroundColor: themeData.colorScheme.error,
          elevation: 0,
          // shadowColor: Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontFamily: fonts[0],
                    fontSize: 15,
                    fontVariations: const [FontVariation('wght', 600)]),
              ),
            ],
          ),
        ));
  }

  static ElevatedButton secondaryButton(
      String buttonText, Function() actionOnPressed) {
    return ElevatedButton(
        onPressed: () {
          actionOnPressed();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: secondaryButtonBackgroundSolidColor,
          foregroundColor: themeData.colorScheme.primary,
          elevation: 0,
          // shadowColor: Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                    fontFamily: fonts[0],
                    fontSize: 15,
                    fontVariations: const [FontVariation('wght', 600)]),
              ),
            ],
          ),
        ));
  }
}

// ElevatedButton basicButton(String buttonText) {
//   return ElevatedButton(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           backgroundColor: secondaryButtonBackGroundColor,
//           elevation: 0,
//           shadowColor: Colors.transparent),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               buttonText,
//               style: const TextStyle(
//                   fontFamily: 'Rubik',
//                   fontSize: 15,
//                   fontVariations: [FontVariation('wght', 600)]),
//             ),
//           ],
//         ),
//       ));
// }
