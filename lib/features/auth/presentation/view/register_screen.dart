import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/shared/const/app_images.dart';
import 'package:personal_finance/shared/svg_asset_image.dart';

import '../../../../shared/email_field.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Size mediaSize = MediaQuery.sizeOf(context);
    final bool useTwoColumns = mediaSize.height < 500;
    final double spaceFactor = useTwoColumns ? 0.5 : 1;

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
              padding: EdgeInsets.all(24.0 * spaceFactor),
              child: Row(
                children: <Widget>[
                  if (useTwoColumns) ...<Widget>[
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 300),
                      child: SvgAssetImage(
                        assetName: AppImages.verified,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ] else
                    const SizedBox.shrink(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(flex: useTwoColumns ? 1 : 2),
                        Text(
                          'Create an Account',
                          style: textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
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
                        SizedBox(height: 8 * spaceFactor),
                        EmailField(
                          emailController: emailController,
                        ),
                        SizedBox(height: 16 * spaceFactor),
                        PasswordField(
                          passwordController: passwordController,
                        ),
                        SizedBox(height: 8 * spaceFactor),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?'),
                        ),
                        SizedBox(height: 16 * spaceFactor),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: FilledButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(SignInRequested(
                                      emailController.text,
                                      passwordController.text,
                                    ));
                              },
                              child: const Text('Sign Up'),
                            ),
                          ),
                        ),
                        if (!useTwoColumns) ...<Widget>[
                          const Spacer(),
                          Expanded(
                            flex: 10,
                            child: SvgAssetImage(
                              assetName: AppImages.verified,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                        ] else
                          const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
