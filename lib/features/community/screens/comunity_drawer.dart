import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void navigateToAddCommunity(BuildContext context) {
    Routemaster.of(context).push('/add-community');
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    if (kDebugMode) print('Drawer');
    return SafeArea(
        child: Drawer(
      child: Column(children: [
        GestureDetector(
          onTap: () => navigateToAddCommunity(context),
          child: const ListTile(
            leading: Icon(Icons.add),
            title: Text(
              'create community',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ref.watch(getUserCommunitiesProvider(user.uid)).when(
            data: (communities) {
              return Expanded(
                child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return GestureDetector(
                        onTap: () =>
                            navigateToCommunity(context, community.name),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name}'),
                        ),
                      );
                    }),
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader()),
      ]),
    ));
  }
}
