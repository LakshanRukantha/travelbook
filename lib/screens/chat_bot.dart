import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    messages.add(
      ChatMessage(
        text: 'Hey!',
        user: user,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Travel Buddy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: DashChat(
            messageOptions: MessageOptions(
              showTime: true,
              showOtherUsersName: true,
              showCurrentUserAvatar: true,
              showOtherUsersAvatar: true,
              currentUserContainerColor: const Color.fromARGB(255, 0, 113, 206),
              currentUserTextColor: Colors.white,
            ),
            messageListOptions: MessageListOptions(
                scrollPhysics: BouncingScrollPhysics(),
                showDateSeparator: true),
            inputOptions: InputOptions(
              textCapitalization: TextCapitalization.sentences,
              sendButtonBuilder: (send) {
                return IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: send,
                );
              },
              cursorStyle: CursorStyle(
                color: Colors.blue,
                width: 2,
              ),
              inputDecoration: InputDecoration(
                hintText: 'Ask me anything...',
                contentPadding:
                    EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            currentUser: user,
            onSend: (ChatMessage m) {
              setState(() {
                messages.insert(0, m);
              });
            },
            messages: messages),
      ),
    );
  }
}
