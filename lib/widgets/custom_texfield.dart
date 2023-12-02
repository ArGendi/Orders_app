import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String text;
  final void Function(String?) onSaved;
  final String? Function(String?)? onValidate;
  final int maxLines;
  final TextInputType keyboardType;
  final String? initial;
  const CustomTextFormField({super.key, required this.text, required this.onSaved, this.maxLines = 1, this.onValidate, this.keyboardType = TextInputType.text, this.initial});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initial,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        labelText: widget.text,
        labelStyle: const TextStyle(
          color: Colors.black54,
        ),
        // enabledBorder: InputBorder.none,
        // focusedBorder: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300
          ), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red.shade300
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red.shade300
          ),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.onValidate,
    );
  }
}
