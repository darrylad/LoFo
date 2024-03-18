import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';
import 'package:popover/popover.dart';

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
      String buttonText, Function()? actionOnPressed) {
    return ElevatedButton(
        onPressed: actionOnPressed,
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
      String buttonText, Function()? actionOnPressed) {
    return ElevatedButton(
        onPressed: actionOnPressed,
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
        onPressed: actionOnPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: themeData.colorScheme.primaryContainer,
          foregroundColor: themeData.colorScheme.onPrimaryContainer,
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

enum ButtonType { primary, secondary, warningPrimary, warningSecondary }

class ConfirmatoryButton extends StatelessWidget {
  final Function()? actionOnPressed;
  final String buttonText;
  final ButtonType buttonType;
  final BuildContext parentContext;

  const ConfirmatoryButton(
      {super.key,
      this.actionOnPressed,
      required this.buttonText,
      required this.buttonType,
      required this.parentContext});

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.primary:
        return confirmatoryButton(
            context,
            themeData.colorScheme.primary,
            themeData.colorScheme.onPrimary,
            BasicButton.primaryButton(
              buttonText,
              actionOnPressed,
            ));
      case ButtonType.secondary:
        return confirmatoryButton(
            context,
            themeData.colorScheme.primaryContainer,
            themeData.colorScheme.onPrimaryContainer,
            BasicButton.primaryButton(
              buttonText,
              actionOnPressed!,
            ));
      case ButtonType.warningPrimary:
        return confirmatoryButton(
            context,
            themeData.colorScheme.error,
            themeData.colorScheme.onError,
            BasicButton.warningPrimaryButton(
              buttonText,
              actionOnPressed!,
            ));

      case ButtonType.warningSecondary:
        return confirmatoryButton(
            context,
            themeData.colorScheme.errorContainer,
            themeData.colorScheme.error,
            BasicButton.warningPrimaryButton(
              buttonText,
              actionOnPressed!,
            ));
    }
  }

  ElevatedButton confirmatoryButton(
    BuildContext context,
    Color backgroundColor,
    Color foregroundColor,
    Widget basicButton,
  ) {
    return ElevatedButton(
        onPressed: (requestUploadStatus.value == RequestUploadStatus.normal &&
                actionOnPressed != null)
            ? () {
                final RenderBox renderBox =
                    parentContext.findRenderObject() as RenderBox;
                final size = renderBox.size;
                showPopover(
                    context: context,
                    width: size.width - 20,
                    transition: PopoverTransition.other,
                    shadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                    backgroundColor: themeData.colorScheme.surface,
                    // barrierColor: Colors.blueGrey[200]!.withOpacity(0.3),
                    barrierColor:
                        themeData.scaffoldBackgroundColor.withOpacity(0.3),
                    radius: 15,
                    arrowWidth: 18,
                    arrowHeight: 10,
                    bodyBuilder: (context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 6),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            (buttonType == ButtonType.warningPrimary ||
                                    buttonType == ButtonType.warningSecondary)
                                ? Text('This can\'t be undone',
                                    style: TextStyle(
                                        fontFamily: fonts[1],
                                        fontSize: 18,
                                        color: themeData
                                            .colorScheme.onSurfaceVariant,
                                        fontVariations: const [
                                          FontVariation('wght', 420)
                                        ]))
                                : Text('Confirm',
                                    style:
                                        TextStyle(
                                            fontFamily: fonts[1],
                                            fontSize: 18,
                                            color: themeData
                                                .colorScheme.onSurfaceVariant,
                                            fontVariations: const [
                                          FontVariation('wght', 420)
                                        ])),
                            const Spacer(),
                            basicButton,
                          ],
                        ),
                      );
                    });
              }
            : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
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
}
