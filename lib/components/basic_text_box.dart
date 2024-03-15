import 'package:flutter/material.dart';
import 'package:lofo/main.dart';

class BasicTextBox extends StatelessWidget {
  final int maxLength;
  final int? maxLines;
  final TextEditingController textController;
  final String labelText;
  final Function()? onChanged;

  const BasicTextBox({
    super.key,
    required this.maxLength,
    required this.labelText,
    required this.textController,
    this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return TextField(
      controller: textController,
      maxLength: maxLength,
      style: const TextStyle(
        fontSize: 16,
        fontVariations: [FontVariation('wght', 400)],
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(3)),
        fillColor: themeData.colorScheme.surfaceVariant,
        filled: true,
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          fontVariations: const [FontVariation('wght', 400)],
          color: Colors.blueGrey[300],
        ),
        counterText: '',
      ),
      onChanged: (text) {
        (onChanged == null) ? () {} : onChanged!();
      },
    );
  }
}
