import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB2EBF2),
            Color(0xFFB2EBF2),
            Color(0xFFFFF9C4),
            Color(0xFFFFF9C4),
            Color(0xFFFCE4EC),
            Color(0xFFFFF3E0),
          ],
        ),
      ),
      child: child,
    );
  }
}
