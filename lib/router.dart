import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/screens/login_screen.dart';
import 'package:reddit_tutorial/features/community/screens/add_community.dart';
import 'package:reddit_tutorial/features/community/screens/community_screen.dart';
import 'package:reddit_tutorial/features/home/screens/home_screen.dart';
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
  '/r/:routeName': (routeDate) => MaterialPage(
          child: CommunityScreen(
        name: routeDate.pathParameters['routeName']!,
      ))
});
