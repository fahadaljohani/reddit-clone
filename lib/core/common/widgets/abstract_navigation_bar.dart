import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AbstractPlatfrom {
  Widget navigtionBar({
    required int currentIndex,
    required void Function(int)? onTap,
    required Color? activeColor,
    required Color? backgroundColor,
    required List<BottomNavigationBarItem> items,
  });

  factory AbstractPlatfrom(TargetPlatform targetPlatform) {
    switch (targetPlatform) {
      case TargetPlatform.android:
        return AndroidNavigationBar();
      case TargetPlatform.iOS:
        return IOSNavigationBar();
      default:
        return IOSNavigationBar();
    }
  }
}

class IOSNavigationBar implements AbstractPlatfrom {
  @override
  Widget navigtionBar(
      {required int currentIndex,
      required void Function(int p1)? onTap,
      required Color? activeColor,
      required Color? backgroundColor,
      required List<BottomNavigationBarItem> items}) {
    return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: activeColor,
        backgroundColor: backgroundColor,
        items: items);
  }
}

class AndroidNavigationBar implements AbstractPlatfrom {
  @override
  Widget navigtionBar(
      {required int currentIndex,
      required void Function(int p1)? onTap,
      required Color? activeColor,
      required Color? backgroundColor,
      required List<BottomNavigationBarItem> items}) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: backgroundColor,
        selectedItemColor: activeColor,
        items: items);
  }
}
