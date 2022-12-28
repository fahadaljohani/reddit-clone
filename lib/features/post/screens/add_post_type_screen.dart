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
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/community.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  List<Community> communitesList = [];
  Community? selectedCommunity;

  File? bannerFile;
  Uint8List? webBannerFile;

  void shareTextPost() {
    if (descriptionController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context,
          selectedCommunity ?? communitesList[0],
          titleController.text.trim(),
          descriptionController.text.trim());
    } else {
      showSnackBar(context, 'fill up all fields'.tr(context));
    }
  }

  void shareImagePost() {
    if ((bannerFile != null || webBannerFile != null) &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context,
          selectedCommunity ?? communitesList[0],
          titleController.text.trim(),
          bannerFile,
          webBannerFile);
    } else {
      showSnackBar(context, 'fill up all fields'.tr(context));
    }
  }

  void shareLinkPost() {
    if (linkController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context,
          selectedCommunity ?? communitesList[0],
          titleController.text.trim(),
          linkController.text.trim());
    } else {
      showSnackBar(context, 'fill up all fields'.tr(context));
    }
  }

  void save() {
    if (widget.type == 'text') {
      shareTextPost();
    } else if (widget.type == 'image') {
      shareImagePost();
    } else {
      shareLinkPost();
    }
  }

  void pickBanner() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      if (kIsWeb) {
        webBannerFile = pickedFile.files.first.bytes;
      } else {
        bannerFile = File(pickedFile.files.first.path!);
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';

    final isLoading = ref.watch(postControllerProvider);

    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.type.tr(context),
          ),
          actions: [
            TextButton(
              onPressed: save,
              child: Text('share'.tr(context)),
            ),
          ]),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Responsive(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter title here'.tr(context),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isTypeImage)
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
                            child: webBannerFile != null
                                ? Image.memory(webBannerFile!)
                                : bannerFile != null
                                    ? Image.file(
                                        bannerFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: 'Enter description here'.tr(context),
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: const EdgeInsets.all(18)),
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        decoration: InputDecoration(
                          hintText: 'Enter link here'.tr(context),
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text('Select Community'.tr(context)),
                    ref.watch(getUserCommunitiesProvider).when(
                        data: (communities) {
                          communitesList = communities;
                          return communities.isEmpty
                              ? const SizedBox()
                              : Center(
                                  child: DropdownButton(
                                      value:
                                          selectedCommunity ?? communities[0],
                                      items: communities
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e.name)))
                                          .toList(),
                                      onChanged: (community) {
                                        setState(() {
                                          selectedCommunity = community;
                                        });
                                      }),
                                );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader()),
                  ],
                ),
              ),
            ),
    );
  }
}
