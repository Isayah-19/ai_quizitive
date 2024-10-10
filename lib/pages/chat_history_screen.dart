import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  Future<List<Map<String, String>>> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('chatHistory');

    if (history != null) {
      return history
          .map((item) => Map<String, String>.from(
              item.split('|').map((e) => e.trim().split(':')).fold<Map<String, String>>({}, (acc, elem) {
                acc[elem[0]] = elem[1];
                return acc;
              })))
          .toList();
    }
    return []; // Return an empty list if no history is found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _loadChatHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var chatHistory = snapshot.data ?? [];

          return ListView.builder(
            itemCount: chatHistory.length,
            itemBuilder: (context, index) {
              var entry = chatHistory[index];
              String question = entry['question'] ?? '';
              String answer = entry['answer'] ?? '';

              return ListTile(
                title: Text('Q: $question'),
                subtitle: Text('A: $answer'),
              );
            },
          );
        },
      ),
    );
  }
}
