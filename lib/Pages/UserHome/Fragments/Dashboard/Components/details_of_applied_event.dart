import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/Alerts/confirmation.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';

class AppliedEventDetailsPage extends StatefulWidget {
  final Event event;
  final Function() onClose;

  const AppliedEventDetailsPage(
      {super.key, required this.event, required this.onClose});

  @override
  State<AppliedEventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<AppliedEventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(widget.event.eventID),
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildDetailRow('Event Type', widget.event.eventType),
                  _buildDetailRow(
                      'Requirement', widget.event.eventRequirement.toString()),
                  _buildDetailRow('Budget', '\$${widget.event.eventBudget}'),
                  _buildDetailRow('Minimum Height',
                      widget.event.eventMinimumHeight.toString()),
                  _buildDetailRow('Minimum Rating',
                      widget.event.eventMinimumRating?.toString() ?? 'N/A'),
                  _buildDetailRow('Minimum Age',
                      widget.event.eventMinimumAge?.toString() ?? 'N/A'),
                  _buildDetailRow('Date', widget.event.eventDate),
                  _buildDetailRow('Time', widget.event.eventTime),
                  _buildDetailRow('Food Provided',
                      widget.event.foodProvided ? 'Yes' : 'No'),
                  _buildDetailRow(
                      'Language', widget.event.eventLanguage ?? 'N/A'),
                  _buildDetailRow('Location', widget.event.eventLocation),
                  _buildDetailRow('Owner ID', widget.event.ownerID),
                ],
              ),
            ),
            widrawButton(widget.event),
          ],
        ),
      ),
    );
  }

  SizedBox widrawButton(Event e) {
    if (e.confirmed == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            withdrawEvent(widget.event.eventID);
          },
          child: Text('Withdraw'),
        ),
      );
    }

    return SizedBox(height: 0);
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void withdrawEvent(String eventId) async {
    bool confirmApply = await showConfirmationDialog(
        context, "Please Confirm if you want to Widraw");
    if (!confirmApply) {
      return;
    }

    String response = await ApiHandler().withdrawFromEvent(eventId);

    Map<String, dynamic> responseObj = jsonDecode(response);

    if (responseObj["CODE"] == "RELOGIN") {
      setState(() {
        Navigator.pop(context);
      });

      return;
    }

    if (responseObj["CODE"] == "WITHDRAWALSUCCESS") {
      setState(() {
        widget.onClose();
      });
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
