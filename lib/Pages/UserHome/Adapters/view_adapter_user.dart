import 'package:flutter/material.dart';

import '../Fragments/Home/home_fragment.dart';
import '../Fragments/accounts_fragment.dart';
import '../Fragments/dashboard_fragment.dart';
import '../Fragments/groups_fragment.dart';

class ViewAdapter {
  static List<Widget> fragments = [];

  static Widget getView(int currentIndex) {
    return fragments[currentIndex];
  }
}
