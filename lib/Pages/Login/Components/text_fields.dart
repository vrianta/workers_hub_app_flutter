import 'package:flutter/material.dart';

var usernameTextField =
    (TextEditingController userNameController) => TextFormField(
          controller: userNameController,
          maxLength: 10,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.phone_android),
          ),
        );

var passwordTextField =
    (TextEditingController passwordController) => TextFormField(
          controller: passwordController,
          maxLength: 20,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.lock),
          ),
        );
