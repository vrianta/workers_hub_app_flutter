import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/Alerts/confirmation.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  final Function() onClose;

  const EventDetailsPage(
      {super.key, required this.event, required this.onClose});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.event.eventID,
      child: Scaffold(
        key: Key(widget.event.eventID),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 250.0,
          flexibleSpace: Stack(
            children: [
              Image.asset(
                key: Key("eventImage"),
                EventHandler.categoryImagePaths[
                        widget.event.eventType.toLowerCase()] ??
                    'lib/assets/images/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  title: Text(
                    'Event Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildDetailHeading('Event Name'),
                    _buildDetailRow(widget.event.eventName),
                    Divider(),
                    _buildDetailHeading('Event Type'),
                    _buildDetailRow(widget.event.eventType),
                    Divider(),
                    _buildDetailHeading('Requirement'),
                    _buildDetailRow(widget.event.eventRequirement.toString()),
                    Divider(),
                    _buildDetailHeading('Minimum Height'),
                    _buildDetailRow(widget.event.eventMinimumHeight.toString()),
                    Divider(),
                    _buildDetailHeading('Minimum Rating'),
                    _buildDetailRow(
                        widget.event.eventMinimumRating?.toString() ?? 'N/A'),
                    Divider(),
                    _buildDetailHeading('Minimum Age'),
                    _buildDetailRow(
                        widget.event.eventMinimumAge?.toString() ?? 'N/A'),
                    Divider(),
                    _buildDetailHeading('Date'),
                    _buildDetailRow(widget.event.eventDate),
                    Divider(),
                    _buildDetailHeading('Time'),
                    _buildDetailRow(widget.event.eventTime),
                    Divider(),
                    _buildDetailHeading('Food Provided'),
                    _buildDetailRow(widget.event.foodProvided ? 'Yes' : 'No'),
                    Divider(),
                    _buildDetailHeading('Language'),
                    _buildDetailRow(widget.event.eventLanguage ?? 'N/A'),
                    Divider(),
                    _buildDetailHeading('Location'),
                    _buildDetailRow(widget.event.eventLocation),
                    Divider(),
                    _buildDetailHeading('Owner ID'),
                    _buildDetailRow(widget.event.ownerID),
                    Divider(),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${widget.event.eventBudget}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                '/per person',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              applyToEvents(widget.event.eventID);
                            },
                            child: Text(
                              'Apply For Event',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          fontSize: 16.0,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String value, {TextStyle? style}) {
    return Text(
      value,
      style: style ??
          TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Theme.of(context).hintColor,
          ),
    );
  }

  void applyToEvents(String eventId) async {
    bool confirmApply = await showConfirmationDialog(
        context, "Please Confirm if you want to apply");
    if (!confirmApply) {
      return;
    }
    String response = await ApiHandler().applyToEvent(eventId);

    Map<String, dynamic> responseObj = jsonDecode(response);

    if (responseObj["CODE"] == "RELOGIN") {
      setState(() {
        Navigator.pop(context);
      });

      return;
    }

    if (responseObj["CODE"] == "APPLICATIONSUCCESS") {
      await Fluttertoast.showToast(
        msg: responseObj["MESSAGE"] ?? "Internal Error Occured",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      setState(() {
        widget.onClose();
      });
      return;
    }

    await Fluttertoast.showToast(
      msg: responseObj["MESSAGE"] ?? "Internal Error Occured",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
