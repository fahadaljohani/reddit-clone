import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';
import 'package:routemaster/routemaster.dart';

class SearchHomeScreenDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchHomeScreenDelegate({required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) {
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communities[index];
              return ListTile(
                onTap: () => navigateToCommunity(context, community.name),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar)),
                title: Text(community.name),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(text: error.toString()),
        loading: () => const Loader());
  }
}
