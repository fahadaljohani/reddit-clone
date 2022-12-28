import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/responsive/responsive.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/profile/controller/user_profile_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditUserProfile extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfile({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileState();
}

class _EditUserProfileState extends ConsumerState<EditUserProfile> {
  File? bannerFile;
  File? avatarFile;
  Uint8List? bannerWebFile;
  Uint8List? avatarWebFile;
  late TextEditingController usernameController;

  void udpateUserProfile() {
    if (usernameController.text.isNotEmpty) {
      ref.read(userProfileControllerProvider.notifier).updateUserProfile(
            context,
            bannerFile,
            bannerWebFile,
            avatarFile,
            avatarWebFile,
            usernameController.text.trim(),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    usernameController =
        TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  void pickBanner() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      if (kIsWeb) {
        bannerWebFile = pickedImage.files.first.bytes;
      } else {
        bannerFile = File(pickedImage.files.first.path!);
      }
      setState(() {});
    }
  }

  void pickAvatar() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      if (kIsWeb) {
        avatarWebFile = pickedImage.files.first.bytes;
      } else {
        avatarFile = File(pickedImage.files.first.path!);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    bool isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Profile'.tr(context)),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: udpateUserProfile, child: Text('Save'.tr(context)))
          ]),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Responsive(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: pickBanner,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              radius: const Radius.circular(10),
                              color: currentTheme.textTheme.bodyText1!.color!,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: bannerWebFile != null
                                    ? Image.memory(bannerWebFile!)
                                    : bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : user.banner != Constant.bannerDefault
                                            ? Image.network(user.banner)
                                            : const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 20,
                              bottom: 20,
                              child: GestureDetector(
                                onTap: pickAvatar,
                                child: avatarWebFile != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(avatarWebFile!),
                                        radius: 35,
                                      )
                                    : avatarFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(avatarFile!),
                                            radius: 35,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(user.profilePic),
                                            radius: 35,
                                          ),
                              ))
                        ],
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: 'Name'.tr(context),
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(18)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
