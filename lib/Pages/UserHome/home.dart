import 'package:flutter/material.dart';
import 'package:wo1/Alerts/one_exit.dart';
import 'package:wo1/Pages/UserHome/Components/buttom_navigation.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/home_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/accounts_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/dashboard_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/groups_fragment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final ScrollController singleChildScrollViewController = ScrollController();
  final ScrollController listViewController = ScrollController();

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtomNavigation(
        currentIndex: currentIndex,
        onTabSelected: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Smooth animation curve
            );
          });
          // Smooth page switching
        },
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (c, result) async => {exitConfirmation()},
        child: PageView(
          controller: _pageController,
          physics: const AlwaysScrollableScrollPhysics(), // Disable swipe
          children: [
            HomeFragment(
              listViewController: listViewController,
              singleChildScrollViewController: singleChildScrollViewController,
            ),
            DashboardFragement(),
            GroupsFragement(),
            AccountsFragement(),
          ],
        ),
      ),
    );
  }

  // Exit confirmation dialog
  void exitConfirmation() {
    bool isScrollJumping = false;
    if (currentIndex > 0) {
      setState(() {
        currentIndex = 0;
      });
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Smooth animation curve
      );
      return;
    } else {
      if (singleChildScrollViewController.offset != 0) {
        singleChildScrollViewController.animateTo(0,
            duration: const Duration(seconds: 1), curve: Curves.linear);
        isScrollJumping = true;
      }
      if (listViewController.offset != 0) {
        listViewController.animateTo(0,
            duration: const Duration(seconds: 1), curve: Curves.linear);
        isScrollJumping = true;
      }

      if (isScrollJumping) {
        return;
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertOnExit();
      },
    );
  }
}
