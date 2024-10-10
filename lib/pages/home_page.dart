import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'api_service.dart'; // Import the ApiService
import 'chat_history_screen.dart'; // Import the chat history screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController questionController = TextEditingController();
  final ApiService apiService = ApiService(); // Instantiate ApiService

  List<Map<String, String>> _chatHistory = []; // To store both questions and answers
  bool _isLoading = false; // To track if the API call is in progress

  @override
  void initState() {
    super.initState();
    _loadChatHistory(); // Load chat history on initialization
  }

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  // Load chat history from shared preferences
  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('chatHistory');

    if (history != null) {
      setState(() {
        _chatHistory = history
            .map((item) => Map<String, String>.from(
                item.split('|').map((e) => e.trim().split(':')).fold<Map<String, String>>({}, (acc, elem) {
                  acc[elem[0]] = elem[1];
                  return acc;
                })))
            .toList();
      });
    }
  }

  // Save chat history to shared preferences
  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = _chatHistory.map((entry) => 'question: ${entry['question']}| answer: ${entry['answer']}').toList();
    await prefs.setStringList('chatHistory', history);
  }

  Widget _buildChatBubble(String message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Colors.blueAccent.withOpacity(0.7)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ai Quizitive'),
        leading: IconButton(
          icon: const Icon(Icons.menu), // Menu icon on the top left
          onPressed: () {
            // Navigate to chat history screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatHistoryScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: userSignOut,
            icon: const Icon(Icons.logout_sharp), // Logout button on top right
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                var entry = _chatHistory[index];
                String question = entry['question'] ?? '';
                String answer = entry['answer'] ?? '';
                
                return Column(
                  children: [
                    _buildChatBubble(question, true), // Question on the right
                    _buildChatBubble(answer, false), // Answer on the left
                  ],
                );
              },
            ),
          ),

          if (_isLoading) // Loading indicator when the app is waiting for a response
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: questionController, // Input area for the question
                    decoration: InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    String question = questionController.text.trim();
                    if (question.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                        _chatHistory.add({'question': question, 'answer': ''}); // Add the question to the history
                      });

                      // Use ApiService to send the question and get the answer
                      String? answer = await apiService.sendQuestionToApi(question);

                      setState(() {
                        _isLoading = false; // Stop the loading indicator
                        if (answer != null) {
                          _chatHistory[_chatHistory.length - 1]['answer'] = answer; // Add the answer to the chat history
                        } else {
                          _chatHistory[_chatHistory.length - 1]['answer'] =
                              'Failed to get a valid response'; // Handle API failure
                        }

                        // Save updated chat history to shared preferences
                        _saveChatHistory();
                      });

                      questionController.clear(); // Clear the input field
                    }
                  },
                  child: const Icon(Icons.send), // Send button inside/on top of input
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
