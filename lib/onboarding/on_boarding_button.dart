import 'package:flutter/material.dart';
import 'package:lofo/theme/default_theme.dart';

class OnBoardingButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;
  const OnBoardingButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 19,
              color: Colors.black,
              fontFamily: fonts[0],
              fontVariations: const [FontVariation('wght', 700)],
            ),
          ),
        ));
  }
}
