import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/utils/utils.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
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
  late TextEditingController usernameController;

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
      setState(() {
        bannerFile = File(pickedImage.files.first.path!);
      });
    }
  }

  void pickAvatar() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        avatarFile = File(pickedImage.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Proifle'),
          centerTitle: false,
          actions: [TextButton(onPressed: () {}, child: const Text('Save'))]),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                      color: Pallete.whiteColor,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: bannerFile != null
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
                        child: avatarFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(avatarFile!),
                                radius: 35,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 35,
                              ),
                      ))
                ],
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(18)),
            )
          ],
        ),
      ),
    );
  }
}
