import 'package:flutter/material.dart';

class HeadingTextView extends StatelessWidget {
  final String data;
  const HeadingTextView({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        data,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: Theme.of(context).primaryColor,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
