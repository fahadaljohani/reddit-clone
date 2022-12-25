import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends ConsumerWidget {
  final String name;
  const ModToolScreen({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/edit-community/profile/$name');
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/r/edit-community/mod/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mod Tools'.tr(context)),
      ),
      body: Column(children: [
        ListTile(
          onTap: () => navigateToAddMod(context),
          leading: const Icon(Icons.add_moderator),
          title: Text('Add Moderator'.tr(context)),
        ),
        ListTile(
          onTap: () => navigateToEditCommunity(context),
          leading: const Icon(Icons.edit),
          title: Text('Edit Community'.tr(context)),
        ),
      ]),
    );
  }
}
