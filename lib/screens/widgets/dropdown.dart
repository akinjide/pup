import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String hintText;
  final Object? value;
  final void Function(String?) onChanged;
  final List<DropdownMenuItem<Object>>? items;

  const Dropdown({
    super.key,
    this.value,
    this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text(widget.hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
        value: widget.value,
        icon: const Icon(Icons.arrow_drop_down_sharp),
        iconEnabledColor: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        items: widget.items,
        onChanged: (Object? value) {
          widget.onChanged(value as String?);
        },
      ),
    );
  }
}
