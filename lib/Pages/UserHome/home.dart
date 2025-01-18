import 'package:flutter/material.dart';
import 'package:wo1/Alerts/one_exit.dart';
import 'package:wo1/APIHandler/api_handler.dart';
import 'package:wo1/Models/user_details.dart';
import 'package:wo1/Pages/Login/login_ui.dart';
import 'package:wo1/Pages/UserHome/Components/buttom_navigation.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/Page/accounts_details_edite.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/home_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/accounts_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/Dashboard/dashboard_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/notifications_fragment.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final HomeFragment homeFragment;
  late final DashboardFragement dashboardFragement;
  late final NotificationsFragment notificationsFragment;
  late final AccountsFragment accountsFragement;

  dynamic pageToShow;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    homeFragment = HomeFragment();
    dashboardFragement = DashboardFragement();
    notificationsFragment = NotificationsFragment();
    accountsFragement = AccountsFragment(isBusinessUser: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      drawer: drawer(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (c, result) async => {exitConfirmation()},
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            homeFragment,
            dashboardFragement,
            // notificationsFragment,
            // accountsFragement,
          ],
        ),
      ),
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
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UserDetailsPage(
                    key: Key(
                        "UserDetails"), // Use the same key for smooth animation
                    userDetails: widget
                        .userDetails, // Correct reference to static member
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration:
                      Duration(milliseconds: 300), // Slower animation duration
                ),
              );
            },
            child: UserAccountsDrawerHeader(
              key: Key("UserDetails"), // Use the same key for smooth animation
              decoration: BoxDecoration(
                color:
                    Theme.of(context).primaryColor, // Match with current theme
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.userDetails
                    .photoUrl), // Correct reference to static member
                radius: 40, // Adjust the radius as needed
              ),
              accountName: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userDetails.fullName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: List.generate(
                      widget.userDetails.rating,
                      (index) =>
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                    ),
                  ),
                  SizedBox(height: 2), // Add space under the rating stars
                ],
              ),
              accountEmail: null, // Remove the default email field
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 0;
                _pageController.animateToPage(
                  currentIndex,
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  curve: Curves.easeInOut, // Smooth animation curve
                );
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: Text('Applied Events'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 1;
                _pageController.animateToPage(
                  currentIndex,
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  curve: Curves.easeInOut, // Smooth animation curve
                );
              });
            },
          ),
          Divider(), // Add a divider before the logout button
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              // Handle logout action
              Navigator.pop(context);
              await ApiHandler().logout(); // Call the logout method
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
              // Add your additional logout logic here if needed
            },
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.account_circle_outlined),
        onPressed: () {
          if (_scaffoldKey.currentState?.isDrawerOpen == false) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
      ),
      actions: [
        Hero(
          tag: "NotificationsHero",
          child: IconButton(
            key: Key("Notifications"),
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationsFragment()),
              );
            },
          ),
        ),
      ],
    );
  }

  // Exit confirmation dialog
  void exitConfirmation() {
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
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertOnExit();
      },
    );
  }
}
