import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double size;
  final Color color;

  const Loader({
    super.key,
    this.size = 32.0,
    this.color = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
