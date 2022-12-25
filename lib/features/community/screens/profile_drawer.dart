import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToProfileS(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
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
            onTap: () => navigateToProfileS(context, user.uid),
            title: Text('My Profile'.tr(context)),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            onTap: () => logout(ref),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text('Log Out'.tr(context)),
          ),
          const SizedBox(height: 10),
          Switch.adaptive(
              value: ref.read(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (onChanged) => toggleTheme(ref)),
        ]),
      ),
    );
  }
}
