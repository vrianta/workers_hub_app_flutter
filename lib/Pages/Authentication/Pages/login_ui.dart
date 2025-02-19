import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/Alerts/one_exit.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Pages/Authentication/Components/text_fields.dart';
import 'package:wo1/Pages/Authentication/Pages/register_ui.dart';
import 'package:wo1/Pages/pages_main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final String login = "Login";

  final isPasswordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loadStoredCreds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }
        if (snapshot.hasData && snapshot.data!) {
          return _buildEmptyScreen();
        }
        return PopScope(
          canPop: false,
          child: _buildLoginScreen(context),
          onPopInvokedWithResult: (c, result) async => {onExit()},
        );
      },
    );
  }

  Future<bool> loadStoredCreds() async {
    String? username = await storage.read(key: "username");
    String? password = await storage.read(key: "password");

    userNameController.text = username ?? '';
    passwordController.text = password ?? '';

    if (username != null && password != null) {
      return onpressedLoginButton();
    }
    return false;
  }

  Future<bool> onpressedLoginButton() async {
    String userName = userNameController.text;
    String password = passwordController.text;

    if (isUserNameOrPasswordEmpty(userName, password)) {
      showToast("User Name and Password Field Can't be empty", Colors.red);
      return false;
    }

    ApiHandler apiHandler = ApiHandler();
    await apiHandler.login(userName, password);
    var responseObj = jsonDecode(apiHandler.response);

    if (!responseObj["SUCCESS"]) {
      showToast("Some issue", Colors.red);
    }
    if (responseObj["CODE"] == "RELOGIN") {
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
    ApiHandler.userDetails.set(jsonDecode(loginDetails["user_details"])[0]);
    ApiHandler.uid = userName;
    ApiHandler.isActivated = loginDetails["Activate"];

    showToast("Logged in successfully", Colors.green);
    storeCreds(userName, password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PagesMain(
          userDetails: ApiHandler.userDetails,
          isActivated: ApiHandler.isActivated,
          accountType: ApiHandler.accountType,
        ),
      ),
    );

    return true;
  }

  bool isUserNameOrPasswordEmpty(String userName, String password) {
    return userName.isEmpty || password.isEmpty;
  }

  void showToast(String message, Color color) async {
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

  void storeCreds(String userName, String password) async {
    await storage.write(key: "username", value: userName);
    await storage.write(key: "password", value: password);
  }

  Widget _buildLoadingScreen() {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          widthFactor: 10,
          child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(
                  255, 247, 247, 247), // Use a color for the background
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the form
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
                        "Login",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      usernameTextField(userNameController),
                      passwordTextField(passwordController, isPasswordVisible),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: onpressedLoginButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
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
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
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

  void onExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertOnExit();
      },
    );
  }
}
