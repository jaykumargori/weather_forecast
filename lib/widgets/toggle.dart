import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  final String label;
  final bool value;
  final void Function(bool)? onChanged;
  const Toggle(
      {super.key, required this.value, this.onChanged, required this.label});

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.label,
        style: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        activeColor: Colors.white,
        value: widget.value,
        onChanged: widget.onChanged,
      ),
    );
  }
}