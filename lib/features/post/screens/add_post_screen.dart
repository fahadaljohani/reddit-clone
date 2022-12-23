import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToAddPost(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    double cardWidthHight = 120;
    double iconSize = 60;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => navigateToAddPost(context, 'image'),
            child: SizedBox(
              height: cardWidthHight,
              width: cardWidthHight,
              child: Card(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToAddPost(context, 'text'),
            child: SizedBox(
              height: cardWidthHight,
              width: cardWidthHight,
              child: Card(
                child: Icon(
                  Icons.font_download,
                  size: iconSize,
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToAddPost(context, 'link'),
            child: SizedBox(
              height: cardWidthHight,
              width: cardWidthHight,
              child: Card(
                child: Icon(
                  Icons.link,
                  size: iconSize,
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
