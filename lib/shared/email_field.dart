import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        labelText: 'Email',
        hintText: 'Enter your email address',
      ),
    );
  }
}
