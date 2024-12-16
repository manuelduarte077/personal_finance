import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);
  final TextEditingController passwordController;

  PasswordField({
    super.key,
    required this.passwordController,
  });

  void toggleVisibility() {
    obscureTextNotifier.value = !obscureTextNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextNotifier,
      builder: (context, obscureText, child) {
        return TextField(
          controller: passwordController,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_clock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleVisibility,
            ),
          ),
        );
      },
    );
  }
}
