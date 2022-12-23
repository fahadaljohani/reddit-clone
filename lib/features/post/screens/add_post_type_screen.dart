import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
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
  Community? selectedCommunity;

  File? bannerFile;

  void shareTextPost() {
    if (descriptionController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty &&
        selectedCommunity != null) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context,
          selectedCommunity!,
          titleController.text.trim(),
          descriptionController.text.trim());
    }
  }

  void shareImagePost() {
    if (selectedCommunity != null &&
        bannerFile != null &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(context,
          selectedCommunity!, titleController.text.trim(), bannerFile!);
    }
  }

  void shareLinkPost() {
    if (selectedCommunity != null &&
        linkController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context,
          selectedCommunity!,
          titleController.text.trim(),
          linkController.text.trim());
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
      bannerFile = File(pickedFile.files.first.path!);
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
      appBar: AppBar(title: Text('Post ${widget.type}'), actions: [
        TextButton(
          onPressed: save,
          child: const Text('share'),
        ),
      ]),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
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
                          child: bannerFile != null
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
                      decoration: const InputDecoration(
                          hintText: 'Enter description here',
                          border: InputBorder.none,
                          filled: true,
                          contentPadding: EdgeInsets.all(18)),
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        hintText: 'Enter link here',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(getUserCommunitiesProvider).when(
                      data: (communities) {
                        return DropdownButton(
                            value: selectedCommunity ?? communities[0],
                            items: communities
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (community) {
                              setState(() {
                                selectedCommunity = community;
                              });
                            });
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader()),
                ],
              ),
            ),
    );
  }
}
