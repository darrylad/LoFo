import 'dart:ui';

import 'package:flutter/material.dart';

class BasicTextBox extends StatelessWidget {
  final int maxLength;
  final TextEditingController textController;
  final String labelText;

  const BasicTextBox({
    super.key,
    required this.maxLength,
    required this.labelText,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLength: maxLength,
      style: const TextStyle(
        fontSize: 16,
        fontVariations: [FontVariation('wght', 400)],
      ),
      maxLines: null,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5)),
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        counterText: '',
      ),
    );
  }
}
