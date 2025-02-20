import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/user_details.dart';
import 'package:wo1/Pages/Authentication/Pages/login_ui.dart';
import 'package:wo1/Pages/BuisnessHome/buisiness_home.dart';
import 'package:wo1/Pages/UserHome/Components/Notifications/notifications_fragment.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/Page/accounts_details_edite.dart';
import 'package:wo1/Pages/UserHome/home.dart';

class PagesMain extends StatefulWidget {
  const PagesMain({
    super.key,
    required this.userDetails,
    required this.isActivated,
    required this.accountType,
  });

  final UserDetails userDetails;
  final String isActivated;
  final String accountType;

  @override
  State<PagesMain> createState() => _PagesMainState();
}

class _PagesMainState extends State<PagesMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          // Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await ApiHandler().logout();
              setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              });
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
        IconButton(
          key: Key("Notifications"),
          icon: Icon(Icons.notifications_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsFragment()),
            );
          },
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

  Widget body() {
    if (widget.accountType == "user") {
      return Home(
          userDetails: widget.userDetails, isActivated: widget.isActivated);
    }
    return BuinsessHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      drawer: drawer(),
      body: body(),
    );
  }
}
