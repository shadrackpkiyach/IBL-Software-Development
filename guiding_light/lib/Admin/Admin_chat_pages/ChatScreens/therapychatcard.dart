import 'package:flutter/material.dart';

import 'package:guiding_light/Admin/Admin_chat_pages/ChatScreens/dmchatpage.dart';
import 'package:guiding_light/models/everchat.dart';
import 'package:guiding_light/models/selectChatModel.dart';

class TherapyChartCard extends StatelessWidget {
  const TherapyChartCard({Key? key, required this.chatEverModel})
      : super(key: key);
  final ChatEverModel chatEverModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DmTherapyChatPage(
                    chatUser: SelectChatModel(
                        name: chatEverModel.name,
                        status: chatEverModel.name,
                        id: chatEverModel.senderId))));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 32,
            ),
            title: Text(
              chatEverModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: const Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                //Text(
                // chatEverModel.currentMessage,
                // style: const TextStyle(
                // fontSize: 13,
                // ),
                // ),
              ],
            ),
            //trailing: Text(chatEverModel.time),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1.5,
            ),
          )
        ],
      ),
    );
  }
}
