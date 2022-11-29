import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/common/failure.dart';
import 'package:reddit_tutorial/core/common/type_dev.dart';
import 'package:reddit_tutorial/core/constants/firebase_constant.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:reddit_tutorial/providers/firebase_provider.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(
    Community community,
  ) async {
    try {
      final communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'community with the same name already exists';
      }
      return right(_communities.doc(community.id).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      final List<Community> communities = [];
      for (var community in event.docs) {
        communities.add(
          Community.fromMap(community.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
