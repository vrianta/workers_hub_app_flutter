import 'package:flutter/material.dart';
import 'package:wo1/Alerts/one_exit.dart';
import 'package:wo1/APIHandler/api_handler.dart';
import 'package:wo1/Models/user_details.dart';
import 'package:wo1/Pages/Authentication/Pages/login_ui.dart';
import 'package:wo1/Pages/UserHome/Components/buttom_navigation.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/Page/accounts_details_edite.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/home_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/accounts_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/Dashboard/dashboard_fragment.dart';
import 'package:wo1/Pages/UserHome/Components/Notifications/notifications_fragment.dart';
import 'package:wo1/Pages/UserActivationRequest/user_activation_request.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userDetails, required this.isActivated});

  final UserDetails userDetails;
  final String isActivated;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final HomeFragment homeFragment;
  late final DashboardFragement dashboardFragement;
  late final NotificationsFragment notificationsFragment;
  late final AccountsFragment accountsFragement;

  dynamic pageToShow;

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
    if (widget.isActivated == "0") {
      return UserNotActivated(userDetails: widget.userDetails);
    }
    return body();
  }

  Scaffold body() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      drawer: drawer(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (c, result) async => {exitConfirmation()},
        child: IndexedStack(
          index: currentIndex,
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
          });
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
                    key: Key("UserDetails"),
                    userDetails: widget.userDetails,
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
                  transitionDuration: Duration(milliseconds: 300),
                ),
              );
            },
            child: Container(
              color: Theme.of(context).primaryColor, // Use primary color
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.userDetails.photoUrl),
                      radius: 40,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              (index) => Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                            ),
                          ),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 0;
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
              });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await ApiHandler().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
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
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 247, 247, 247),
              const Color.fromARGB(255, 247, 247, 247),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  // Exit confirmation dialog
  void exitConfirmation() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex = 0;
      });
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
