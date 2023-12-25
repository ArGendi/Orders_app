import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String text;
  final void Function(String?) onSaved;
  final String? Function(String?)? onValidate;
  final int maxLines;
  final TextInputType keyboardType;
  final String? initial;
  final Widget? prefix;
  final String? suffixText;
  final bool obscureText;
  const CustomTextFormField({super.key, required this.text, required this.onSaved, this.maxLines = 1, this.onValidate, this.keyboardType = TextInputType.text, this.initial, this.prefix, this.suffixText, this.obscureText = false});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: visible,
      initialValue: widget.initial,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        suffixText: widget.suffixText,
        suffixIcon: widget.obscureText == true ? IconButton(
          onPressed: (){
            setState(() {
              visible = !visible;
            });
          },
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        ) : null,
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
            color: Colors.grey.shade400
          ), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red.shade400
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red.shade400
          ),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.onValidate,
    );
  }
}
