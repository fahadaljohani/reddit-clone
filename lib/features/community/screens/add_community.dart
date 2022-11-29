import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/community/controller/community_contoller.dart';

class AddCommunity extends ConsumerStatefulWidget {
  const AddCommunity({super.key});

  @override
  ConsumerState<AddCommunity> createState() => _AddCommunityState();
}

class _AddCommunityState extends ConsumerState<AddCommunity> {
  TextEditingController communityNameController = TextEditingController();

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('create community'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          const Text(
            'community name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: communityNameController,
            decoration: InputDecoration(
              hintText: '/r/Enter community name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(10),
            ),
            maxLength: 21,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: createCommunity,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Create Community',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
