import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Models/languages.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _requirementController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _minHeightController = TextEditingController();
  final TextEditingController _minRatingController = TextEditingController();
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _eventType;
  String? _language;
  bool _foodProvided = false;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool isCreateInitiated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSection("Event Name", _eventNameController),
              const Divider(),
              _buildDropdownSection(
                  "Select Event Type",
                  _eventType,
                  Event.eventCategories.entries.map((element) {
                    return DropdownMenuItem<String>(
                      value: element.key,
                      child: Text(element.key),
                    );
                  }).toList(), (value) {
                setState(() {
                  _eventType = value;
                });
              }),
              const Divider(),
              _buildSection("Number of People Required", _requirementController,
                  keyboardType: TextInputType.number),
              const Divider(),
              _buildSection("Event Budget", _budgetController,
                  keyboardType: TextInputType.number),
              const Divider(),
              _buildHeightField(),
              const Divider(),
              _buildDropdownSection(
                "Minimum Rating",
                "1",
                [
                  DropdownMenuItem(value: "0", child: Text("0")),
                  DropdownMenuItem(value: "1", child: Text("1")),
                  DropdownMenuItem(value: "2", child: Text("2")),
                  DropdownMenuItem(value: "3", child: Text("3")),
                  DropdownMenuItem(value: "4", child: Text("4")),
                  DropdownMenuItem(value: "5", child: Text("5"))
                ],
                (value) {
                  setState(() {
                    _minRatingController.text = value!;
                  });
                },
              ),
              const Divider(),
              _buildSection("Minimum Age for Resources", _minAgeController,
                  keyboardType: TextInputType.number),
              const Divider(),
              _buildDateField("Event Date", _dateController, _selectDate),
              const Divider(),
              _buildDateField("Event Time", _timeController, _selectTime),
              const Divider(),
              _buildSwitchRow("Is Food Provided?", _foodProvided, (value) {
                setState(() {
                  _foodProvided = value;
                });
              }),
              const Divider(),
              _buildDropdownSection(
                  "Preferred Language",
                  _language,
                  Languages.supportedLanguages.map((element) {
                    return DropdownMenuItem<String>(
                      value: element,
                      child: Text(element),
                    );
                  }).toList(), (value) {
                setState(() {
                  _language = value;
                });
              }),
              const Divider(),
              _buildSection("Event Location", _locationController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: !isCreateInitiated
                    ? const Text("Create Event")
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a section with a title and input field
  Widget _buildSection(String title, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithInfo(title),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter a value" : null,
        ),
      ],
    );
  }

  // Helper method for dropdown section
  Widget _buildDropdownSection(String title, String? selectedValue,
      List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithInfo(title),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          ),
          items: items,
          onChanged: onChanged,
          validator: (value) => value == null ? "Please select a value" : null,
        ),
      ],
    );
  }

  // Helper method for date fields
  Widget _buildDateField(String title, TextEditingController controller,
      Future<void> Function(BuildContext) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithInfo(title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "Please select a value"
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for switch row
  Widget _buildSwitchRow(String title, bool value, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithInfo(title),
        const SizedBox(height: 8),
        SwitchListTile(
          value: value,
          onChanged: onChanged,
          title: const Text("Food Provided"),
        ),
      ],
    );
  }

  // Title with Info Icon
  Widget _buildTitleWithInfo(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            _showInfoDialog(title);
          },
        ),
      ],
    );
  }

  // Info Dialog
  void _showInfoDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Details for $title"),
        content: Text("More information about $title goes here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = "${date.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  // Time Picker
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeController.text =
            time.format(context); // Display time in 12-hour format
      });
    }
  }

  // Custom height field picker
  Widget _buildHeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithInfo("Minimum Height"),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectHeight(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _minHeightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "Please select a value"
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // Height picker
  Future<void> _selectHeight(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        int feet = 5; // Default value
        int inches = 3; // Default value
        return AlertDialog(
          title: const Text('Select Height'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Feet:'),
                  Expanded(
                    child: Slider(
                      value: feet.toDouble(),
                      min: 3,
                      max: 8,
                      divisions: 5,
                      label: "$feet",
                      onChanged: (value) {
                        setState(() {
                          feet = value.toInt();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Inches:'),
                  Expanded(
                    child: Slider(
                      value: inches.toDouble(),
                      min: 0,
                      max: 11,
                      divisions: 11,
                      label: "$inches",
                      onChanged: (value) {
                        setState(() {
                          inches = value.toInt();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _minHeightController.text = "$feet'$inches\"";
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {});
    }
  }

  Future<void> _submitForm() async {
    ApiHandler apiHandler = ApiHandler();

    String respose = await apiHandler.createEvent(
      eventName: _eventNameController.text,
      eventType: _eventType!,
      requirement: _requirementController.text,
      budget: _budgetController.text,
      minHeight: _minHeightController.text,
      minRating: _minRatingController.text,
      minAge: _minAgeController.text,
      date: _dateController.text,
      time: _timeController.text,
      foodProvided: _foodProvided ? "1" : "0",
      language: _language!,
      location: _locationController.text,
    );

    Map<String, dynamic> resposeObj = jsonDecode(respose);
    if (resposeObj.entries.isEmpty) {
      return;
    }

    // ignore: collection_methods_unrelated_type
    if (resposeObj["SUCCESS"] != true) {
      Fluttertoast.showToast(msg: resposeObj["MESSAGE"]);
      return;
    }

    // ignore: collection_methods_unrelated_type
    if (resposeObj.entries.contains("CODE") &&
        resposeObj["CODE"] == "EVENTCREATED") {}
    Fluttertoast.showToast(msg: "Event Created");
    Navigator.pop(context);
    // TODO: Call the `createEvent` function from ApiHandler here
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _requirementController.dispose();
    _budgetController.dispose();
    _minHeightController.dispose();
    _minRatingController.dispose();
    _minAgeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
