import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToProfileS(BuildContext context) {
    Routemaster.of(context).push('/u/profile');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 60,
          ),
          const SizedBox(height: 10),
          Text(
            'u/${user.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            onTap: () => navigateToProfileS(context),
            title: const Text('My Profile'),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            onTap: () => logout(ref),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text('Log Out'),
          ),
          const SizedBox(height: 10),
          Switch.adaptive(value: true, onChanged: (onChanged) {}),
        ]),
      ),
    );
  }
}