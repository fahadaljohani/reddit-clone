import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/common/failure.dart';
import 'package:reddit_tutorial/core/common/providers/firebase_provider.dart';
import 'package:reddit_tutorial/core/common/type_dev.dart';
import 'package:reddit_tutorial/core/constants/firebase_constant.dart';
import 'package:reddit_tutorial/models/comment.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:reddit_tutorial/models/post.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.read(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPost(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(String postId) async {
    try {
      return right(_posts.doc(postId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid upvotes(Post post, String uid) async {
    try {
      if (post.downvotes.contains(uid)) {
        _posts.doc(post.id).update({
          'downvotes': FieldValue.arrayRemove([uid]),
        });
      }
      if (post.upvotes.contains(uid)) {
        return right(_posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        }));
      } else {
        return right(_posts.doc(post.id).update({
          'upvotes': FieldValue.arrayUnion([uid]),
        }));
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid downvotes(Post post, String uid) async {
    try {
      if (post.upvotes.contains(uid)) {
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        });
      }
      if (post.downvotes.contains(uid)) {
        return right(_posts.doc(post.id).update({
          'downvotes': FieldValue.arrayRemove([uid]),
        }));
      } else {
        return right(_posts.doc(post.id).update({
          'downvotes': FieldValue.arrayUnion([uid]),
        }));
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPost(String communityName) {
    return _posts
        .where('communityName', isEqualTo: communityName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid addComment(Comment comment) async {
    try {
      _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String uid, String award) async {
    try {
      _users.doc(uid).update({
        'awards': FieldValue.arrayRemove([
          [award]
        ])
      });
      _users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award])
      });
      return right(_posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award])
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
