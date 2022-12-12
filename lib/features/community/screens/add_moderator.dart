import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:reddit_tutorial/models/community.dart';

class AddModeratorScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModeratorScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddModeratorScreenState();
}

class _AddModeratorScreenState extends ConsumerState<AddModeratorScreen> {
  List<String> uids = [];
  int ctl = 0;

  void addUid(String uid) {
    uids.add(uid);
    setState(() {});
  }

  void removedUid(String uid) {
    uids.remove(uid);
    setState(() {});
  }

  void addMods(Community community) {
    if (uids.isEmpty) return;
    ref
        .read(communityControllerProvider.notifier)
        .addMods(context, community, uids);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () => addMods(community),
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members[index];
                return ref.watch(getUserDateProvider(member)).when(
                    data: (user) {
                      if (community.mods.contains(user.uid) && ctl == 0) {
                        uids.add(user.uid);
                      }

                      return ListTile(
                        title: Text(user.name),
                        trailing: Checkbox(
                          value: uids.contains(user.uid),
                          onChanged: (value) {
                            ctl++;
                            if (value!) {
                              addUid(user.uid);
                            } else {
                              removedUid(user.uid);
                            }
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(text: error.toString()),
                    loading: (() => const Loader()));
              },
            ),
          ),
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => const Loader(),
        );
  }
}
