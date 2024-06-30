import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Map<String, dynamic>> conversations = [
    {
      'name': 'John Doe',
      'messages': [
        {'sender': 'John Doe', 'text': 'Hello!'},
        {'sender': 'You', 'text': 'Hi there!'},
        {'sender': 'John Doe', 'text': 'How are you doing?'},
        {'sender': 'You', 'text': 'I\'m doing great, thanks for asking.'},
      ],
    },
    {
      'name': 'Jane Smith',
      'messages': [
        {'sender': 'Jane Smith', 'text': 'Hey, what\'s up?'},
        {'sender': 'You', 'text': 'Not much, just chilling.'},
        {'sender': 'Jane Smith', 'text': 'Cool, wanna grab coffee later?'},
        {'sender': 'You', 'text': 'Sure, sounds good!'},
      ],
    },
    // Add more fake conversations here
  ];

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ListTile(
                  title: Text(conversation['name']),
                  onTap: () {
                    // Navigate to the conversation view
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationView(
                          name: conversation['name'],
                          messages: conversation['messages'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Send the message
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      setState(() {
                        conversations.first['messages'].add({
                          'sender': 'You',
                          'text': message,
                        });
                      });
                      _messageController.clear();
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationView extends StatelessWidget {
  final String name;
  final List<Map<String, dynamic>> messages;

  const ConversationView({
    Key? key,
    required this.name,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isYourMessage = message['sender'] == 'You';
                return Align(
                  alignment: isYourMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isYourMessage ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: isYourMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                // Send the message
              },
            ),
          ),
        ],
      ),
    );
  }
}
