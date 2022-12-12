import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/providers/firestorage_repository_provider.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/repository/community_repository.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
  );
});

final getUserCommunitiesProvider = StreamProvider.autoDispose((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunity();
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityByNameProvider =
    StreamProvider.family.autoDispose((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        super(false);

  void createCommunity(
    String name,
    BuildContext context,
  ) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constant.bannerDefault,
      avatar: Constant.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'community created successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(BuildContext context, File? bannerFile, File? avatarFile,
      Community community) async {
    if (bannerFile != null) {
      state = true;
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'communities/${community.name}',
            uid: '/banner/${community.name}',
            file: bannerFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(
          banner: r,
        );
      });
    }
    if (avatarFile != null) {
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'communities/${community.name}',
            uid: '/avatar/${community.name}',
            file: avatarFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(
          avatar: r,
        );
      });
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'community ${community.name} has been edited');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(
      BuildContext context, Community community, String uid) async {
    final res = await _communityRepository.joinCommunity(community, uid);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(uid)) {
        showSnackBar(context, 'user removed from community');
      } else {
        showSnackBar(context, 'user joined to community');
      }
    });
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      BuildContext context, Community community, List<String> uids) async {
    final res = await _communityRepository.addMods(community, uids);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'add moderator successfully');
      Routemaster.of(context).pop();
    });
  }
}
