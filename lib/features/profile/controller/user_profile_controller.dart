import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/enums/enums.dart';
import 'package:reddit_tutorial/core/common/providers/firestorage_repository_provider.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository, ref: ref);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  UserProfileController(
      {required UserProfileRepository userProfileRepository, required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void updateUserProfile(
      BuildContext context,
      File? bannderFile,
      Uint8List? bannerWebFile,
      File? avatarFile,
      Uint8List? avatarWebFile,
      String username) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (bannerWebFile != null) {
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'profile/banner',
            uid: user.uid,
            webFile: bannerWebFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        user = user.copyWith(
          banner: r,
        );
      });
    }
    if (avatarWebFile != null) {
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'profile/profilePic',
            uid: user.uid,
            webFile: avatarWebFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        user = user.copyWith(
          profilePic: r,
        );
      });
    }
    if (bannderFile != null) {
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'profile/banner',
            uid: user.uid,
            file: bannderFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        user = user.copyWith(
          banner: r,
        );
      });
    }
    if (avatarFile != null) {
      final res = await _ref.read(storageRepositoryProvider).storeFile(
            path: 'profile/profilePic',
            uid: user.uid,
            file: avatarFile,
          );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        user = user.copyWith(
          profilePic: r,
        );
      });
    }
    user = user.copyWith(
      name: username,
    );
    final res = await _userProfileRepository.updateUserProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  void updateUserKarma(Karma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);
    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
