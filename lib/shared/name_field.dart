import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required this.nameController,
    this.prefixIcon,
    this.hintText,
    this.labelText,
  });

  final TextEditingController nameController;

  final IconData? prefixIcon;
  final String? hintText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
