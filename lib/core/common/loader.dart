import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/common/widgets/abstract_factory.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: AbstractFactoryImp.indicatorAdaptive(context));
  }
}
