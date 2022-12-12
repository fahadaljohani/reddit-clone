import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/r/mod-tool/$name');
  }

  void joinCommunity(
      WidgetRef ref, BuildContext context, Community community, String uid) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(context, community, uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) print('community screen: $name');
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      flexibleSpace: Stack(children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ]),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('r/${community.name}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () =>
                                        navigateToModTools(context),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: const Text('Mod Tools'),
                                  )
                                : OutlinedButton(
                                    onPressed: () => joinCommunity(
                                        ref, context, community, user.uid),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: Text(
                                        community.members.contains(user.uid)
                                            ? 'Joined'
                                            : 'Join'),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text('${community.members.length} members'),
                        )
                      ])),
                    ),
                  ];
                },
                body: const Text('Display posts'),
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
