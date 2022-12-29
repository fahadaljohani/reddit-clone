import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/common/widgets/abstract_indicator.dart';
import 'package:reddit_tutorial/core/common/widgets/abstract_navigation_bar.dart';

class AbstractFactoryImp {
  static Widget indicatorAdaptive(BuildContext context) {
    return AbstractIndicator(Theme.of(context).platform).indicator();
  }

  static Widget navigationAdaptive(
      {required int currentIndex,
      required void Function(int p1)? onTap,
      required Color? activeColor,
      required Color? backgroundColor,
      required List<BottomNavigationBarItem> items,
      required BuildContext context}) {
    return AbstractNavigationBar(Theme.of(context).platform).navigtionBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: activeColor,
        backgroundColor: backgroundColor,
        items: items);
  }
}
