// This File is used to give account details section and enable the user to edite the attributes

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/user_details.dart';

class UserDetailsPage extends StatefulWidget {
  final UserDetails userDetails;

  const UserDetailsPage({super.key, required this.userDetails});

  @override
  // ignore: library_private_types_in_public_api
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController ratingController;
  late TextEditingController experienceController;
  late TextEditingController workDoneController;
  late TextEditingController dobController;
  late TextEditingController heightController;
  late TextEditingController ageController;
  late TextEditingController genderController; // Added gender controller

  final ApiHandler apiHandler = ApiHandler();

  // Gender options
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    fullNameController =
        TextEditingController(text: widget.userDetails.fullName);
    phoneNumberController =
        TextEditingController(text: widget.userDetails.phoneNumber);
    ratingController =
        TextEditingController(text: widget.userDetails.rating.toString());
    experienceController = TextEditingController(
        text: widget.userDetails.experienceYear.toString());
    workDoneController =
        TextEditingController(text: widget.userDetails.workDone.toString());
    dobController = TextEditingController(text: widget.userDetails.dateOfBirth);
    heightController = TextEditingController(text: widget.userDetails.height);
    ageController =
        TextEditingController(text: widget.userDetails.age.toString());

    // Initialize gender controller
    genderController = TextEditingController(text: widget.userDetails.gender);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    ratingController.dispose();
    experienceController.dispose();
    workDoneController.dispose();
    dobController.dispose();
    heightController.dispose();
    ageController.dispose();
    genderController.dispose(); // Dispose gender controller
    super.dispose();
  }

  Future<void> _saveDetails() async {
    // Call backend API to save updated user details

    String response = await apiHandler.updateUser(
      fullNameController.text,
      phoneNumberController.text,
      dobController.text,
      heightController.text,
      genderController.text, // Include gender in the request
    );
    Map<String, dynamic> responseObj = jsonDecode(response);
    String message = responseObj["MESSAGE"];
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (responseObj["CODE"] == "USERUPDATED") {
      ApiHandler.userDetails.phoneNumber = phoneNumberController.text;
      ApiHandler.userDetails.height = heightController.text;
      ApiHandler.userDetails.gender = genderController.text; // Update gender
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // Format the selected date to string (e.g., "MM/DD/YYYY")
      dobController.text =
          "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (widget.userDetails.photoUrl.isNotEmpty)
                    ? NetworkImage(widget.userDetails.photoUrl)
                    : null, // No background image if URL is not valid
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Full Name
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
              readOnly: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              readOnly: false,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: "Date of Birth"),
                  readOnly: false,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Height
            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                  labelText: "Height (for 5'10\" use 5.10)"),
            ),
            const SizedBox(height: 16),
            // Rating
            TextField(
              controller: ratingController,
              decoration: const InputDecoration(labelText: "Rating"),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            // Experience
            TextField(
              controller: experienceController,
              decoration:
                  const InputDecoration(labelText: "Experience (Years)"),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            // Work Done
            TextField(
              controller: workDoneController,
              decoration: const InputDecoration(labelText: "Work Done"),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            // Age
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
              readOnly: false,
            ),
            const SizedBox(height: 16),
            // Gender Dropdown
            DropdownButtonFormField<String>(
              value:
                  genderController.text.isEmpty ? null : genderController.text,
              onChanged: (String? newValue) {
                setState(() {
                  genderController.text = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: "Gender"),
              items: genders.map<DropdownMenuItem<String>>((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
