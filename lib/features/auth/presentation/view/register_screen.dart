import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/email_field.dart';
import '../../../../shared/name_field.dart';
import '../../../../shared/password_field.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  File? profilePicture;

  Future<void> pickProfilePicture(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.pushReplacement('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                showCloseIcon: true,
                closeIconColor: theme.colorScheme.onError,
                content: Text(
                  state.message,
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onError,
                  ),
                ),
              ),
            );
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select a profile picture',
                                      style: textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        pickProfilePicture(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        pickProfilePicture(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: profilePicture != null
                              ? Colors.transparent
                              : theme.colorScheme.secondary,
                          child: profilePicture != null
                              ? ClipOval(
                                  child: Image.file(
                                    profilePicture!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  color: theme.colorScheme.secondaryContainer,
                                  size: 48,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Create an Account',
                      style: textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You have an account?',
                          style: textTheme.bodyLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NameField(
                      nameController: nameController,
                      prefixIcon: Icons.person_outline,
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 16),
                    EmailField(
                      emailController: emailController,
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      passwordController: passwordController,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: FilledButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  SignUpRequested(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    profilePicture?.path ?? '',
                                  ),
                                );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
