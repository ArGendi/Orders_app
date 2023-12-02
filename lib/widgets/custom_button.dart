import 'package:flutter/material.dart';
import 'package:notes/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onClick;
  final Color? bgColor;
  const CustomButton({super.key, required this.text, required this.onClick, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 45,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Colors.green[900],
          foregroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}