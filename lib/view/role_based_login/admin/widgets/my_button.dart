import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTab;
  final String buttonText;
  final Color? color;
  const MyButton(
      {super.key,
      required this.onTab,
      required this.buttonText,
      this.color = Colors.blueAccent});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        onPressed: onTab,
        child: Text(
          buttonText,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
        ));
  }
}
