import 'dart:ui';
import 'package:flutter/material.dart';

class BasicTextFormField extends StatefulWidget {
  final int maxLength;
  final int? maxLines;
  final TextEditingController textController;
  final String labelText;
  final bool isRequiredField;
  final ValueChanged<bool>? onValidChanged;
  final Function()? onChanged;
  final bool? readOnly;
  final Function()? onTap;

  const BasicTextFormField({
    super.key,
    required this.maxLength,
    required this.textController,
    required this.labelText,
    required this.isRequiredField,
    this.maxLines,
    this.onValidChanged,
    this.onChanged,
    this.readOnly,
    this.onTap,
  });

  @override
  State<BasicTextFormField> createState() => _BasicTextFormFieldState();
}

class _BasicTextFormFieldState extends State<BasicTextFormField> {
  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    widget.onValidChanged?.call(widget.textController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      readOnly: widget.readOnly ?? false,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      style: const TextStyle(
        fontSize: 16,
        fontVariations: [FontVariation('wght', 400)],
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5)),
        fillColor: Colors.white,
        filled: true,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          fontVariations: const [FontVariation('wght', 400)],
          color: Colors.blueGrey[300],
        ),
        counterText: '',
      ),
      onChanged: (text) {
        widget.onChanged!();
      },
      onTap: widget.onTap,
      validator: (value) {
        // if (widget.isRequiredField) {
        //   if (value == null || value.isEmpty) {
        //     return 'This field is required.';
        //   }
        // }
        // return null;

        // bool isValid = value != null && value.isNotEmpty;
        // onValidChanged?.call(isValid);
        // debugPrint('isValid: $isValid');
        // return isValid ? null : 'This field is required.';
        if (widget.isRequiredField) {
          bool isValid = value != null && value.isNotEmpty;
          widget.onValidChanged?.call(isValid);
          return isValid ? null : 'This field is required.';
        }
        return null;
      },
    );
  }
}
