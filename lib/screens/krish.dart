import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class krish extends StatefulWidget {
  const krish({Key? key}) : super(key: key);

  @override
  State<krish> createState() => _krishState();
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _krishState extends State<krish> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  // Replace with your actual Gemini API key and endpoint
  static const String _geminiApiKey = 'AIzaSyD0CzTtQDxwnLstJSIT_GMyVbkIcrTB5lg';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyD0CzTtQDxwnLstJSIT_GMyVbkIcrTB5lg'; // Correct API endpoint

  Future<void> _sendMessage(String prompt) async {
    if (prompt.isEmpty) return;
    setState(() {
      _messages.insert(0, ChatMessage(text: prompt, isUser: true));
      _isSending = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_geminiApiUrl), // Use the correct _geminiApiUrl
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];

        setState(() {
          _messages.insert(0, ChatMessage(text: reply, isUser: false));
        });
      } else {
        setState(() {
          _messages.insert(0, ChatMessage(text: 'Error: ${response.statusCode}, ${response.body}', isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(text: 'Error: $e', isUser: false));
      });
    } finally {
      setState(() {
        _isSending = false;
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Krish'),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.purple[300] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isSending) const LinearProgressIndicator(color: Colors.purple),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Ask Krish...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}