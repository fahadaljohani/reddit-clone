import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/screens/comunity_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) print('home');
    final user = ref.read(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => openDrawer(context),
            icon: const Icon(Icons.menu),
          ),
        ),
        title: const Text('Home'),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
          )
        ],
      ),
      drawer: const CommunityDrawer(),
      body: Center(child: Text(user.karma.toString())),
    );
  }
}
