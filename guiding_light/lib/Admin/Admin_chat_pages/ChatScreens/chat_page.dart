import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guiding_light/Admin/Admin_chat_pages/ChatScreens/selectpatient.dart';
import 'package:guiding_light/Admin/Admin_chat_pages/ChatScreens/therapychatcard.dart';
import 'package:guiding_light/constants/global_variables.dart';
import 'package:guiding_light/constants/utils.dart';
import 'package:guiding_light/models/everchat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class TherapyChatPage extends StatefulWidget {
  const TherapyChatPage({Key? key}) : super(key: key);
  static const String routeName = '/Therapy-chat-page';

  @override
  State<TherapyChatPage> createState() => _TherapyChatPageState();
}

class _TherapyChatPageState extends State<TherapyChatPage> {
  String? userProfile;
  List<ChatEverModel> chatsOnces = [];

  @override
  void initState() {
    super.initState();

    fetchMessages();
    //getUserData();
  }

  @override
  void dispose() {
    // Dispose of the socket connection and any listeners here
    // If there's a method to destroy the socket, use it
    super.dispose();
  }

  Future<void> fetchMessages() async {
    bool userDataRetrieved = await getUserData();
    if (userDataRetrieved) {
      var userData = jsonDecode(userProfile!);

      try {
        // Replace "YOUR_NODE_API_URL" with the actual URL of your Node.js API
        var response = await http.get(
          Uri.parse('$uri/everMessages?senderId=${userData['email']}'),
        );

        if (response.statusCode == 200) {
          // Parse the response JSON and update the messages list
          final List<dynamic> messagesData = jsonDecode(response.body);

          setState(() {
            chatsOnces = messagesData
                .map((messageJson) => ChatEverModel.fromJson(messageJson))
                .toList();
          });
        } else {
          // Handle errors when fetching messages
          print('Failed to fetch messages');
        }
      } catch (e) {
        // Handle exceptions when fetching messages
        print('Error fetching messages: $e');
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => const SelectPatientChat()));
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chatsOnces.length,
        itemBuilder: (context, index) =>
            TherapyChartCard(chatEverModel: chatsOnces[index]),
      ),
    );
  }

  Future<bool> getUserData() async {
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
        // var userProvider = Provider.of<UserProvider>(context, listen: false);
        // userProvider.setUser(jsonEncode(userData));
        userProfile = jsonEncode(userData);
        return true;
        // print('User Data: ${jsonEncode(userData)}');
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
