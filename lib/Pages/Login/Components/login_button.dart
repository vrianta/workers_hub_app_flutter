import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Pages/UserHome/home.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController userNameController;
  final TextEditingController passwordCotroller;

  const LoginButton({
    required this.userNameController,
    required this.passwordCotroller,
    super.key,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onpressedLoginButton(
        context,
        widget.userNameController,
        widget.passwordCotroller,
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
    );
  }
}

Future<bool> onpressedLoginButton(
    BuildContext context,
    TextEditingController userNameController,
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
    showToast(responseObj["CODE"], Colors.red);
    ApiHandler.cookieHeader = "";
    return false;
  }
  if (responseObj["CODE"] != "LOGINDETAILS") {
    showToast(responseObj["CODE"], Colors.red);
    return false;
  }

  var loginDetails = jsonDecode(responseObj["MESSAGE"]);
  ApiHandler.api_token = loginDetails["token"];
  ApiHandler.accountType = loginDetails["accountType"];
  ApiHandler.userDetails.fromJson(jsonDecode(loginDetails["user_details"])[0]);
  ApiHandler.uid = userName;

  showToast("Logged in successfully", Colors.green);
  storeCreds(userName, password);

  Navigator.pushReplacement(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => Home()),
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
