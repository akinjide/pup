import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color activeColor;
  final Color inActiveColor;

  const Indicator({
    super.key,
    this.inActiveColor = Colors.white,
    this.activeColor = Colors.white,// const Color(0xFF749BC2),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20.0),
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20.0),
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 0.0),
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }
}