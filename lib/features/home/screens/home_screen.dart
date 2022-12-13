import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/screens/comunity_drawer.dart';
import 'package:reddit_tutorial/features/community/screens/profile_drawer.dart';
import 'package:reddit_tutorial/features/home/delegate/search_home_screen_delegate.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState {
  int _page = 0;
  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void searchCommunity(BuildContext context, WidgetRef ref) {
    showSearch(context: context, delegate: SearchHomeScreenDelegate(ref: ref));
  }

  void goTo(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

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
      body: Constant.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: (value) => goTo(value),
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
        ],
      ),
    );
  }
}
