import 'package:flutter/material.dart';
import 'package:lofo/main.dart';

class BasicTextBox extends StatelessWidget {
  final int maxLength;
  final int? maxLines;
  final TextEditingController textController;
  final String? labelText;
  final Function()? onChanged;
  final bool? readOnly;
  final String? hintText;

  const BasicTextBox(
      {super.key,
      required this.maxLength,
      this.labelText,
      required this.textController,
      this.maxLines,
      this.onChanged,
      this.readOnly,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return TextField(
      controller: textController,
      readOnly: readOnly ?? false,
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
        fillColor: themeData.colorScheme.tertiary,
        filled: true,
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          fontVariations: const [FontVariation('wght', 400)],
          color: Colors.blueGrey[300],
        ),
        counterText: '',
        hintText: hintText,
      ),
      onChanged: (text) {
        (onChanged == null) ? () {} : onChanged!();
      },
    );
  }
}
