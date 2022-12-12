import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/screens/comunity_drawer.dart';
import 'package:reddit_tutorial/features/community/screens/profile_drawer.dart';
import 'package:reddit_tutorial/features/home/delegate/search_home_screen_delegate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void searchCommunity(BuildContext context, WidgetRef ref) {
    showSearch(context: context, delegate: SearchHomeScreenDelegate(ref: ref));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int counter = 0;
    if (kDebugMode) print('home screen: ${counter++}');
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
          IconButton(
            onPressed: () => searchCommunity(context, ref),
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () => openEndDrawer(context),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          })
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Center(child: Text(user.karma.toString())),
    );
  }
}
