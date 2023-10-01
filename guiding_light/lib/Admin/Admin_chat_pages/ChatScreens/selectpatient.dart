import 'dart:convert';
import 'package:guiding_light/Admin/Admin_chat_pages/ChatScreens/selectpatientchartcard.dart';
import 'package:guiding_light/constants/global_variables.dart';
import 'package:guiding_light/models/ChatModel.dart';
import 'package:guiding_light/models/selectChatModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SelectPatientChat extends StatefulWidget {
  const SelectPatientChat({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectPatientChat> createState() => _SelectPatientChatState();
}

class _SelectPatientChatState extends State<SelectPatientChat> {
  List<SelectChatModel> chatting = [];
  late final int selectedChatIndex;

  @override
  void initState() {
    super.initState();
    fetchAdminUsers();
  }

  Future<void> fetchAdminUsers() async {
    try {
      // Make an HTTP request to fetch the admin users from your backend
      var response = await http.get(Uri.parse('$uri/usersOnly'));

      if (response.statusCode == 200) {
        // If the request is successful (status code 200), parse the response body
        // and update the chatting list with the retrieved users
        var jsonData = jsonDecode(response.body);

        setState(() {
          chatting = List<SelectChatModel>.from(jsonData.map((user) =>
              SelectChatModel(
                  name: user['name'],
                  status: user['type'],
                  id: user['email'])));
        });
      } else {
        // Handle any errors or non-200 status codes
        print(
            'Failed to fetch admin users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error fetching admin users: $e');
    }
  }

  List<ChatModel> convertToChatModels(List<SelectChatModel> selectChatModels) {
    return selectChatModels.map((selectChatModel) {
      return ChatModel(
        name: selectChatModel.name,
        icon: '', // Provide the appropriate value for icon
        time: '', // Provide the appropriate value for time
        currentMessage: '', // Provide the appropriate value for currentMessage
        isGroup: false, // Provide the appropriate value for isGroup
        id: selectChatModel.id,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatModel> chatModels = convertToChatModels(chatting);
    return Scaffold(
      appBar: AppBar(
        title: const Column(children: [Text('Select the reciepient')]),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 26))
        ],
      ),
      body: ListView.builder(
        itemCount: chatting.length,
        itemBuilder: (context, index) => SelectPatientChatCard(
          chatUser: chatting[index],
          chatModel: chatModels[index],
        ),
      ),
    );
  }
}
