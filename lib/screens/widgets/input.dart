
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        print(value);
      },
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        height: 1.0,
      ),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: 'Full Name',
        filled: true,
        labelStyle: TextStyle(
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50.0),
            right: Radius.circular(50.0),
          ),
        ),
      ),
    );
  }
}
