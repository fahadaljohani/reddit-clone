import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AbstractIndicator {
  MaterialColor color();
  Widget indicator();
  factory AbstractIndicator(TargetPlatform targetPlatform) {
    switch (targetPlatform) {
      case TargetPlatform.iOS:
        return IOSIndicator();
      case TargetPlatform.android:
        return AndroidIndicator();
      default:
        return AndroidIndicator();
    }
  }
}

class AndroidIndicator implements AbstractIndicator {
  @override
  MaterialColor color() {
    return Colors.blue;
  }

  @override
  Widget indicator() {
    return CircularProgressIndicator(
      color: color(),
    );
  }
}

class IOSIndicator implements AbstractIndicator {
  @override
  MaterialColor color() {
    return Colors.blue;
  }

  @override
  Widget indicator() {
    return CupertinoActivityIndicator(
      color: color(),
    );
  }
}
