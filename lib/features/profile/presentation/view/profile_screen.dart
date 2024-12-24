import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../shared/widgets/profile_card.dart';
import '../../../../shared/widgets/profile_option.dart';
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ProfileInitial) {
          context.go('/login');
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
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
              future: context.read<AuthBloc>().getCurrentUserUseCase(),
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
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Change Profile Picture'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.camera_alt),
                                                    title: const Text(
                                                        'Take a photo'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.photo_library),
                                                    title: const Text(
                                                        'Choose from gallery'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: user
                                                          .profilePictureUrl !=
                                                      null
                                                  ? NetworkImage(
                                                      user.profilePictureUrl!)
                                                  : null,
                                              child:
                                                  user.profilePictureUrl == null
                                                      ? const Icon(Icons.person,
                                                          size: 50)
                                                      : null,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      TextField(
                                        controller: TextEditingController(
                                            text: user.name),
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: TextEditingController(
                                            text: user.email),
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      'Delete Account'),
                                                  content: const Text(
                                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        context
                                                            .read<ProfileBloc>()
                                                            .add(
                                                                DeleteAccountEvent());
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Delete Account',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Save Changes'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: ProfileCard(
                            name: user.name.toString(),
                            email: user.email.toString(),
                            avatarUrl: user.profilePictureUrl,
                          ),
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
                                      await _showLogoutConfirmationDialog(
                                          context);

                                  if (confirmed == true && context.mounted) {
                                    context
                                        .read<AuthBloc>()
                                        .add(SignOutRequested());
                                    context.goNamed('login');
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
