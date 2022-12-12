import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/screens/login_screen.dart';
import 'package:reddit_tutorial/features/community/screens/add_community.dart';
import 'package:reddit_tutorial/features/community/screens/add_moderator.dart';
import 'package:reddit_tutorial/features/community/screens/community_screen.dart';
import 'package:reddit_tutorial/features/community/screens/edit_community_screen.dart';
import 'package:reddit_tutorial/features/community/screens/mod_tool_screen.dart';
import 'package:reddit_tutorial/features/home/screens/home_screen.dart';
import 'package:reddit_tutorial/features/profile/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: HomeScreen(),
      ),
  '/add-community': (_) => const MaterialPage(
        child: AddCommunity(),
      ),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/r/mod-tool/:name': (route) => MaterialPage(
        child: ModToolScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/r/edit-community/profile/:name': (route) => MaterialPage(
        child: EditCommunityScreen(name: route.pathParameters['name']!),
      ),
  '/r/edit-community/mod/:name': (route) => MaterialPage(
        child: AddModeratorScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/u/profile': (_) => const MaterialPage(
        child: ProfileScreen(),
      ),
});
