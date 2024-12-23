import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../widgets/profile_card.dart';
import '../../../widgets/profile_option.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.getCurrentUserUseCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileCard(
                    name: user.name.toString(),
                    email: user.email.toString(),
                    avatarUrl: user.profilePictureUrl,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const ProfileOption(
                          icon: Icons.security,
                          title: 'Security Settings',
                        ),
                        const ProfileOption(
                          icon: Icons.notifications,
                          title: 'Notifications',
                        ),
                        const ProfileOption(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                        ),
                        ProfileOption(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () async {
                            final confirmed =
                                await _showLogoutConfirmationDialog(context);

                            if (confirmed == true && context.mounted) {
                              context.read<AuthBloc>().add(SignOutRequested());
                              context.go('/login');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No user data available'),
            );
          }
        },
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
