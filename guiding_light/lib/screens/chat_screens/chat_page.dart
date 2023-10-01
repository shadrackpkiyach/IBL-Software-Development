import 'package:flutter/material.dart';
import 'package:guiding_light/models/ChatModel.dart';
import 'package:guiding_light/screens/chat_screens/ChartCard.dart';
import 'package:guiding_light/screens/chat_screens/select_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chats = [
    ChatModel(
        name: "shaddy",
        isGroup: false,
        currentMessage: "sasa",
        time: "1:00",
        icon: " ",
        id: ''),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectChat()));
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) => ChartCard(chatModel: chats[index]),
      ),
    );
  }
}
