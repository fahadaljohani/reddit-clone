import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text('feed screen'),
    );
  }
}
