// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guiding_light/Admin/admin_bottom_nav.dart';
import 'package:guiding_light/constants/error_handling.dart';
import 'package:guiding_light/constants/global_variables.dart';
import 'package:guiding_light/constants/navigation/bottomnav_bar.dart';
import 'package:guiding_light/constants/utils.dart';
import 'package:guiding_light/models/user.dart';
import 'package:guiding_light/providers/user_provider.dart';
import 'package:guiding_light/services/register_verification.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  // sign up user
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String phoneNumber}) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        phoneNumber: phoneNumber,
        address: '',
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationScreen(email)),
            );
          });
          showSnackBar(context, 'Account Created successfull, verify email');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String responseBody = res.body;
          Map<String, dynamic> responseJson = jsonDecode(responseBody);
          String token = responseJson['token'] as String;
          String type = responseJson['type'] as String;

          // Determine user type based on the response
          if (type == 'admin') {
            Future.microtask(() {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AdminBottomNavBar.routeName,
                (route) => true,
              );
            });
            // Handle admin login
            // Set the user type or perform any admin-specific actions
            // ...
          } else if (type == 'user') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomNavBar.routeName,
              (route) => true,
            );
            // Handle user login
            // Set the user type or perform any user-specific actions
            // ...
          }

          // Set the user data in the UserProvider
          // Provider.of<UserProvider>(context, listen: false)
          // .setUser(responseBody);

          // Set the token in shared preferences
          await prefs.setString('x-auth-token', token);
          getUserData(context);
          // Navigate to the appropriate screen
        },
      );
    } catch (e) {
      void showSnackBar(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
          String message) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', 'no S'); // empty string
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/getUserProfile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userData = jsonDecode(userRes.body);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(jsonEncode(userData));

        print('User Data: ${jsonEncode(userData)}');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
