// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:guiding_light/Admin/Admin_chat_pages/ChatScreens/dmchatpage.dart';
import 'package:guiding_light/models/ChatModel.dart';
import 'package:guiding_light/models/selectChatModel.dart';

class SelectPatientChatCard extends StatelessWidget {
  SelectPatientChatCard(
      {Key? key, required this.chatUser, required this.chatModel})
      : super(key: key);
  final SelectChatModel chatUser;
  final ChatModel chatModel;
  List<SelectChatModel> chatting = [];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DmTherapyChatPage(
                    chatUser: SelectChatModel(
                        name: chatModel.name,
                        status: chatModel.name,
                        id: chatModel.id))));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 23,
          //child: SvgPicture.asset("person.svg"),
        ),
        title: Text(chatUser.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(
          chatUser.status,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
