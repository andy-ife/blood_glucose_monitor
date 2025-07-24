import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    this.borderRadius = 0.0,
    required this.gradient,
    required this.child,
  });
  final Gradient gradient;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child,
      ],
    );
  }
}
