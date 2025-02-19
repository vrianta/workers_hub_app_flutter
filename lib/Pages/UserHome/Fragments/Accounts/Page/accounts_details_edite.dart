import 'package:flutter/material.dart';
import 'package:wo1/Models/user_details.dart';

class UserDetailsPage extends StatefulWidget {
  final UserDetails userDetails;

  const UserDetailsPage({super.key, required this.userDetails});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final List<String> genders = ['Male', 'Female', 'Other'];

  String selectedGender = 'Male';
  DateTime? selectedDate;
  bool isEditingEmail = false;
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the email controller with the user's email
    emailController.text = widget.userDetails.email;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void _saveEmail() {
    setState(() {
      isEditingEmail = false;
    });
    // Add your logic to update the email here
    // print("Updated Email: ${emailController.text.trim()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Photo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (widget.userDetails.photoUrl.isNotEmpty)
                    ? NetworkImage(widget.userDetails.photoUrl)
                    : null,
                child: widget.userDetails.photoUrl.isEmpty
                    ? Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Full Name (Read-only)
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Full Name"),
              subtitle: Text(widget.userDetails.fullName),
            ),

            // Email (Editable with Edit Icon)
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: isEditingEmail
                  ? TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      onFieldSubmitted: (_) => _saveEmail(),
                    )
                  : Text(emailController.text),
              trailing: IconButton(
                icon: Icon(isEditingEmail ? Icons.check : Icons.edit),
                onPressed: () {
                  if (isEditingEmail) {
                    _saveEmail();
                  } else {
                    setState(() {
                      isEditingEmail = true;
                    });
                  }
                },
              ),
            ),

            // Phone Number (Read-only)
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Phone Number"),
              subtitle: Text(widget.userDetails.phoneNumber),
            ),

            // Date of Birth (Read-only with Edit Icon)
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Date of Birth"),
              subtitle: Text(
                selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : widget.userDetails.dateOfBirth,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _selectDate(context),
              ),
            ),

            // Gender (Read-only)
            ListTile(
              leading: const Icon(Icons.wc),
              title: const Text("Gender"),
              subtitle: Text(widget.userDetails.gender),
            ),
          ],
        ),
      ),
    );
  }
}
