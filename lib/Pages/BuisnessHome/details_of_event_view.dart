import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Models/user_details.dart';
import 'package:wo1/Widget/cards.dart';

class DetailsOfEventView extends StatefulWidget {
  const DetailsOfEventView({super.key, required this.event});

  final Event event;

  @override
  State<DetailsOfEventView> createState() => _DetailsOfEventViewState();
}

class _DetailsOfEventViewState extends State<DetailsOfEventView> {
  late ApiHandler apiHandler;

  @override
  void initState() {
    apiHandler = ApiHandler();
    super.initState();
  }

  Future<Map<String, dynamic>> getEventProgress() async {
    String response =
        await apiHandler.getEventsCreatedByBuisness(widget.event.eventID);

    Map<String, dynamic> responseObj = jsonDecode(response);
    if (!responseObj["SUCCESS"]) {
      return Future.value({});
    }

    return responseObj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: getEventProgress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: SizedBox(
                  height: 40,
                  child: Text(
                      "Your Event is not Activated Yet wait for manager assignment and he is talk to you for the farhter steps"),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Manager Has assinged to your event"),
              );
            }
            if (snapshot.data!["SUCCESS"] == false) {
              return const Center(
                child: Text("No Manager Has assinged to your event"),
              );
            }

            UserDetails manager =
                UserDetails.fromJson(jsonDecode(snapshot.data!["Manager"])[0]);

            Map<String, dynamic> assignedUsers =
                jsonDecode(snapshot.data!["AssingedUsers"]);
            return Column(
              children: [
                displaManagerDetails(manager),
                Divider(
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: renderAssingedUsersCards(assignedUsers),
                ),
              ],
            );
          },
        ));
  }

  dynamic renderAssingedUsersCards(Map<String, dynamic> assignedUsers) {
    if (assignedUsers.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        // Set your desired background color
        width: double.infinity, // Ensure full width
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No Users are Assinged till Yet wait Until Manager start recruting.",
              style: TextStyle(
                fontSize: 18, // Adjust size as needed
                fontWeight: FontWeight.w600, // Semi-bold for better readability
                color: Theme.of(context).primaryColor, // Ensures good contrast
                fontFamily:
                    'Roboto', // Modern and clean font (change if needed)
                letterSpacing: 1.2, // Improves readability
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: assignedUsers.length,
      itemBuilder: (context, index) {
        String userId = assignedUsers.keys.elementAt(index);
        UserDetails assignedUser =
            UserDetails.fromJson(jsonDecode(assignedUsers[userId]!)[0]);
        return assignedUserCard(assignedUser);
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.event.eventName),
      titleTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
      ),
    );
  }

  Widget displaManagerDetails(UserDetails manager) {
    if (manager.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        // Set your desired background color
        width: double.infinity, // Ensure full width
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Wait Untill a Manager is assinged",
              style: TextStyle(
                fontSize: 18, // Adjust size as needed
                fontWeight: FontWeight.w600, // Semi-bold for better readability
                color: Theme.of(context).primaryColor, // Ensures good contrast
                fontFamily:
                    'Roboto', // Modern and clean font (change if needed)
                letterSpacing: 1.2, // Improves readability
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20), // Set your desired background color
      width: double.infinity, // Ensure full width
      child: Row(
        spacing: 10,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(85, 158, 158, 158),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(manager.photoUrl),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              radius: 50,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manager.fullName,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.2,
                ),
              ),
              managerDetailsText(
                  manager.phoneNumber, Icons.phone_android_outlined)
            ],
          ),
        ],
      ),
    );
  }

  Widget managerDetailsText(dynamic value, IconData iconData) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Theme.of(context).primaryColor, // Ensuring icon matches theme
          size: 22, // Adjust size as needed
        ),

        const SizedBox(width: 8), // Adds spacing between icon and text
        Text(
          "$value",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
            fontFamily: 'Roboto',
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
