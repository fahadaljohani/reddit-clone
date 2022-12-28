import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/responsive/responsive.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String communityId;
  const EditCommunityScreen({super.key, required this.communityId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? avatarFile;
  Uint8List? bannerwebFile;
  Uint8List? avatarwebFile;

  void pickBanner() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      if (kIsWeb) {
        bannerwebFile = pickedFile.files.first.bytes;
      } else {
        bannerFile = File(pickedFile.files.first.path!);
      }
      setState(() {});
    }
  }

  void pickAvatar() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      if (kIsWeb) {
        avatarwebFile = pickedFile.files.first.bytes;
      } else {
        avatarFile = File(pickedFile.files.first.path!);
      }
      setState(() {});
    }
  }

  void saveCommunity(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(context,
        bannerFile, bannerwebFile, avatarFile, avatarwebFile, community);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return isLoading
        ? const Loader()
        : ref.watch(getCommunityByNameProvider(widget.communityId)).when(
              data: (community) {
                return Scaffold(
                  backgroundColor: currentTheme.backgroundColor,
                  appBar: AppBar(
                    title: Text('Edit Community'.tr(context)),
                    centerTitle: false,
                    actions: [
                      TextButton(
                          onPressed: () => saveCommunity(community),
                          child: Text('Save'.tr(context)))
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 200,
                      child: Responsive(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: pickBanner,
                              child: DottedBorder(
                                dashPattern: const [10, 4],
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                radius: const Radius.circular(10),
                                color: currentTheme.textTheme.bodyText1!.color!,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: bannerwebFile != null
                                      ? Image.memory(bannerwebFile!)
                                      : bannerFile != null
                                          ? Image.file(
                                              bannerFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : community.banner !=
                                                  Constant.bannerDefault
                                              ? Image.network(community.banner)
                                              : const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: kIsWeb ? 0 : 20,
                              child: GestureDetector(
                                onTap: pickAvatar,
                                child: avatarwebFile != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(avatarwebFile!),
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
                                                NetworkImage(community.avatar),
                                            radius: 35,
                                          ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader(),
            );
  }
}
