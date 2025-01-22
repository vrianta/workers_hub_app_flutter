import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefixIcon,
  bool obscureText = false,
  int maxLength = 50,
}) {
  return TextFormField(
    controller: controller,
    maxLength: maxLength,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: Icon(prefixIcon),
    ),
  );
}

var usernameTextField =
    (TextEditingController userNameController) => customTextField(
          controller: userNameController,
          labelText: 'Adhar Card Number',
          prefixIcon: Icons.phone_android,
          maxLength: 12,
        );

var passwordTextField =
    (TextEditingController passwordController) => customTextField(
          controller: passwordController,
          labelText: 'Password',
          prefixIcon: Icons.lock,
          obscureText: true,
          maxLength: 20,
        );

var aadhaarTextField =
    (TextEditingController aadhaarController) => customTextField(
          controller: aadhaarController,
          labelText: 'Aadhaar Number',
          prefixIcon: Icons.credit_card,
          maxLength: 12,
        );

var emailTextField = (TextEditingController emailController) => customTextField(
      controller: emailController,
      labelText: 'Email',
      prefixIcon: Icons.email,
      maxLength: 50,
    );

var phoneTextField = (TextEditingController phoneController) => customTextField(
      controller: phoneController,
      labelText: 'Phone Number',
      prefixIcon: Icons.phone,
      maxLength: 10,
    );

var confirmPasswordTextField =
    (TextEditingController confirmPasswordController) => customTextField(
          controller: confirmPasswordController,
          labelText: 'Confirm Password',
          prefixIcon: Icons.lock,
          obscureText: true,
          maxLength: 20,
        );

var otpTextField = (TextEditingController otpController) => customTextField(
      controller: otpController,
      labelText: 'OTP',
      prefixIcon: Icons.security,
      maxLength: 6,
    );
