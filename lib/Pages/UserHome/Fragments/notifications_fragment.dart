import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';

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
    var data = jsonDecode(response);

    // Check for errors in response
    if (data["SUCCESS"] == false) {
      return [Center(child: Text(data["MESSAGE"]))];
    }

    List<Map<String, String>> notifications =
        List<Map<String, String>>.from(data["MESSAGE"].map((item) {
      return {
        'title': item['Heading'],
        'message': item['Description'],
        'date': item['created'],
      };
    }));

    // Create list of notification cards
    List<Widget> notificationCards = notifications.map((notification) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Text(
            notification['title']!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            notification['message']!,
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
            notification['date']!,
            style: TextStyle(fontSize: 12, color: Colors.grey),
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

  @override
  void initState() {
    super.initState();

    notificationCards = getNotificationCards();
  }

  // initState
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      color: Colors.blueAccent,
      child: FutureBuilder<List<Widget>>(
        future: notificationCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading notifications"));
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
