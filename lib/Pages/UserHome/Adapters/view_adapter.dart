import 'package:flutter/material.dart';

class ViewAdapter {
  static List<Widget> fragments = [];

  static Widget getView(int currentIndex) {
    return fragments[currentIndex];
  }
}
