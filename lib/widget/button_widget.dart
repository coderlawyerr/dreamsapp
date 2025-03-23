import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSaving;

  const CustomButton({super.key, required this.text, required this.onPressed, this.isSaving = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSaving ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff73544C),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial', // Google Fonts kullanmadan font değiştirme
        ),
      ),
      child:
          isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Arial')),
    );
  }
}
