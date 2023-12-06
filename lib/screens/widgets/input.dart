import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final void Function(String) onChanged;

  const InputField({
    super.key,
    this.initialValue,
    this.hintText,
    required this.onChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: widget.onChanged,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        height: 1.0,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50.0),
            right: Radius.circular(50.0),
          ),
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Field value required.';
      }

        return null;
      },
    );
  }
}
