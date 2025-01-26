import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Pages/Authentication/Components/text_fields.dart';
import 'package:wo1/Pages/Authentication/Pages/login_ui.dart'; // Import text fields

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;

  @override
  void dispose() {
    aadhaarController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 247, 247, 247),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Register',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      aadhaarTextField(
                          aadhaarController), // Use aadhaar text field
                      emailTextField(emailController), // Use email text field
                      phoneTextField(phoneController), // Use phone text field
                      passwordTextField(
                          passwordController), // Use password text field
                      confirmPasswordTextField(
                          confirmPasswordController), // Use confirm password text field
                      // if (isOtpSent)
                      //   otpTextField(otpController), // Use OTP text field
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          bool isoptSucceded = await _sendOtp();
                          if (isoptSucceded) {
                            await _showOtpDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _sendOtp() async {
    String aadhaar = aadhaarController.text;
    String fullName = fullNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (aadhaar.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showToast("All fields are required", Colors.red);
      return false;
    }

    if (password != confirmPassword) {
      _showToast("Passwords do not match", Colors.red);
      return false;
    }

    ApiHandler apiHandler = ApiHandler();
    String response =
        await apiHandler.register(aadhaar, fullName, password, email, phone);
    var responseObj = jsonDecode(response);

    if (responseObj["SUCCESS"]) {
      setState(() {
        isOtpSent = true;
      });
      _showToast(
          "OTP sent to your $email", Colors.green); // Open popup asking for OTP
      return true;
    } else {
      _showToast(responseObj["MESSAGE"], Colors.red);
      return false;
    }
  }

  void _registerWithOtp() async {
    String aadhaar = aadhaarController.text;
    String fullName = fullNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String otp = otpController.text;

    if (otp.isEmpty) {
      _showToast("OTP is required", Colors.red);
      return;
    }

    ApiHandler apiHandler = ApiHandler();
    await apiHandler.registerWithOtp(
        aadhaar, fullName, password, email, phone, otp);
    var responseObj = jsonDecode(apiHandler.response);

    if (responseObj["SUCCESS"]) {
      _showToast("Registered successfully", Colors.green);
      await storeCreds(aadhaar, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      _showToast(responseObj["MESSAGE"], Colors.red);
    }
  }

  void _showToast(String message, Color color) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _showOtpDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter OTP"),
          content: TextField(
            controller: otpController,
            decoration: const InputDecoration(hintText: "OTP"),
          ),
          actions: [
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop();
                _registerWithOtp();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> storeCreds(String userName, String password) async {
    await storage.write(key: "username", value: userName);
    await storage.write(key: "password", value: password);
  }
}
