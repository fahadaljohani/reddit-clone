import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/core/common/responsive/responsive.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityId;
  const CommunityScreen({super.key, required this.communityId});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/r/mod-tool/$communityId');
  }

  void joinCommunity(
      WidgetRef ref, BuildContext context, Community community, String uid) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(context, community, uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(communityId);
    if (kDebugMode) print('community screen: $communityId');

    final user = ref.watch(userProvider)!;
    final isGest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(communityId)).when(
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
                          alignment:
                              window.locale.toString().substring(0, 2) == 'ar'
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (!isGest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () =>
                                          navigateToModTools(context),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text('Mod Tools'.tr(context)),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          ref, context, community, user.uid),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Joined'.tr(context)
                                              : 'Join'.tr(context)),
                                    ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Text(community.members.length.toString()),
                              const SizedBox(width: 3),
                              Text(community.members.length == 1
                                  ? 'member'.tr(context)
                                  : 'members'.tr(context))
                            ],
                          ),
                        )
                      ])),
                    ),
                  ];
                },
                body: ref.watch(getCommunityPostProvider(communityId)).when(
                    data: (posts) {
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          return Responsive(child: PostCard(post: post));
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(text: error.toString()),
                    loading: () => const Loader()),
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
