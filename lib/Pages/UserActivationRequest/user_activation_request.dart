import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wo1/Models/user_details.dart';

class UserNotActivated extends StatelessWidget {
  const UserNotActivated({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20), // Adjusted padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your account is not activated yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20), // Added space between text and button
              RichText(
                textAlign: TextAlign.center, // Center text in the button
                text: TextSpan(
                  text:
                      "Fill the Form to Activate your account\nYou will get a call from our team after that to verify",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  const url = 'https://www.google.com'; // Replace with your URL
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: RichText(
                  textAlign: TextAlign.center, // Center text in the button
                  text: TextSpan(
                    text: 'Activation Form',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
