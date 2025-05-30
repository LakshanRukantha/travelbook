import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> messages = [];
  late Gemini gemini = Gemini.instance;

  ChatUser? human = ChatUser(
    id: '0',
    firstName: 'You',
    lastName: '',
  );
  Map<String, dynamic>? user;

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  void fetchUserData() async {
    Map<String, dynamic>? userData = await getCurrentUser();

    if (userData != null) {
      setState(() {
        user = userData;
        human = ChatUser(
          id: '0',
          firstName: userData["name"].split(" ")[0] ?? 'You',
          lastName: userData["name"].split(" ")[1] ?? '',
          profileImage: userData["userImage"] ?? '',
        );
      });
    } else {
      print("No user data found.");
    }
  }

  ChatUser ai = ChatUser(
    id: '1',
    firstName: 'Travel',
    lastName: 'Buddy',
    profileImage: "assets/images/travel_buddy.png",
  );

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
      body: user == null || human == null
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DashChat(
                messageOptions: MessageOptions(
                  showTime: true,
                  showOtherUsersName: true,
                  showCurrentUserAvatar: true,
                  showOtherUsersAvatar: true,
                  containerColor: Colors.teal,
                  textColor: Colors.white,
                  currentUserContainerColor:
                      const Color.fromARGB(255, 0, 113, 206),
                  currentUserTextColor: Colors.white,
                ),
                messageListOptions: MessageListOptions(
                  scrollPhysics: BouncingScrollPhysics(),
                  scrollController: ScrollController(),
                  showDateSeparator: true,
                ),
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
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                currentUser: human!,
                onSend: _sendMessage,
                messages: messages,
              ),
            ),
    );
  }

  void _sendMessage(ChatMessage message) async {
    setState(() => messages = [message, ...messages]);

    String accumulated = '';
    final response = ChatMessage(
      text: '',
      user: ai,
      createdAt: DateTime.now(),
    );

    setState(() => messages = [response, ...messages]);

    try {
      final travelPrompt = '''
You are a friendly, helpful, and knowledgeable travel assistant named "Travel Buddy." 

Only respond to questions strictly related to travel — such as trip planning, destinations, transportation, food, budgeting, accommodation, and travel safety.

If the user's question is unrelated to travel, politely explain that you can only help with travel-related topics.

If the user greets you (e.g., "hi", "hello", "hey") and says nothing else, introduce yourself as "Travel Buddy" and ask how you can help.

⚠️ Do not ask users any follow-up questions. Do not request more details. Just provide a clear and concise answer based only on what they asked.

Always write your answers using:
- Correct capitalization and punctuation
- Proper spacing between words
- Line breaks between paragraphs when needed


I am ${user!["name"].split(" ")[0] ?? "User"}: ${message.text}
''';
      final value = await gemini.prompt(parts: [Part.text(travelPrompt)]);
      print("Gemini response: ${value!.output}");
      if (value.output != null) {
        accumulated += value.output!
            .replaceAll('*', '')
            .replaceAll(' *', '')
            .replaceAllMapped(RegExp(r'([a-z])([A-Z])'),
                (m) => '${m[1]} ${m[2]}'); // fix glued words
        final index = messages.indexWhere(
            (m) => m.user.id == ai.id && m.createdAt == response.createdAt);

        if (index != -1) {
          setState(() {
            messages[index] = ChatMessage(
              text: accumulated,
              user: ai,
              createdAt: response.createdAt,
            );
          });
        }
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
