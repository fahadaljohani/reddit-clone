import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/core/common/responsive/responsive.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/features/post/widgets/comment_card.dart';
import 'package:routemaster/routemaster.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});
  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  void addComment() {
    if (commentController.text.isEmpty) return;
    ref
        .read(postControllerProvider.notifier)
        .addComment(context, commentController.text.trim(), widget.postId);

    setState(() {
      commentController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).push('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (post) {
            return Responsive(
              child: Column(
                children: [
                  PostCard(post: post),
                  const SizedBox(height: 10),
                  isGest
                      ? const SizedBox()
                      : TextField(
                          onSubmitted: (value) => addComment(),
                          controller: commentController,
                          decoration: InputDecoration(
                              hintText: 'What are your thought?'.tr(context),
                              border: InputBorder.none,
                              filled: true),
                        ),
                  const SizedBox(height: 10),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                      data: (comments) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = comments[index];
                              return CommentCard(comment: comment);
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader()),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => const Loader()),
    );
  }
}
