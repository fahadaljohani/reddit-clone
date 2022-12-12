import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 250,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          user.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 6),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 35,
                        )
                      ],
                    ),
                  ),
                )
              ],
          body: const Text('Body')),
    );
  }
}
