import 'package:flutter/material.dart';

class Padding16Symmetric extends StatelessWidget {
  const Padding16Symmetric({
    super.key,
    this.horizontalSize = 16.0,
    required this.child,
  });

  final double horizontalSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: horizontalSize),
      child: child,
    );
  }
}
