import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Pages/Login/Components/text_fields.dart';
import 'package:wo1/Pages/UserHome/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loadStoredCreds(context), // Assuming this is a Future<bool>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                widthFactor: 10,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  color: Colors.black,
                ),
              ), // Show loading while waiting for the result
            ),
          );
        }
        // If credentials are found (true)
        if (snapshot.hasData && snapshot.data!) {
          // Show an empty page
          return MaterialApp(
            home: Scaffold(
              body: Container(), // Empty page, just a blank container
            ),
          );
        }
        // If login page is needed (no credentials found)
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      usernameTextField(userNameController),
                      passwordTextField(passwordController),
                      ElevatedButton(
                        onPressed: () => onpressedLoginButton(
                          userNameController,
                          passwordController,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6200EE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> loadStoredCreds(BuildContext context) async {
    const storage = FlutterSecureStorage();

    // Await the future to get the actual value
    String? username = await storage.read(key: "username");
    String? password = await storage.read(key: "password");

    // Assign the values to the text controllers
    userNameController.text = username ?? ''; // Default to empty if null
    passwordController.text = password ?? ''; // Default to empty if null

    if (username != null && password != null) {
      // ignore: use_build_context_synchronously
      return onpressedLoginButton(
        // ignore: use_build_context_synchronously
        userNameController,
        passwordController,
      );
    }

    return false;
  }

  Future<bool> onpressedLoginButton(TextEditingController userNameController,
      TextEditingController passwordController) async {
    String userName = userNameController.text;
    String password = passwordController.text;

    if (isUserNameOrPasswordEmpty(userName, password)) {
      showToast("User Name and Password Field Can't be empty",
          const Color.fromARGB(146, 250, 7, 7));
      return false;
    }
    ApiHandler apiHandler = ApiHandler();
    await apiHandler.login(userName, password);
    var responseObj = jsonDecode(apiHandler.response);

    if (responseObj["CODE"] == "RELOGIN") {
      // Auto login
      await apiHandler.login(userName, password);
      responseObj = jsonDecode(apiHandler.response);
    }

    if (responseObj["CODE"] != "LOGINDETAILS") {
      showToast(responseObj["CODE"], Colors.red);
      return false;
    }

    var loginDetails = jsonDecode(responseObj["MESSAGE"]);
    ApiHandler.api_token = loginDetails["token"];
    ApiHandler.accountType = loginDetails["accountType"];
    ApiHandler.userDetails
        .fromJson(jsonDecode(loginDetails["user_details"])[0]);
    ApiHandler.uid = userName;

    showToast("Logged in successfully", Colors.green);
    storeCreds(userName, password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(
                userDetails: ApiHandler.userDetails,
              )),
    );

    return true;
  }

  bool isUserNameOrPasswordEmpty(String userName, String password) {
    return (userName.isEmpty || password.isEmpty);
  }

  void showToast(String? massage, Color? testColor) async {
    await Fluttertoast.showToast(
      msg: massage ?? "Internal Error Occured",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void storeCreds(String userName, String password) async {
    var storage = FlutterSecureStorage();

    storage.write(key: "username", value: userName);
    storage.write(key: "password", value: password);
  }
}
