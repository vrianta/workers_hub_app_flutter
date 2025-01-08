import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wo1/Pages/Login/Components/login_button.dart';
import 'package:wo1/Pages/Login/Components/text_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late LoginButton loginButton;

  @override
  void initState() {
    super.initState();
    loginButton = LoginButton(
      userNameController: userNameController,
      passwordCotroller: passwordController,
    );
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
                  )), // Show loading while waiting for the result
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
                      loginButton
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
        context,
        userNameController,
        passwordController,
      );
    }

    return false;
  }
}
