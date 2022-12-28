import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/enums/enums.dart';
import 'package:reddit_tutorial/core/common/providers/firestorage_repository_provider.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/post/repository/post_repository.dart';
import 'package:reddit_tutorial/features/profile/controller/user_profile_controller.dart';
import 'package:reddit_tutorial/models/comment.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:reddit_tutorial/models/post.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
      postRepository: ref.read(postRepositoryProvider),
      storageRepository: ref.read(storageRepositoryProvider),
      ref: ref);
});

final getUserPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getUserPost(communities);
});

final getCommunityPostProvider = StreamProvider.family((ref, String id) {
  return ref.watch(postControllerProvider.notifier).getCommunityPost(id);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(postControllerProvider.notifier).getUserPosts(uid);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostComments(postId);
});

final getGestPostsProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).getGestPosts();
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PostController(
      {required PostRepository postRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);
  void shareTextPost(BuildContext context, Community selectedCommunity,
      String title, String? description) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final postId = const Uuid().v1();
    Post post = Post(
        id: postId,
        title: title,
        type: 'text',
        communityName: selectedCommunity.name,
        communityId: selectedCommunity.id,
        communityProfilePic: selectedCommunity.avatar,
        uid: user.uid,
        username: user.name,
        createdAt: DateTime.now(),
        commentCount: 0,
        description: description ?? '',
        upvotes: [],
        downvotes: [],
        awards: []);

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(Karma.shareText);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'shared successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
    BuildContext context,
    Community selectedCommunity,
    String title,
    File? file,
    Uint8List? webFile,
  ) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final postId = const Uuid().v1();

    final res = await _storageRepository.storeFile(
        path: 'post/${selectedCommunity.name}',
        uid: postId,
        file: file,
        webFile: webFile);

    res.fold((l) => showSnackBar(context, l.message), (r) async {
      Post post;
      post = Post(
        id: postId,
        title: title,
        type: 'image',
        communityName: selectedCommunity.name,
        communityId: selectedCommunity.id,
        communityProfilePic: selectedCommunity.avatar,
        uid: user.uid,
        username: user.name,
        createdAt: DateTime.now(),
        commentCount: 0,
        link: r,
        upvotes: [],
        downvotes: [],
        awards: [],
      );
      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(Karma.shareImage);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Image shared successfully');
        Routemaster.of(context).pop();
      });
    });
  }

  void shareLinkPost(
    BuildContext context,
    Community selectedCommunity,
    String title,
    String link,
  ) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final postId = const Uuid().v1();
    Post post;
    post = Post(
      id: postId,
      title: title,
      type: 'link',
      communityName: selectedCommunity.name,
      communityId: selectedCommunity.id,
      communityProfilePic: selectedCommunity.avatar,
      uid: user.uid,
      username: user.name,
      createdAt: DateTime.now(),
      commentCount: 0,
      link: link,
      upvotes: [],
      downvotes: [],
      awards: [],
    );
    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(Karma.shareLink);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'link shared successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.getUserPost(communities);
    } else {
      return Stream.value([]);
    }
  }

  void deletePost(BuildContext context, String postId) async {
    state = true;
    final res = await _postRepository.deletePost(postId);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(Karma.delete);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'post deleted successfully');
    });
  }

  void upvotes(Post post) {
    String uid = _ref.read(userProvider)!.uid;
    _postRepository.upvotes(post, uid);
  }

  void downvotes(Post post) {
    String uid = _ref.read(userProvider)!.uid;
    _postRepository.downvotes(post, uid);
  }

  Stream<List<Post>> getCommunityPost(String id) {
    return _postRepository.getCommunityPost(id);
  }

  Stream<List<Post>> getUserPosts(uid) {
    return _postRepository.getUserPosts(uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment(BuildContext context, String text, String postId) async {
    final commentId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    Comment comment = Comment(
      id: commentId,
      postId: postId,
      text: text,
      username: user.name,
      userProfilePic: user.profilePic,
      createdAt: DateTime.now(),
    );
    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(Karma.comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _postRepository.getPostComments(postId);
  }

  void awardPost(BuildContext context, Post post, String award) async {
    final user = _ref.read(userProvider)!;
    final res = await _postRepository.awardPost(post, user.uid, award);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(Karma.awardPost);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
    });
  }

  Stream<List<Post>> getGestPosts() {
    return _postRepository.getGestPosts();
  }
}
