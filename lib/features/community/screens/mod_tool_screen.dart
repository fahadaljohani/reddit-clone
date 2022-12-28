import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/responsive/responsive.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends ConsumerWidget {
  final String communityId;
  const ModToolScreen({super.key, required this.communityId});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/edit-community/profile/$communityId');
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/r/edit-community/mod/$communityId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mod Tools'.tr(context),
          style: TextStyle(color: currentTheme.textTheme.bodyText1!.color),
        ),
        centerTitle: false,
      ),
      body: Responsive(
        child: Column(children: [
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
      ),
    );
  }
}
