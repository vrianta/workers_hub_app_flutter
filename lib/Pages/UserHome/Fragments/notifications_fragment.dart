import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationsFragment extends StatefulWidget {
  const NotificationsFragment({super.key});

  @override
  State<NotificationsFragment> createState() => _NotificationsFragmentState();
}

class _NotificationsFragmentState extends State<NotificationsFragment> {
  // Fetch notifications function

  late Future<List<Widget>> notificationCards;

  Future<List<Widget>> getNotificationCards() async {
    String response = await ApiHandler().getNotifications();
    var responseObj = jsonDecode(response);

    var notificatons = jsonDecode(responseObj["MESSAGE"]);
    // Check for errors in response
    if (responseObj["SUCCESS"] == false) {
      return [Center(child: Text(responseObj["MESSAGE"]))];
    }

    // Create list of notification cards
    List<Widget> notificationCards = notificatons.map<Widget>((notification) {
      return Card(
        margin: EdgeInsets.symmetric(
            vertical: 0.5, horizontal: 15), // Reduced vertical margin to 3
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          leading: Icon(Icons.notifications, color: Colors.blueAccent),
          title: Text(
            notification['Heading'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          subtitle: Text(
            notification['Description'],
            style: TextStyle(fontSize: 8),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification['Created'],
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  deleteNotification(notification['Description']);
                },
              ),
            ],
          ),
          onTap: () {
            // Handle tap if necessary (e.g., navigate to notification details)
            //print('Tapped on notification: ${notification['title']}');
          },
        ),
      );
    }).toList();

    return notificationCards;
  }

  Future<void> deleteNotification(String id) async {
    await ApiHandler().deleteNotifications(id);
    setState(() {
      notificationCards = getNotificationCards();
    });
    Fluttertoast.showToast(
      msg: "Notification deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();

    notificationCards = getNotificationCards();
  }

  // initState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Notifications')),
        backgroundColor: Colors.deepPurple, // Updated app bar color
      ),
      backgroundColor: Colors.grey[200], // Add this line for background color
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        color: Colors.blueAccent,
        child: FutureBuilder<List<Widget>>(
          future: notificationCards,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error loading notifications ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Notifications Found"));
            }

            List<Widget> notificationCards = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemCount: notificationCards.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return notificationCards[index];
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Refresh the page and load new notifications
  Future<void> _refreshPage() async {
    // Trigger the notificationCards to reload with new data
    setState(() {
      notificationCards = getNotificationCards();
    });
  }
}
