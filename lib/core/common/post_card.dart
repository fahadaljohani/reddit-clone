import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/post.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(
      {required BuildContext context,
      required WidgetRef ref,
      required String postId}) {
    ref.read(postControllerProvider.notifier).deletePost(context, postId);
  }

  void upvotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvotes(post);
  }

  void downvotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvotes(post);
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommentScreen(BuildContext context, String postId) {
    Routemaster.of(context).push('/r/${post.communityName}/comments/$postId');
  }

  void awardPost(BuildContext context, WidgetRef ref, Post post, String award) {
    ref.read(postControllerProvider.notifier).awardPost(context, post, award);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Container(
      decoration: BoxDecoration(color: currentTheme.cardColor),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => navigateToCommunity(context),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(post.communityProfilePic),
                      radius: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'r/${post.communityName}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Pallete.whiteColor),
                          ),
                          GestureDetector(
                            onTap: () => navigateToUserProfile(context),
                            child: Text(
                              'u/${post.username}',
                              style: const TextStyle(
                                  fontSize: 12, color: Pallete.whiteColor),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              if (post.uid == user.uid)
                IconButton(
                    onPressed: () =>
                        deletePost(context: context, ref: ref, postId: post.id),
                    icon: Icon(
                      Icons.delete,
                      color: Pallete.redColor,
                    )),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Pallete.whiteColor),
          ),
          const SizedBox(height: 5),
          if (post.awards.isNotEmpty) ...[
            SizedBox(
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.awards.length,
                itemBuilder: (BuildContext context, int index) {
                  final award = post.awards[index];
                  return Image.asset(
                    Constant.awards[award]!,
                    height: 23,
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 10),
          if (isTypeText)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                post.description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          if (isTypeImage)
            SizedBox(
              height: 220,
              child: Align(
                alignment: Alignment.center,
                child: Image.network(
                  post.link!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (isTypeLink)
            AnyLinkPreview(
                displayDirection: UIDirection.uiDirectionHorizontal,
                link: post.link!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => upvotes(ref),
                    icon: Icon(
                      Constant.up,
                      color: post.upvotes.contains(user.uid)
                          ? Pallete.redColor
                          : Pallete.whiteColor,
                    ),
                  ),
                  Text(
                    post.upvotes.length - post.downvotes.length == 0
                        ? 'Vote'
                        : ('${post.upvotes.length - post.downvotes.length}'),
                    style: const TextStyle(color: Pallete.whiteColor),
                  ),
                  IconButton(
                    onPressed: () => downvotes(ref),
                    icon: Icon(Constant.down,
                        color: post.downvotes.contains(user.uid)
                            ? Pallete.blueColor
                            : Pallete.whiteColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => navigateToCommentScreen(context, post.id),
                child: Row(
                  children: [
                    const Icon(
                      Icons.comment,
                      color: Pallete.whiteColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      post.commentCount == 0
                          ? 'Comment'
                          : post.commentCount.toString(),
                      style: const TextStyle(color: Pallete.whiteColor),
                    ),
                  ],
                ),
              ),
              ref.watch(getCommunityByNameProvider(post.communityName)).when(
                  data: (community) {
                    return community.mods.contains(user.uid)
                        ? IconButton(
                            onPressed: () => deletePost(
                                context: context, ref: ref, postId: post.id),
                            icon: const Icon(
                              Icons.admin_panel_settings,
                              color: Pallete.whiteColor,
                            ),
                          )
                        : const SizedBox();
                  },
                  error: (error, stackTrace) =>
                      ErrorText(text: error.toString()),
                  loading: () => const Loader()),
              IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemCount: user.awards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final award = user.awards[index];
                                    return GestureDetector(
                                      onTap: () =>
                                          awardPost(context, ref, post, award),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                            Constant.awards[award]!),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),
                  icon: const Icon(Icons.card_giftcard_outlined))
            ],
          ),
        ],
      ),
    );
  }
}
